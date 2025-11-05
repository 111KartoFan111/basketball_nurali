// lib/utils/constants.dart

import 'package:flutter/foundation.dart';

// ====== API CONFIGURATION ======

// Для Android эмулятора (10.0.2.2 указывает на localhost хост-машины)
const String kAndroidEmulatorUrl = 'http://10.0.2.2:8080/api';

// Для iOS симулятора (localhost работает напрямую)
const String kIosSimulatorUrl = 'http://localhost:8080/api';

// Для физического устройства в локальной сети
// Замените YOUR_COMPUTER_IP на IP адрес вашего компьютера
const String kPhysicalDeviceUrl = 'http://192.168.1.XXX:8080/api';

// Для продакшн сервера
const String kProductionUrl = 'https://your-domain.com/api';

// Автоматический выбор URL в зависимости от платформы
String get kApiBaseUrl {
  if (kReleaseMode) {
    return kProductionUrl;
  }
  
  // В режиме разработки определяем платформу
  if (defaultTargetPlatform == TargetPlatform.android) {
    return kAndroidEmulatorUrl;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return kIosSimulatorUrl;
  }
  
  return kIosSimulatorUrl; // По умолчанию для desktop
}

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