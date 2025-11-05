import os
from dotenv import load_dotenv

load_dotenv()

# Telegram Bot Token
TELEGRAM_BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN', '8480431087:AAEOqJM13VNgv4v6jX87UFsW2sLFT-CiyWE')

# Backend API URL
BACKEND_API_URL = os.getenv('BACKEND_API_URL', 'http://localhost:8080/api')

# Validation settings
CODE_LENGTH = 6
CODE_EXPIRY_MINUTES = 15