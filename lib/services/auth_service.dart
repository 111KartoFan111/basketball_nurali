import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Логин
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.post('auth/login', {
        'email': email,
        'password': password,
      });

      // Ожидаем, что бэкенд вернет токен и юзера
      // { "token": "...", "user": { ... } }
      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      // Сохраняем токен в ApiService
      _apiService.setToken(token);

      // TODO: Сохранить токен в 'shared_preferences' для
      //       авто-входа при следующем запуске.

      return UserModel.fromJson(userData);

    } catch (e) {
      // Перебрасываем ошибку, чтобы UI мог ее поймать
      throw ApiException(e.toString());
    }
  }

  // Регистрация
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('auth/register', {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'role': 'player', // По умолчанию регистрируем как 'player'
      });

      // Ожидаем, что бэкенд вернет только юзера (без токена, 
      // т.к. после регистрации надо логиниться)
      return UserModel.fromJson(response);

    } catch (e) {
       throw ApiException(e.toString());
    }
  }

  // Выход
  Future<void> logout() async {
    // Очищаем токен
    _apiService.setToken(null);
    // TODO: Очистить токен из 'shared_preferences'
  }
}
