// lib/utils/constants.dart

// Выберите нужную конфигурацию раскомментировав соответствующую строку

// ====== DEVELOPMENT ======

// Для Android эмулятора (10.0.2.2 указывает на localhost хост-машины)
//const String kApiBaseUrl = 'http://10.0.2.2:8080/api';

// Для iOS симулятора (localhost работает напрямую)
const String kApiBaseUrl = 'http://localhost:8080/api';

// Для физического устройства в локальной сети
// Замените YOUR_COMPUTER_IP на IP адрес вашего компьютера
// Чтобы узнать IP:
//   macOS/Linux: ifconfig | grep "inet " или ip addr show
//   Windows: ipconfig
// const String kApiBaseUrl = 'http://192.168.1.XXX:8080/api';

// ====== PRODUCTION ======

// Для продакшн сервера
// const String kApiBaseUrl = 'https://your-domain.com/api';

// ====== ДРУГИЕ КОНСТАНТЫ ======

// Таймауты
const Duration kApiTimeout = Duration(seconds: 30);
const Duration kConnectionTimeout = Duration(seconds: 15);

// Ключи для SharedPreferences
const String kAuthTokenKey = 'auth_token';
const String kUserIdKey = 'user_id';
const String kUserRoleKey = 'user_role';

// Форматы даты
const String kDateFormat = 'dd.MM.yyyy';
const String kTimeFormat = 'HH:mm';
const String kDateTimeFormat = 'dd.MM.yyyy HH:mm';

// Валидация
const int kMinPasswordLength = 6;
const int kMaxPasswordLength = 50;

// UI константы
const Duration kSnackBarDuration = Duration(seconds: 3);
const Duration kAnimationDuration = Duration(milliseconds: 300);

// Отладка
const bool kDebugMode = true; // Включает логирование в api_service