#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
from telegram import Update
from telegram.ext import (
    Application,
    CommandHandler,
    MessageHandler,
    filters,
    ContextTypes
)
from config import TELEGRAM_BOT_TOKEN, BACKEND_API_URL

# Настройка логирования
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Хранилище для связи telegram_id с username
user_storage = {}


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Обработчик команды /start"""
    user = update.effective_user
    telegram_id = user.id
    
    logger.info(f"User {telegram_id} started the bot")
    
    welcome_message = (
        f"🏀 Добро пожаловать в HoopConnect Bot!\n\n"
        f"Ваш Telegram ID: `{telegram_id}`\n\n"
        f"Этот бот используется для:\n"
        f"• Сброса пароля через код подтверждения\n"
        f"• Получения уведомлений о тренировках\n\n"
        f"Для сброса пароля:\n"
        f"1️⃣ В приложении нажмите 'Забыли пароль?'\n"
        f"2️⃣ Введите свой username и Telegram ID\n"
        f"3️⃣ Получите код здесь в боте\n"
        f"4️⃣ Введите код в приложении\n\n"
        f"Команды:\n"
        f"/start - Показать это сообщение\n"
        f"/myid - Показать ваш Telegram ID\n"
        f"/help - Помощь"
    )
    
    await update.message.reply_text(
        welcome_message,
        parse_mode='Markdown'
    )


async def myid(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Показать Telegram ID пользователя"""
    user = update.effective_user
    telegram_id = user.id
    
    await update.message.reply_text(
        f"🆔 Ваш Telegram ID: `{telegram_id}`\n\n"
        f"Используйте этот ID при сбросе пароля в приложении.",
        parse_mode='Markdown'
    )


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Обработчик команды /help"""
    help_text = (
        "🏀 *HoopConnect Bot - Помощь*\n\n"
        "*Как сбросить пароль:*\n"
        "1. Откройте приложение HoopConnect\n"
        "2. На экране входа нажмите 'Забыли пароль?'\n"
        "3. Введите свой username\n"
        "4. Введите ваш Telegram ID (используйте /myid)\n"
        "5. Вы получите 6-значный код в этом боте\n"
        "6. Введите код в приложении\n"
        "7. Установите новый пароль\n\n"
        "*Важно:*\n"
        "• Код действителен 15 минут\n"
        "• Один код можно использовать только один раз\n"
        "• Никому не сообщайте свой код\n\n"
        "*Команды:*\n"
        "/start - Главное меню\n"
        "/myid - Показать Telegram ID\n"
        "/help - Эта справка"
    )
    
    await update.message.reply_text(help_text, parse_mode='Markdown')


async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Обработчик текстовых сообщений"""
    await update.message.reply_text(
        "Используйте команду /help для получения информации о боте."
    )


async def send_reset_code(telegram_id: int, username: str, code: str) -> bool:
    """
    Отправить код сброса пароля пользователю
    Эта функция вызывается из backend через webhook
    """
    try:
        bot = context.bot
        message = (
            f"🔐 *Код для сброса пароля*\n\n"
            f"Username: `{username}`\n"
            f"Код подтверждения: `{code}`\n\n"
            f"⏰ Код действителен 15 минут\n"
            f"⚠️ Не сообщайте код никому!"
        )
        
        await bot.send_message(
            chat_id=telegram_id,
            text=message,
            parse_mode='Markdown'
        )
        
        logger.info(f"Reset code sent to telegram_id={telegram_id} for user={username}")
        return True
        
    except Exception as e:
        logger.error(f"Failed to send reset code to {telegram_id}: {e}")
        return False


def main() -> None:
    """Запуск бота"""
    
    if not TELEGRAM_BOT_TOKEN:
        logger.error("TELEGRAM_BOT_TOKEN is not set!")
        return
    
    logger.info("Starting Basketball App Telegram Bot...")
    
    # Создаем приложение
    application = Application.builder().token(TELEGRAM_BOT_TOKEN).build()
    
    # Регистрируем обработчики команд
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("myid", myid))
    application.add_handler(CommandHandler("help", help_command))
    
    # Обработчик текстовых сообщений
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    # Запускаем бота
    logger.info("Bot is running...")
    application.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == '__main__':
    main()