from aiogram import Router, F
from aiogram.types import Message


router = Router()
router.message.filter(F.text, ~F.text.startswith('/'))

@router.message()
async def message_any(message: Message):
    user_id = message.from_user.id
    username = message.from_user.username
    user = message.from_user.first_name
    lang_id = message.from_user.language_code
    
    if message.forward_from:      
        forward_user_id = message.forward_from.id
        forward_username = message.forward_from.username
        forward_user = message.forward_from.first_name
      
        if not message.forward_from.is_bot:
            await message.answer(f"👤 First Name: <b>{forward_user}</b>\n"
                                 f"🆔 User ID is: <b>{forward_user_id}</b>\n"
                                 f"🔤 Username: <b>@{forward_username}</b>\n"
                                 f"🌍 Region: <b>{lang_id.upper()}</b>"
                                )
        else:
            await message.answer(f"🤖 Your info on a Bot\n"
                                 f"🆔 Bot ID: <b>{forward_user_id}</b>\n"
                                 f"🔤 Bot Username: <b>@{forward_username}</b>"
                                )
    else:
        if message.from_user.is_bot:
            await message.answer(f"🤖 Your info on a Bot\n"
                                 f"🆔 Bot ID: <b>{user_id}</b>\n"
                                 f"🔤 Bot Username: <b>@{username}</b>"
                                )

        else:
            await message.answer(f"👤 Welcome, <b>{user}</b>!\n"
                                 f"🆔 Your user ID is: <b>{user_id}</b>\n"
                                 f"🔤 Your Username: <b>@{username}</b>\n"
                                 f"🌍 Your Region: <b>{lang_id.upper()}</b>"
                                )
