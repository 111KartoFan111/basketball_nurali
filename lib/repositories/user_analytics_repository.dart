import '../models/user_analytics.dart';
import '../services/api_service.dart';

class UserAnalyticsRepository {
  final ApiService _apiService;
  
  UserAnalyticsRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  Future<List<UserAnalytics>> getUsersAnalytics() async {
    try {
      final response = await _apiService.get('api/analytics/users');
      
      // Преобразуем JSON в список объектов UserAnalytics
      List<UserAnalytics> analytics = (response as List)
          .map((json) => UserAnalytics.fromJson(json))
          .toList();
      
      return analytics;
    } catch (e) {
      throw Exception('Failed to load analytics: $e');
    }
  }
}