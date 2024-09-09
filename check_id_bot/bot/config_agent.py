from aiogram import Bot
from aiogram.client.default import DefaultBotProperties
from aiogram.enums import ParseMode

from enum import StrEnum, auto
from pydantic import SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict

class LogRenderer(StrEnum):
    CONSOLE = auto()
    JSON = auto()

class LogSettings(BaseSettings):
    level: str = "INFO"
    fromat: str = "%Y-%m-%d %H:%M:%S"
    utc: bool = False
    renderer: LogRenderer = LogRenderer.JSON
    log_unhandled: bool = False

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="UTF-8",
        env_prefix="LOGGING_",
        extra="allow",
    )

class BotSettings(BaseSettings):
    bot_token: SecretStr
    
    model_config = SettingsConfigDict(
        env_file='.env',
        env_file_encoding="UTF-8",
        extra="allow",
    )

log_config = LogSettings()
bot_config = BotSettings()


bot = Bot(
    bot_config.bot_token.get_secret_value(),
    default=DefaultBotProperties(
    parse_mode=ParseMode.HTML,
    )
)

async def get_username():
    bot_get_username = await bot.get_me()
    bot_username = bot_get_username.username
    return bot_username
