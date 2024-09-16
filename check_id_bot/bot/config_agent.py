import structlog

from aiogram import Bot
from aiogram.client.default import DefaultBotProperties
from aiogram.enums import ParseMode
from aiogram.client.session.aiohttp import AiohttpSession
from aiohttp import BasicAuth

from enum import StrEnum, auto
from pydantic import SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict
from structlog.typing import FilteringBoundLogger



logger: FilteringBoundLogger = structlog.get_logger()

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
    
class ProxySettings(BaseSettings):
    status: bool = False
    login: SecretStr
    password: SecretStr
    address: SecretStr
    
    model_config = SettingsConfigDict(
        env_file='.env',
        env_file_encoding="UTF-8",
        env_prefix="PROXY_",
        extra="allow",
    )

log_config = LogSettings()
bot_config = BotSettings()
proxy_config = ProxySettings()


if proxy_config.status:
  auth = BasicAuth(proxy_config.login, proxy_config.password)
  session = AiohttpSession(proxy=(proxy_config.address, auth))
else:
  session = AiohttpSession()


bot = Bot(
    bot_config.bot_token.get_secret_value(),
    default=DefaultBotProperties(
      parse_mode=ParseMode.HTML
    )
)

async def get_username():
    bot_get_username = await bot.get_me()
    bot_username = bot_get_username.username
    return bot_username
