from aiogram import Router, Bot
from aiogram.filters import Command, CommandObject
from aiogram.types import Message
from bot.config_agent import get_username


router = Router()

@router.message(Command("id"))
async def command_id(message: Message, command: CommandObject):
    data = command.args
    message_id = message.message_id
    chat_id = message.chat.id
    
    await message.bot.delete_message(chat_id=chat_id, message_id=message_id)
    
    if not data:
        await message.answer(f"💬 Неправильный формат команды.\n"
                             f"Пример: /id YOUR_TOKEN"
                            )

    else:
        try:
            target_bot_token = data
            target_bot = Bot(token=target_bot_token)
            bot_info = await target_bot.get_me()

            await message.answer(f"🤖 Your info on a Bot\n"
                                 f"🆔 Bot ID: <b>{bot_info.id}</b>\n"
                                 f"🔤 Bot Username: <b>@{bot_info.username}</b>"
                                )
            
        except Exception as e:
            await message.answer(f"⚠️ Произошла ошибка при запросе: <b>{e}</b>"
                                )

@router.message(Command("help"))
async def command_help(message: Message):
    bot_username = await get_username()
    bot_group_deeplink = f"https://t.me/{bot_username}?startgroup=id"
  
    await message.answer(f"💬 Вы можете воспользоваться ботом в инлайн-режиме.\n"
                         f"Этот бот предназначен для получения ID разных сущностей в Telegram:\n\n"
                         f"❗️ Этот бот не хранит и не записывает компроментирующую информацию(например токен вашего бота). После отправки токена боту, токен сразу же удаляется из истории чата.\n\n"
                         f"• Напишите любое сообщение и на любом языке боту, чтобы узнать свой ID/Username/Region;\n"
                         f"• Перешлите сообщение из канала, чтобы узнать его ID/Username;\n"
                         f"• Перешлите сообщение от юзера, чтобы узнать его/её ID/Username/Region (если они не запретили это);\n"
                         f"• Перешлите сообщение от другого бота, чтобы узнать ID/Username бота;\n"
                         f"• <a href='{bot_group_deeplink}'>Добавьте бота в группу</a>, чтобы запросить/получить ID/Username;\n"
                         f"• Используйте команду /id с преффиксом-параметром в виде токена вашего бота, чтобы узнать его ID/Username."
                        )
