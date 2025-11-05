import 'api_service.dart';

class PasswordResetService {
  final ApiService _api = ApiService();

  /// Запросить код сброса пароля
  /// Код будет отправлен в Telegram
  Future<void> requestPasswordReset({
    required String username,
    required int telegramId,
  }) async {
    try {
      final response = await _api.post('password-reset/request', {
        'username': username,
        'telegramId': telegramId,
      });

      // Проверяем статус ответа
      if (response != null && response['status'] == 'success') {
        return;
      } else {
        final message = response?['message'] ?? 'Unknown error';
        throw ApiException(message);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Ошибка при запросе сброса пароля: $e');
    }
  }

  /// Сбросить пароль с использованием кода
  Future<void> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await _api.post('password-reset/reset', {
        'code': code,
        'newPassword': newPassword,
      });

      // Проверяем статус ответа
      if (response != null && response['status'] == 'success') {
        return;
      } else {
        final message = response?['message'] ?? 'Unknown error';
        throw ApiException(message);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Ошибка при сбросе пароля: $e');
    }
  }

  /// Проверить валидность кода (опционально)
  Future<bool> validateCode(String code) async {
    try {
      final response = await _api.get('password-reset/validate?code=$code');
      return response?['valid'] == true;
    } catch (e) {
      return false;
    }
  }
}