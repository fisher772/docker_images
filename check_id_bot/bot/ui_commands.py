from aiogram import Bot
from aiogram.types import BotCommand


async def set_bot_commands(bot: Bot):
  await bot.set_my_commands(
        [
            BotCommand(command="id", description="Get ID your bot(with token indication)"),
            BotCommand(command="help", description="Get general info"),
        ]
  )
