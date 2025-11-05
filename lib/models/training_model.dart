class TrainingModel {
  final int id;
  final String title;
  final String? description;
  final DateTime startsAt;
  final DateTime endsAt;
  final int capacity;
  final bool canceled;

  TrainingModel({
    required this.id,
    required this.title,
    this.description,
    required this.startsAt,
    required this.endsAt,
    required this.capacity,
    required this.canceled,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) => TrainingModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String?,
        startsAt: DateTime.parse(json['startsAt'] as String),
        endsAt: DateTime.parse(json['endsAt'] as String),
        capacity: json['capacity'] as int,
        canceled: json['canceled'] as bool? ?? false,
      );
}