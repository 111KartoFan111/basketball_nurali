import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  /// Устанавливает JWT токен и сохраняет его в SharedPreferences
  Future<void> setToken(String? token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove(kAuthTokenKey);
      _log('Token removed');
    } else {
      await prefs.setString(kAuthTokenKey, token);
      _log('Token saved');
    }
  }

  /// Загружает JWT токен из SharedPreferences
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(kAuthTokenKey);
    _log('Token loaded: ${_token != null ? 'exists' : 'null'}');
  }

  /// Проверяет, авторизован ли пользователь
  bool get isAuthenticated => _token != null;

  /// POST запрос
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$kApiBaseUrl/$endpoint');
    _log('POST $url');
    _log('Body: $body');

    try {
      final response = await http
          .post(
            url,
            headers: _getHeaders(),
            body: jsonEncode(body),
          )
          .timeout(kApiTimeout);

      _log('Status: ${response.statusCode}');
      _log('Response: ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Не удалось подключиться к серверу. Проверьте интернет-соединение.');
    } on http.ClientException {
      throw ApiException('Ошибка сети. Попробуйте позже.');
    } catch (e) {
      _log('Error: $e');
      rethrow;
    }
  }

  /// GET запрос
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$kApiBaseUrl/$endpoint');
    _log('GET $url');

    try {
      final response = await http
          .get(
            url,
            headers: _getHeaders(),
          )
          .timeout(kApiTimeout);

      _log('Status: ${response.statusCode}');
      _log('Response: ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Не удалось подключиться к серверу. Проверьте интернет-соединение.');
    } on http.ClientException {
      throw ApiException('Ошибка сети. Попробуйте позже.');
    } catch (e) {
      _log('Error: $e');
      rethrow;
    }
  }

  /// PUT запрос
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$kApiBaseUrl/$endpoint');
    _log('PUT $url');
    _log('Body: $body');

    try {
      final response = await http
          .put(
            url,
            headers: _getHeaders(),
            body: jsonEncode(body),
          )
          .timeout(kApiTimeout);

      _log('Status: ${response.statusCode}');
      _log('Response: ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Не удалось подключиться к серверу. Проверьте интернет-соединение.');
    } on http.ClientException {
      throw ApiException('Ошибка сети. Попробуйте позже.');
    } catch (e) {
      _log('Error: $e');
      rethrow;
    }
  }

  /// DELETE запрос
  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$kApiBaseUrl/$endpoint');
    _log('DELETE $url');

    try {
      final response = await http
          .delete(
            url,
            headers: _getHeaders(),
          )
          .timeout(kApiTimeout);

      _log('Status: ${response.statusCode}');
      _log('Response: ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Не удалось подключиться к серверу. Проверьте интернет-соединение.');
    } on http.ClientException {
      throw ApiException('Ошибка сети. Попробуйте позже.');
    } catch (e) {
      _log('Error: $e');
      rethrow;
    }
  }

  /// Формирует заголовки для запросов
  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  /// Обрабатывает HTTP ответ
  dynamic _handleResponse(http.Response response) {
    // 204 No Content - успешно, но нет тела ответа
    if (response.statusCode == 204 || response.body.isEmpty) {
      return null;
    }

    // Декодируем JSON
    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      _log('JSON decode error: $e');
      throw ApiException('Неверный формат ответа сервера');
    }

    // Успешные коды (2xx)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    // Обработка ошибок
    String message = 'Неизвестная ошибка';

    if (decoded is Map<String, dynamic>) {
      // Spring Boot обычно возвращает { "message": "..." }
      if (decoded.containsKey('message')) {
        message = decoded['message'] as String;
      } else if (decoded.containsKey('error')) {
        message = decoded['error'] as String;
      }
    } else if (decoded is String) {
      message = decoded;
    }

    // Специфичные коды ошибок
    switch (response.statusCode) {
      case 400:
        throw ApiException('Неверные данные: $message');
      case 401:
        throw UnauthorizedException('Требуется авторизация: $message');
      case 403:
        throw ForbiddenException('Доступ запрещен: $message');
      case 404:
        throw NotFoundException('Не найдено: $message');
      case 409:
        throw ConflictException('Конфликт данных: $message');
      case 500:
        throw ServerException('Ошибка сервера: $message');
      default:
        throw ApiException('Ошибка HTTP ${response.statusCode}: $message');
    }
  }

  /// Логирование (только в debug режиме)
  void _log(String message) {
    if (kDebugMode) {
      print('[ApiService] $message');
    }
  }
}

/// Базовый класс исключений API
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Ошибка 401 - не авторизован
class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

/// Ошибка 403 - доступ запрещен
class ForbiddenException extends ApiException {
  ForbiddenException(super.message);
}

/// Ошибка 404 - не найдено
class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

/// Ошибка 409 - конфликт
class ConflictException extends ApiException {
  ConflictException(super.message);
}

/// Ошибка 500 - ошибка сервера
class ServerException extends ApiException {
  ServerException(super.message);
}