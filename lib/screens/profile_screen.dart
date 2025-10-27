import 'package:flutter/material.dart';
import '../main.dart'; // Для MainAppShell
import 'auth/login_screen.dart'; // Для перехода на LoginScreen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    // TODO: Добавить вызов auth_service.dart для очистки токена
    
    // Переходим на экран входа и удаляем все экраны "позади"
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false, // Удаляем все
    );
  }


  @override
  Widget build(BuildContext context) {
    // (позже данные будут грузиться с бэкенда)
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Аватар
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 60, color: Colors.white70),
            // TODO: Заменить на Image.network(profile_photo_url)
          ),
          const SizedBox(height: 20),

          // Имя
          const Text(
            'Имя Фамилия (Заглушка)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Email
          Text(
            'player@example.com (Заглушка)',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),

          // Карточка с основной информацией
          Card(
            color: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(context, Icons.shield_outlined, 'Команда', 'БК "Шторм" (Заглушка)'),
                  const Divider(color: Colors.white24),
                  _buildInfoRow(context, Icons.bar_chart_outlined, 'Уровень', 'Любитель (Заглушка)'),
                  const Divider(color: Colors.white24),
                  _buildInfoRow(context, Icons.cake_outlined, 'Дата рождения', '01.01.1995 (Заглушка)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Кнопка выхода
          TextButton.icon(
            onPressed: () => _logout(context), // Вызываем функцию выхода
            icon: Icon(Icons.logout, color: Colors.red[400]),
            label: Text(
              'Выйти из аккаунта',
              style: TextStyle(color: Colors.red[400], fontSize: 16),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Вспомогательный виджет для строки информации
  Widget _buildInfoRow(BuildContext context, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.white70)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
        ],
      ),
    );
  }
}
