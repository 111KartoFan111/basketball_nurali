class BookingModel {
  final int id;
  final int trainingId;

  BookingModel({required this.id, required this.trainingId});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // backend returns booking with nested training
    final training = json['training'] as Map<String, dynamic>?;
    final tId = training != null ? training['id'] as int : json['trainingId'] as int;
    return BookingModel(id: json['id'] as int, trainingId: tId);
  }
}