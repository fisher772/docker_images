import asyncio
import structlog

from structlog.typing import FilteringBoundLogger

from bot.config_agent import bot, dp, bot_config
from bot.handlers import commands, echo

logger: FilteringBoundLogger = structlog.get_logger()

async def main():
    
    dp.include_routers(
        commands.router,
        echo.router
    )

    await logger.awarning("Starting bot")
    await dp.start_polling(bot, allowed_updates=dp.resolve_used_update_types())
    await logger.awarning("Bot stopped")

if __name__ == "__main__":
    asyncio.run(main())
    
