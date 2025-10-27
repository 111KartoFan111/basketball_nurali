import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.post('auth/login', {
        'email': email,
        'password': password,
      });

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      _apiService.setToken(token);

      return UserModel.fromJson(userData);

    } catch (e) {
      throw ApiException(e.toString());
    }
  }

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
        'role': 'player',
      });

      return UserModel.fromJson(response);

    } catch (e) {
       throw ApiException(e.toString());
    }
  }

  Future<void> logout() async {
    _apiService.setToken(null);
  }
}
