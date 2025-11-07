import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart';
import '../models/user_analytics.dart';

class UserAnalyticsScreen extends StatefulWidget {
  const UserAnalyticsScreen({super.key});

  @override
  State<UserAnalyticsScreen> createState() => _UserAnalyticsScreenState();
}

class _UserAnalyticsScreenState extends State<UserAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные при первом открытии экрана
    Future.microtask(() => 
      context.read<AnalyticsProvider>().fetchAnalytics()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика пользователей'),
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.error != null) {
            return Center(
              child: Text(
                'Ошибка: ${provider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (provider.analytics.isEmpty) {
            return const Center(
              child: Text('Нет данных для отображения'),
            );
          }

          return ListView.builder(
            itemCount: provider.analytics.length,
            itemBuilder: (context, index) {
              final analytics = provider.analytics[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        analytics.username,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _buildStatRow('Всего тренировок:', analytics.totalBookings.toString()),
                      _buildStatRow('Отмененные тренировки:', analytics.canceledBookings.toString()),
                      _buildStatRow(
                        'Посещаемость:',
                        '${analytics.attendanceRate.toStringAsFixed(1)}%',
                      ),
                      if (analytics.lastTrainingDate != null)
                        _buildStatRow(
                          'Последняя тренировка:',
                          _formatDate(analytics.lastTrainingDate!),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}