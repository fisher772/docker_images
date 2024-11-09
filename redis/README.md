# Kibana. IAC

[![GitHub](https://img.shields.io/github/v/release/fisher772/redis?logo=github)](https://github.com/fisher772/redis/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Repo)](https://github.com/fisher772/redis)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/redis/pkgs/container/redis)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/redis)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.

Redis (Remote Dictionary Server) is a resident NoSQL database management system that works with key-value data structures. It is used both for databases and for implementing caches and message brokers.

My small fork integrates a configuration directory through which you can manage the Redis configuration. It has minimal requirements, high performance and a persistent approach via Append-Only File (AOF). An example of use is demonstrated in the ELK stack manifest, where there is no buffering. Compared to the EFK stack, ELK + Filebit + Redis can demonstrate an order of magnitude better performance, safety and easier configuration.

```
Redis configuration files are used from the /usr/local/etc/redis/conf.d/*.conf directory
```

[Redis reference docs](https://redis.io/docs/latest)
[Redis Config reference docs](https://redis.io/docs/latest/operate/oss_and_stack/management/config)

Why do I need a Redis?
- High Performance(in-memory RAM)
- Key-value storage
- Caching
- Versatile Data Structures
- Session Storage
- Message Brokering
- Durability and Reliability
- Scalability and Replication
- Free and Open-Source

What work has been done:
- A memory management policy is used when Redis reaches the configured memory limit (maxmemory). Redis will remove the least recently used keys (Least Recently Used) from all keys to free up memory.
- Saves every write operation that Redis receives, which allows you to restore the database by replaying all operations from the standard directory "appendonly.aof" file.
- Also configured parameters for automatic rewriting of the "appendonly.aof" file to reduce the file size and high performance.

All you need to do to install Redis:
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest
- Follow the instructions from the official Redis source for personalized service settings


Environment:

|  Environment                | Default value         | Customize (env variable)\*\*             |
| --------------------------- | --------------------- | ---------------------------------------- |
| TZ                          | Auto detect           | EKB                                      |


Parameters in Redis *.conf:

|  Parameters                 | Default value         | Customize value                          | Desc parametrs                           |
| --------------------------- | --------------------- | ---------------------------------------- | ---------------------------------------- |
| bind                        | loopback              | * -::*                                   | IP address Redis listens on              |
| protected-mode              | yes                   | no                                       | Enables or disables protected mode       |
| maxmemory                   | 0                     | 512MB                                    | Sets memory usage limit for Redis        |
| maxmemory-policy            | -, noeviction         | allkeys-lru                              | Memory management policy                 |
| appendonly                  | no                    | yes                                      | Enables Append-Only File (AOF)           |
| appendfsync                 | everysec              | everysec                                 | AOF file sync frequency                  |
| auto-aof-rewrite-percentage | 100                   | 50                                       | Triggers AOF rewrite at % increase       |
| auto-aof-rewrite-min-size   | 64mb                  | 1GB                                      | Minimum AOF file size for rewrite        |


Commands:

```bash
# Checking Redis server response
docker exec -it redis redis-cli ping

# Opens a shell inside the running Redis container
docker exec -it redis sh

# Streams every command processed by the Redis server in real-time
redis-cli MONITOR

# Retrieves all Redis configuration parameters
redis-cli CONFIG GET *

# Lists all keys stored in the Redis database
redis-cli KEYS GET *
```
