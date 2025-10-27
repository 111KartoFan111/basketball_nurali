import 'package:intl/intl.dart';

// Здесь будут функции для красивого отображения данных

class Formatters {

  // Форматирует DateTime в "25 окт, 18:00"
  static String formatWorkoutDateTime(DateTime dt) {
    // TODO: Добавить 'intl' в pubspec.yaml
    // TODO: Инициализировать локали (например, 'ru_RU')
    try {
      // final formatter = DateFormat('d MMM, HH:mm', 'ru_RU');
      // return formatter.format(dt);
      
      // Простой формат, пока 'intl' не настроен
      return '${dt.day}.${dt.month} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';

    } catch (e) {
      return dt.toString();
    }
  }

  // TODO: Добавить другие форматтеры (например, для статистики)
}
