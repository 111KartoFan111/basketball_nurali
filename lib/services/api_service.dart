import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart'; // Наш URL

// Базовый класс для всех HTTP-запросов
// Он будет хранить токен и добавлять его ко всем запросам
class ApiService {
  String? _token; // Приватный токен

  void setToken(String? token) {
    _token = token;
  }

  // --- Хелперы для запросов ---

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$kApiBaseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$kApiBaseUrl/$endpoint');
    final response = await http.get(
      url,
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }

  // TODO: Добавить put, delete по необходимости

  // --- Приватные методы ---

  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-F',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Бэкенд должен присылать данные в 'data'
      // { "status": "success", "data": { ... } }
      // Если 'data' нет, возвращаем весь body
      return body['data'] as Map<String, dynamic>? ?? body;
    } else {
      // Бэкенд должен присылать ошибку в 'message'
      // { "status": "error", "message": "..." }
      final message = body['message'] as String? ?? 'Unknown error';
      throw ApiException(message);
    }
  }
}

// Кастомный класс для ошибок API
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
