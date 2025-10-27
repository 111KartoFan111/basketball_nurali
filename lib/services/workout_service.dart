import '../models/workout_model.dart';
import 'api_service.dart';

class WorkoutService {
  final ApiService _apiService = ApiService();

  // Получить список тренировок (для 'schedule_screen.dart')
  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      // 'api_service.get' возвращает Map, а нам нужен List
      // Переделаем 'get' в 'api_service' или перехватим здесь
      // Предположим, 'api_service.get' вернет { "workouts": [ ... ] }
      final response = await _apiService.get('workouts');
      
      // 'response' - это Map<String, dynamic>
      final workoutsList = response['workouts'] as List;

      return workoutsList
          .map((json) => WorkoutModel.fromJson(json as Map<String, dynamic>))
          .toList();

    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  // Записаться на тренировку
  Future<void> signUpForWorkout(String workoutId) async {
    try {
      await _apiService.post('workouts/$workoutId/signup', {});
      // Ничего не возвращаем, 200 OK == успех
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  // Отменить запись
  Future<void> cancelSignUp(String workoutId) async {
    try {
      // Бэкенд должен поддерживать DELETE на этот эндпоинт
      // TODO: Добавить 'delete' метод в 'api_service'
      // await _apiService.delete('workouts/$workoutId/signup');
      
      // Пока что используем POST для отмены
       await _apiService.post('workouts/$workoutId/cancel_signup', {});
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
