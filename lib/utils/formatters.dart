import 'package:intl/intl.dart';

class Formatters {

  static String formatWorkoutDateTime(DateTime dt) {
    try {
      return '${dt.day}.${dt.month} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';

    } catch (e) {
      return dt.toString();
    }
  }

}
