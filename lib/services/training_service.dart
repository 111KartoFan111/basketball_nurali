import '../models/training_model.dart';
import '../models/booking_model.dart';
import 'api_service.dart';

class TrainingService {
  final ApiService _api = ApiService();

  Future<List<TrainingModel>> getSchedule() async {
    final resp = await _api.get('trainings');
    // resp is a List<dynamic>
    final list = (resp as List).cast<Map<String, dynamic>>();
    return list.map((e) => TrainingModel.fromJson(e)).toList();
  }

  Future<BookingModel> book(int trainingId) async {
    final resp = await _api.post('bookings/$trainingId', {});
    return BookingModel.fromJson(resp as Map<String, dynamic>);
  }

  Future<List<BookingModel>> myBookings() async {
    final resp = await _api.get('bookings/me');
    final list = (resp as List).cast<Map<String, dynamic>>();
    return list.map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<void> cancelBooking(int bookingId) async {
    await _api.delete('bookings/$bookingId');
  }
}