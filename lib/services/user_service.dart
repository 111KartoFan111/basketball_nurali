import 'api_service.dart';

class UserService {
  final ApiService _api = ApiService();

  /// Получить информацию о текущем пользователе
  /// Требует добавления endpoint GET /api/users/me на бэкенде
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _api.get('users/me');
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Обновить профиль пользователя
  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _api.put('users/me', data);
  }
}