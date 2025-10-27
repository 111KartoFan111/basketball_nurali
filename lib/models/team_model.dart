// team_model.dart
// Соответствует таблице 'teams'

class TeamModel {
  final String teamId;
  final String teamName;
  final String coachId;
  // Можно добавить List<UserModel> members, если API будет их возвращать

  TeamModel({
    required this.teamId,
    required this.teamName,
    required this.coachId,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      teamId: json['team_id'] as String,
      teamName: json['team_name'] as String,
      coachId: json['coach_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'team_name': teamName,
      'coach_id': coachId,
    };
  }
}
