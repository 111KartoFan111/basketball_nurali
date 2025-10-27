import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'user_provider.dart'; // Импортируем UserProvider

// Управляет состоянием аутентификации (загрузка, ошибка, токен)
// Он также будет управлять вызовом UserProvider
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // Приватные состояния
  bool _isLoading = false;
  String? _errorMessage;
  String? _token; // Мы не храним токен здесь, он в ApiService

  // Геттеры для UI
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null; // 'ApiService' должен иметь геттер

  // Ссылка на UserProvider, чтобы обновить его
  final UserProvider _userProvider;
  AuthProvider(this._userProvider); // Получаем UserProvider через конструктор

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final UserModel user = await _authService.login(email, password);
      
      // Успех!
      _isLoading = false;
      _token = '...'; // Установить токен (или просто флаг)
      _userProvider.setUser(user); // <<-- Обновляем UserProvider
      notifyListeners();
      return true;

    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _token = null;
    _userProvider.clearUser(); // <<-- Очищаем UserProvider
    notifyListeners();
  }

  // TODO: Добавить метод register
}
