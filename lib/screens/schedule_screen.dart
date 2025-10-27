import 'package:flutter/material.dart';
import '../widgets/workout_card.dart'; // Импортируем наш виджет

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<Map<String, dynamic>> _workouts = [
    {
      'id': '1',
      'title': 'Вечерняя тренировка (Вся команда)',
      'location': 'Спортзал "Победа"',
      'dateTime': DateTime.now().add(const Duration(days: 1, hours: 2)),
      'isSignedUp': false,
    },
    {
      'id': '2',
      'title': 'Бросковая тренировка (Индивид.)',
      'location': 'Площадка у парка',
      'dateTime': DateTime.now().add(const Duration(days: 3, hours: 4)),
      'isSignedUp': true,
    },
    {
      'id': '3',
      'title': 'ОФП (Мини-группа)',
      'location': 'Тренажерный зал',
      'dateTime': DateTime.now().subtract(const Duration(days: 1)), // Прошедшая
      'isSignedUp': true,
    },
  ];

  void _onSignUpToggle(String workoutId) {
    setState(() {
      final index = _workouts.indexWhere((w) => w['id'] == workoutId);
      if (index != -1) {
        _workouts[index]['isSignedUp'] = !_workouts[index]['isSignedUp'];
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_workouts.firstWhere((w) => w['id'] == workoutId)['isSignedUp']
            ? 'Вы записались на тренировку!'
            : 'Вы отменили запись.'),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _workouts.length,
      itemBuilder: (context, index) {
        final workout = _workouts[index];
        return WorkoutCard(
          title: workout['title'],
          location: workout['location'],
          dateTime: workout['dateTime'],
          isSignedUp: workout['isSignedUp'],
          onPressed: () => _onSignUpToggle(workout['id']),
        );
      },
    );
  }
}
