from aiogram import Bot, Dispatcher
from aiogram.client.default import DefaultBotProperties
from aiogram.enums import ParseMode

from pydantic import SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict

class BotSerttings(BaseSettings):
    bot_token: SecretStr
    
    model_config = SettingsConfigDict(
        env_file='.env',
        extra="allow",
    )

bot_config = BotSerttings()


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
