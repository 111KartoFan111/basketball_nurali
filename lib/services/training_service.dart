import '../models/training_model.dart';
import '../models/booking_model.dart';
import 'api_service.dart';

class TrainingService {
  final ApiService _api = ApiService();

  /// Получить расписание тренировок
  Future<List<TrainingModel>> getSchedule() async {
    try {
      final resp = await _api.get('trainings');
      
      // Проверяем на null и пустой ответ
      if (resp == null) {
        return [];
      }
      
      // Если это не список, возвращаем пустой список
      if (resp is! List) {
        print('[TrainingService] Warning: Response is not a list: $resp');
        return [];
      }
      
      // Преобразуем в список тренировок
      final list = (resp as List).cast<Map<String, dynamic>>();
      return list.map((e) => TrainingModel.fromJson(e)).toList();
    } catch (e) {
      print('[TrainingService] Error loading schedule: $e');
      rethrow;
    }
  }

  /// Записаться на тренировку
  Future<BookingModel> book(int trainingId) async {
    try {
      final resp = await _api.post('bookings/$trainingId', {});
      
      if (resp == null) {
        throw Exception('Empty response from server');
      }
      
      return BookingModel.fromJson(resp as Map<String, dynamic>);
    } catch (e) {
      print('[TrainingService] Error booking training: $e');
      rethrow;
    }
  }

  /// Получить мои записи
  Future<List<BookingModel>> myBookings() async {
    try {
      final resp = await _api.get('bookings/me');
      
      // Проверяем на null
      if (resp == null) {
        return [];
      }
      
      // Если это не список, возвращаем пустой список
      if (resp is! List) {
        print('[TrainingService] Warning: Bookings response is not a list: $resp');
        return [];
      }
      
      final list = (resp as List).cast<Map<String, dynamic>>();
      return list.map((e) => BookingModel.fromJson(e)).toList();
    } catch (e) {
      print('[TrainingService] Error loading bookings: $e');
      // Возвращаем пустой список вместо ошибки
      return [];
    }
  }

  /// Отменить запись
  Future<void> cancelBooking(int bookingId) async {
    try {
      await _api.delete('bookings/$bookingId');
    } catch (e) {
      print('[TrainingService] Error canceling booking: $e');
      rethrow;
    }
  }

  /// Создать тренировку (только для тренера)
  Future<TrainingModel> createTraining({
    required String title,
    required String description,
    required DateTime startsAt,
    required DateTime endsAt,
    required int capacity,
  }) async {
    try {
      // Send timestamps in UTC with offset so server can deserialize to OffsetDateTime
      final data = {
        'title': title,
        'description': description,
        'startsAt': startsAt.toUtc().toIso8601String(),
        'endsAt': endsAt.toUtc().toIso8601String(),
        'capacity': capacity,
      };

      final resp = await _api.post('trainings', data);
      
      if (resp == null) {
        throw Exception('Empty response from server');
      }

      return TrainingModel.fromJson(resp as Map<String, dynamic>);
    } catch (e) {
      print('[TrainingService] Error creating training: $e');
      rethrow;
    }
  }

  /// Обновить тренировку (только для тренера)
  Future<TrainingModel> updateTraining({
    required int id,
    required String title,
    required String description,
    required DateTime startsAt,
    required DateTime endsAt,
    required int capacity,
  }) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'startsAt': startsAt.toIso8601String(),
        'endsAt': endsAt.toIso8601String(),
        'capacity': capacity,
      };

      final resp = await _api.put('trainings/$id', data);
      
      if (resp == null) {
        throw Exception('Empty response from server');
      }

      return TrainingModel.fromJson(resp as Map<String, dynamic>);
    } catch (e) {
      print('[TrainingService] Error updating training: $e');
      rethrow;
    }
  }

  /// Отменить тренировку (только для тренера)
  Future<void> cancelTraining(int trainingId) async {
    try {
      await _api.delete('trainings/$trainingId');
    } catch (e) {
      print('[TrainingService] Error canceling training: $e');
      rethrow;
    }
  }
}