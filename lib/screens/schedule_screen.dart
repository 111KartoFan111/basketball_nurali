import 'package:flutter/material.dart';
import '../widgets/workout_card.dart';
import '../services/training_service.dart';
import '../models/training_model.dart';
import '../models/booking_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _service = TrainingService();
  List<TrainingModel> _trainings = [];
  final Map<int, int> _myBookingByTraining = {}; // trainingId -> bookingId
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final trainings = await _service.getSchedule();
      List<BookingModel> my = [];
      try {
        my = await _service.myBookings();
      } catch (_) {}
      final map = {for (var b in my) b.trainingId: b.id};
      setState(() {
        _trainings = trainings;
        _myBookingByTraining
          ..clear()
          ..addAll(map);
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

  Future<void> _toggle(int trainingId) async {
    final booked = _myBookingByTraining.containsKey(trainingId);
    try {
      if (booked) {
        final bookingId = _myBookingByTraining[trainingId]!;
        await _service.cancelBooking(bookingId);
        setState(() => _myBookingByTraining.remove(trainingId));
      } else {
        final b = await _service.book(trainingId);
        setState(() => _myBookingByTraining[trainingId] = b.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
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
            onPressed: () => _toggle(t.id),
          );
        },
      ),
    );
  }
}
