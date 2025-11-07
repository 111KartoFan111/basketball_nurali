import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_analytics.dart';

class AnalyticsProvider with ChangeNotifier {
  final String baseUrl;
  List<UserAnalytics>? _analytics;
  bool _isLoading = false;
  String? _error;

  AnalyticsProvider(this.baseUrl);

  List<UserAnalytics> get analytics => _analytics ?? [];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAnalytics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/analytics/users'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _analytics = data.map((json) => UserAnalytics.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Ошибка сервера: ${response.statusCode}';
        _analytics = null;
      }
    } catch (e) {
      _error = 'Ошибка при загрузке данных: $e';
      _analytics = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}