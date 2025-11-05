import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class BackendAuthService {
  final ApiService _api = ApiService();

  Future<String> login(String username, String password) async {
    final resp = await _api.post('auth/login', {
      'username': username,
      'password': password,
    });
    final token = resp['token'] as String;
    await _api.setToken(token);
    return token;
  }

  Future<void> register(String username, String password, {bool coach = false}) async {
    await _api.post('auth/register', {
      'username': username,
      'password': password,
      'coach': coach,
    });
  }

  Future<void> logout() async {
    await _api.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}