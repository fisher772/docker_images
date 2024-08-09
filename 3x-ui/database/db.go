package database

import (
        "bytes"
        "io"
        "io/fs"
        "log"
        "os"
        "path"
        "fmt"
        "crypto/rand"
        "path/filepath"
        "encoding/base64"

        "x-ui/config"
        "x-ui/database/model"
        "x-ui/xray"

        "gorm.io/driver/sqlite"
        "gorm.io/gorm"
        "gorm.io/gorm/logger"
)

var db *gorm.DB

func initCreds(length int) (string, error) {
    bytes := make([]byte, length)
    var err error
    _, err = rand.Read(bytes)
    if err != nil {
        return "", err
    }
    return base64.RawURLEncoding.EncodeToString(bytes), nil
}

func initSaveCreds(username, password string, filePath string) error {
    credsFolderPath := config.GetCredsFolderPath()
    var err error
    err = os.MkdirAll(credsFolderPath, fs.ModePerm)
    if err != nil {
        return err
    }
    content := fmt.Sprintf("Login: %s\nPassword: %s\n", username, password)
    err = os.WriteFile(filePath, []byte(content), 0600)
    if err != nil {
        return err
    }
    return nil
}

var (
        defaultUsername = ""
        defaultPassword = ""
)

const (
        defaultSecret   = ""
)

func initModels() error {
        models := []interface{}{
                &model.User{},
                &model.Inbound{},
                &model.OutboundTraffics{},
                &model.Setting{},
                &model.InboundClientIps{},
                &xray.ClientTraffic{},
        }
        for _, model := range models {
                if err := db.AutoMigrate(model); err != nil {
                        log.Printf("Error auto migrating model: %v", err)
                        return err
                }
        }
        return nil
}

func initUser() error {
    empty, err := isTableEmpty("users")
    if err != nil {
        log.Printf("Error checking if users table is empty: %v", err)
        return err
    }
    if empty {
        defaultUsername, err := initCreds(12)
        if err != nil {
            log.Printf("Error generating default username: %v", err)
            return err
        }
        defaultPassword, err := initCreds(24)
        if err != nil {
            log.Printf("Error generating default password: %v", err)
            return err
        }
        credsFolderPath := config.GetCredsFolderPath()
        initSaveCreds(defaultUsername, defaultPassword, filepath.Join(credsFolderPath, "credentials.txt"))

        user := &model.User{
            Username:    defaultUsername,
            Password:    defaultPassword,
            LoginSecret: defaultSecret,
        }
        return db.Create(user).Error
    }
    return nil
}

func isTableEmpty(tableName string) (bool, error) {
        var count int64
        err := db.Table(tableName).Count(&count).Error
        return count == 0, err
}

func InitDB(dbPath string) error {
        dir := path.Dir(dbPath)
        err := os.MkdirAll(dir, fs.ModePerm)
        if err != nil {
                return err
        }

        var gormLogger logger.Interface

        if config.IsDebug() {
                gormLogger = logger.Default
        } else {
                gormLogger = logger.Discard
        }

        c := &gorm.Config{
                Logger: gormLogger,
        }
        db, err = gorm.Open(sqlite.Open(dbPath), c)
        if err != nil {
                return err
        }

        if err := initModels(); err != nil {
                return err
        }
        if err := initUser(); err != nil {
                return err
        }

        return nil
}

func CloseDB() error {
        if db != nil {
                sqlDB, err := db.DB()
                if err != nil {
                        return err
                }
                return sqlDB.Close()
        }
        return nil
}

func GetDB() *gorm.DB {
        return db
}

func IsNotFound(err error) bool {
        return err == gorm.ErrRecordNotFound
}

func IsSQLiteDB(file io.ReaderAt) (bool, error) {
        signature := []byte("SQLite format 3\x00")
        buf := make([]byte, len(signature))
        _, err := file.ReadAt(buf, 0)
        if err != nil {
                return false, err
        }
        return bytes.Equal(buf, signature), nil
}

func Checkpoint() error {
        // Update WAL
        err := db.Exec("PRAGMA wal_checkpoint;").Error
        if err != nil {
                return err
        }
        return nil
}
