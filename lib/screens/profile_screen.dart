import 'package:flutter/material.dart';
import '../main.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 60, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          const Text(
            'Имя Фамилия',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'player@example.com ',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),

          Card(
            color: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(context, Icons.shield_outlined, 'Команда', 'БК "Шторм" '),
                  const Divider(color: Colors.white24),
                  _buildInfoRow(context, Icons.bar_chart_outlined, 'Уровень', 'Любитель'),
                  const Divider(color: Colors.white24),
                  _buildInfoRow(context, Icons.cake_outlined, 'Дата рождения', '01.01.1995'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          TextButton.icon(
            onPressed: () => _logout(context),
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
