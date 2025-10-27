class WorkoutModel {
  final String workoutId;
  final String teamId;
  final String title;
  final String? description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;

  final bool isSignedUp; 

  WorkoutModel({
    required this.workoutId,
    required this.teamId,
    required this.title,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.isSignedUp,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      workoutId: json['workout_id'] as String,
      teamId: json['team_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      isSignedUp: json['is_signed_up'] as bool? ?? false, 
    );
  }
}
