import '../models/workout_model.dart';
import 'api_service.dart';

class WorkoutService {
  final ApiService _apiService = ApiService();

  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      final response = await _apiService.get('workouts');

      final workoutsList = response['workouts'] as List;

      return workoutsList
          .map((json) => WorkoutModel.fromJson(json as Map<String, dynamic>))
          .toList();

    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> signUpForWorkout(String workoutId) async {
    try {
      await _apiService.post('workouts/$workoutId/signup', {});
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> cancelSignUp(String workoutId) async {
    try {
       await _apiService.post('workouts/$workoutId/cancel_signup', {});
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
