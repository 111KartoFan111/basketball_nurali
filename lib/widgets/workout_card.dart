import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String location;
  final DateTime dateTime;
  final bool isSignedUp;
  final VoidCallback onPressed;
  final bool isCoach;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.isSignedUp,
    required this.onPressed,
    this.isCoach = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPast = dateTime.isBefore(DateTime.now());

    return Card(
      color: theme.appBarTheme.backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${dateTime.day}.${dateTime.month}.${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isPast ? Colors.grey[600] : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (isCoach)
                  Icon(
                    Icons.admin_panel_settings,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
              ],
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
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCoach
                    ? theme.colorScheme.primary
                    : isSignedUp
                        ? Colors.grey[700]
                        : isPast
                            ? Colors.grey[800]
                            : theme.colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: (isPast && !isCoach) ? null : onPressed,
              child: Text(
                isCoach
                    ? 'Управление'
                    : isPast
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