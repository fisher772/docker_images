import asyncio
import structlog

from aiogram import Dispatcher, Bot
from structlog.typing import FilteringBoundLogger

from bot.config_agent import bot, bot_config, log_config
from bot.handlers import commands, echo
from bot.middlewares import UnhandledUpdatesLoggerMiddleware
from bot.logs import get_structlog_config
from bot.ui_commands import set_bot_commands

logger: FilteringBoundLogger = structlog.get_logger()

async def main():
    dp = Dispatcher()
    
    dp.include_routers(
        commands.router,
        echo.router
    )
    
    if log_config.log_unhandled:
        dp.update.outer_middleware(UnhandledUpdatesLoggerMiddleware())

    await set_bot_commands(bot)
    await logger.ainfo("Starting bot")
    await dp.start_polling(bot, allowed_updates=dp.resolve_used_update_types())
    await logger.awarning("Bot stopped")

if __name__ == "__main__":
    asyncio.run(main())
