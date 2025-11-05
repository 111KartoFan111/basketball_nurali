import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class BackendAuthService {
  final ApiService _api = ApiService();

  Future<String?> login(String username, String password) async {
    try {
      final resp = await _api.post('auth/login', {
        'username': username,
        'password': password,
      });
      
      if (resp == null) {
        throw Exception('Пустой ответ от сервера');
      }
      
      final token = resp['token'] as String?;
      
      if (token == null || token.isEmpty) {
        throw Exception('Токен не получен от сервера');
      }
      
      await _api.setToken(token);
      return token;
    } catch (e) {
      debugPrint('[BackendAuthService] Login error: $e');
      rethrow;
    }
  }

  Future<void> register(String username, String password, {bool coach = false}) async {
    try {
      await _api.post('auth/register', {
        'username': username,
        'password': password,
        'coach': coach,
      });
    } catch (e) {
      debugPrint('[BackendAuthService] Register error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _api.setToken(null);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      debugPrint('[BackendAuthService] Logout error: $e');
      rethrow;
    }
  }
}