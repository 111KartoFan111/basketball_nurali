import 'package:flutter/material.dart';
import '../widgets/stats_row.dart';
import '../services/user_service.dart';
import '../services/training_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _userService = UserService();
  final _trainingService = TrainingService();
  
  bool _showMyStats = true;
  bool _loading = true;
  Map<String, dynamic>? _currentUser;
  int _totalTrainings = 0;
  int _upcomingTrainings = 0;
  int _completedTrainings = 0;
  int _myBookings = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    
    try {
      // Загружаем пользователя
      final user = await _userService.getCurrentUser();
      
      // Загружаем тренировки
      final trainings = await _trainingService.getSchedule();
      final now = DateTime.now();
      
      final upcoming = trainings.where((t) => 
        t.startsAt.isAfter(now) && !t.canceled
      ).length;
      
      final completed = trainings.where((t) => 
        t.startsAt.isBefore(now)
      ).length;
      
      // Загружаем записи пользователя
      int bookings = 0;
      try {
        final myBookings = await _trainingService.myBookings();
        bookings = myBookings.length;
      } catch (e) {
        debugPrint('[StatsScreen] Could not load bookings: $e');
      }
      
      if (!mounted) return;
      
      setState(() {
        _currentUser = user;
        _totalTrainings = trainings.length;
        _upcomingTrainings = upcoming;
        _completedTrainings = completed;
        _myBookings = bookings;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                label: Text('Общая'),
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

        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: _showMyStats
                      ? _buildMyStatsView(context)
                      : _buildTeamStatsView(context),
                ),
        ),
      ],
    );
  }

  Widget _buildMyStatsView(BuildContext context) {
    final isCoach = _currentUser?['role'] == 'COACH';
    final firstName = _currentUser?['username'] as String? ?? '';
    final firstLetter = firstName.isNotEmpty ? firstName.substring(0, 1).toUpperCase() : '?';
    
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Информация о пользователе
        Card(
          color: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white24,
                  child: Text(
                    firstLetter,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _currentUser?['username'] as String? ?? 'Пользователь',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isCoach 
                        ? Colors.orange.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isCoach ? 'Тренер' : 'Игрок',
                    style: TextStyle(
                      color: isCoach ? Colors.orange : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          'Активность',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        
        if (isCoach) ...[
          // Статистика для тренера
          StatsRow(
            title: 'Всего тренировок',
            value: '$_totalTrainings',
          ),
          StatsRow(
            title: 'Предстоящих',
            value: '$_upcomingTrainings',
          ),
          StatsRow(
            title: 'Завершено',
            value: '$_completedTrainings',
          ),
        ] else ...[
          // Статистика для игрока
          StatsRow(
            title: 'Мои записи',
            value: '$_myBookings',
          ),
          StatsRow(
            title: 'Доступно тренировок',
            value: '$_upcomingTrainings',
          ),
          StatsRow(
            title: 'Посещено',
            value: '$_completedTrainings',
          ),
        ],
        
        const SizedBox(height: 24),
        
        // Информационное сообщение
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[300],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCoach
                      ? 'Создавайте тренировки и управляйте расписанием'
                      : 'Записывайтесь на тренировки и следите за своим прогрессом',
                  style: TextStyle(
                    color: Colors.blue[300],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamStatsView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Text(
          'Общая статистика',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        
        Card(
          color: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildStatCard(
                  context,
                  'Всего тренировок',
                  '$_totalTrainings',
                  Icons.sports_basketball,
                  Colors.orange,
                ),
                const Divider(color: Colors.white24),
                _buildStatCard(
                  context,
                  'Предстоящих',
                  '$_upcomingTrainings',
                  Icons.upcoming,
                  Colors.green,
                ),
                const Divider(color: Colors.white24),
                _buildStatCard(
                  context,
                  'Завершено',
                  '$_completedTrainings',
                  Icons.check_circle,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.purple.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.timeline,
                size: 48,
                color: Colors.purple[300],
              ),
              const SizedBox(height: 12),
              Text(
                'Детальная статистика',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[300],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Скоро здесь появится подробная статистика по играм, показателям и достижениям',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.purple[300],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}