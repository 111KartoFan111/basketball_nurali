import 'package:flutter/material.dart';
import '../widgets/stats_row.dart'; // Импортируем наш виджет

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Переключатель "Моя статистика" / "Команда"
  bool _showMyStats = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Сегментированный переключатель
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: true,
                label: Text('Моя статистика'),
                icon: Icon(Icons.person),
              ),
              ButtonSegment<bool>(
                value: false,
                label: Text('Команда'),
                icon: Icon(Icons.group),
              ),
            ],
            selected: {_showMyStats},
            onSelectionChanged: (Set<bool> newSelection) {
              setState(() {
                _showMyStats = newSelection.first;
              });
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.grey[850],
              foregroundColor: Colors.white70,
              selectedForegroundColor: Colors.white,
              selectedBackgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        // Контент в зависимости от выбора
        Expanded(
          child: _showMyStats
              ? _buildMyStatsView(context)
              : _buildTeamStatsView(context),
        ),
      ],
    );
  }

  // Виджет для отображения личной статистики
  Widget _buildMyStatsView(BuildContext context) {
    // Здесь будет загрузка и отображение статистики ИГРОКА
    // Используем заглушки
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: const [
        Text(
          'Средние показатели за сезон (заглушка)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 16),
        // Используем наш переиспользуемый виджет
        StatsRow(title: 'Очки (PPG)', value: '12.5'),
        StatsRow(title: 'Подборы (RPG)', value: '5.2'),
        StatsRow(title: 'Передачи (APG)', value: '3.1'),
        StatsRow(title: 'Процент с игры (FG%)', value: '45.2%'),
        StatsRow(title: 'Процент штрафных (FT%)', value: '78.0%'),
        
        SizedBox(height: 24),
        Text(
          'Последняя игра (заглушка)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
         SizedBox(height: 16),
        StatsRow(title: 'Очки', value: '18'),
        StatsRow(title: 'Подборы', value: '7'),
        StatsRow(title: 'Передачи', value: '4'),
      ],
    );
  }

  // Виджет для отображения командной статистики
  Widget _buildTeamStatsView(BuildContext context) {
    // Здесь будет загрузка и отображение рейтинга КОМАНДЫ
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
         const Text(
          'Рейтинг команды (PPG)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        // Заголовок таблицы
        _buildTeamPlayerRow('Игрок', 'Очки', isHeader: true),
        const Divider(color: Colors.white24),
        // Список игроков (заглушки)
        _buildTeamPlayerRow('1. Алексей Иванов', '15.8'),
        _buildTeamPlayerRow('2. (Вы) Имя Фамилия', '12.5'),
        _buildTeamPlayerRow('3. Сергей Петров', '10.1'),
        _buildTeamPlayerRow('4. Дмитрий Новиков', '9.8'),
      ],
    );
  }
  
  // Вспомогательный виджет для строки рейтинга команды
  // (Мы не выносили его в /widgets, так как он используется только здесь)
  Widget _buildTeamPlayerRow(String name, String value, {bool isHeader = false}) {
     return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              color: isHeader ? Colors.white70 : Colors.white,
              fontWeight: isHeader ? FontWeight.normal : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHeader ? Colors.white70 : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
