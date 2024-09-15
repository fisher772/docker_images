from typing import Any, Awaitable, Callable, Dict

<<<<<<< HEAD
import structlog
from aiogram import BaseMiddleware
from aiogram.dispatcher.event.bases import UNHANDLED
from aiogram.types import TelegramObject
from structlog.typing import FilteringBoundLogger

logger: FilteringBoundLogger = structlog.get_logger()
=======
from aiogram import BaseMiddleware
from aiogram.dispatcher.event.bases import UNHANDLED
from aiogram.types import TelegramObject
from bot.config_agent import logger
>>>>>>> devops


class UnhandledUpdatesLoggerMiddleware(BaseMiddleware):
    async def __call__(
            self,
            handler: Callable[[TelegramObject, Dict[str, Any]], Awaitable[Any]],
            event: TelegramObject,
            data: Dict[str, Any],
    ) -> Any:
        result = await handler(event, data)
        if result is UNHANDLED:
            await logger.awarning(
                "Unhandled update",
                update=event.dict()
            )
