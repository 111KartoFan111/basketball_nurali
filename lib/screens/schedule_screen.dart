import 'package:flutter/material.dart';
import '../widgets/workout_card.dart';
import '../services/training_service.dart';
import '../services/user_service.dart';
import '../models/training_model.dart';
import '../models/booking_model.dart';
import 'create_training_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _service = TrainingService();
  final _userService = UserService();
  
  List<TrainingModel> _trainings = [];
  final Map<int, int> _myBookingByTraining = {}; // trainingId -> bookingId
  bool _loading = true;
  String? _errorMessage;
  bool _isCoach = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _load();
  }

  Future<void> _loadUserRole() async {
    try {
      final user = await _userService.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _isCoach = user.role == 'COACH';
      });
    } catch (e) {
      print('[ScheduleScreen] Could not load user role: $e');
      // Не критично, продолжаем работу
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      // Загружаем тренировки
      final trainings = await _service.getSchedule();
      
      // Загружаем записи (если произойдет ошибка, получим пустой список)
      List<BookingModel> my = [];
      if (!_isCoach) {
        try {
          my = await _service.myBookings();
        } catch (e) {
          print('[ScheduleScreen] Warning: Could not load bookings: $e');
        }
      }
      
      final map = {for (var b in my) b.trainingId: b.id};
      
      if (!mounted) return;
      
      setState(() {
        _trainings = trainings;
        _myBookingByTraining
          ..clear()
          ..addAll(map);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Ошибка загрузки: $e';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки тренировок: $e'),
          action: SnackBarAction(
            label: 'Повторить',
            onPressed: _load,
          ),
        ),
      );
    }
  }

  Future<void> _toggle(int trainingId) async {
    final booked = _myBookingByTraining.containsKey(trainingId);
    
    try {
      if (booked) {
        final bookingId = _myBookingByTraining[trainingId]!;
        await _service.cancelBooking(bookingId);
        if (!mounted) return;
        setState(() => _myBookingByTraining.remove(trainingId));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Запись отменена'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final b = await _service.book(trainingId);
        if (!mounted) return;
        setState(() => _myBookingByTraining[trainingId] = b.id);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Вы записаны на тренировку!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  Future<void> _navigateToCreateTraining() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTrainingScreen(),
      ),
    );

    // Если тренировка создана, обновляем список
    if (result == true) {
      _load();
    }
  }

  Future<void> _showTrainingOptions(TrainingModel training) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Отменить тренировку'),
              onTap: () => Navigator.pop(context, 'cancel'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (action == 'cancel' && mounted) {
      _confirmCancelTraining(training);
    }
  }

  Future<void> _confirmCancelTraining(TrainingModel training) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить тренировку?'),
        content: Text('Вы уверены, что хотите отменить "${training.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Да', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.cancelTraining(training.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Тренировка отменена')),
        );
        _load();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка тренировок...'),
          ],
        ),
      );
    }

    if (_errorMessage != null && _trainings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[400]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Попробовать снова'),
              ),
            ],
          ),
        ),
      );
    }

    if (_trainings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_basketball,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Нет доступных тренировок',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isCoach
                  ? 'Нажмите + чтобы создать тренировку'
                  : 'Тренировки появятся здесь,\nкогда тренер их создаст',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              label: const Text('Обновить'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _trainings.length,
          itemBuilder: (context, index) {
            final t = _trainings[index];
            final isSigned = _myBookingByTraining.containsKey(t.id);
            
            return WorkoutCard(
              title: t.title,
              location: t.description ?? 'Спортзал',
              dateTime: t.startsAt,
              isSignedUp: isSigned,
              onPressed: _isCoach 
                  ? () => _showTrainingOptions(t)
                  : () => _toggle(t.id),
              isCoach: _isCoach,
            );
          },
        ),
      ),
      floatingActionButton: _isCoach
          ? FloatingActionButton.extended(
              onPressed: _navigateToCreateTraining,
              icon: const Icon(Icons.add),
              label: const Text('Создать'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            )
          : null,
    );
  }
}