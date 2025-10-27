import 'package:flutter/material.dart';

// Карточка для отображения в списке ScheduleScreen
class WorkoutCard extends StatelessWidget {
  final String title;
  final String location;
  final DateTime dateTime;
  final bool isSignedUp;
  final VoidCallback onPressed; // Функция обратного вызова при нажатии

  const WorkoutCard({
    super.key,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.isSignedUp,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPast = dateTime.isBefore(DateTime.now());

    return Card(
      color: theme.appBarTheme.backgroundColor, // Цвет как у AppBar
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // TODO: Использовать пакет intl для красивого форматирования
              '${dateTime.day}.${dateTime.month}.${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: isPast ? Colors.grey[600] : theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPast ? Colors.grey[500] : Colors.white,
                decoration: isPast ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Кнопка записи или отмены
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSignedUp
                    ? Colors.grey[700] // Кнопка отмены
                    : isPast
                        ? Colors.grey[800]
                        : theme.colorScheme.primary, // Кнопка записи
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40), // Во всю ширину
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Отключаем кнопку, если тренировка прошла
              onPressed: isPast ? null : onPressed,
              child: Text(
                isPast
                    ? 'Тренировка прошла'
                    : (isSignedUp ? 'Отменить запись' : 'Записаться'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
