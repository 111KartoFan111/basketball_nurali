// stats_model.dart
// Эта модель НЕ соответствует 1-в-1 таблице 'player_stats_log'.
// Скорее всего, это АГРЕГИРОВАННЫЕ данные, которые бэкенд
// будет считать для 'stats_screen.dart'.

class PlayerAverageStats {
  final double pointsPerGame; // PPG
  final double reboundsPerGame; // RPG
  final double assistsPerGame; // APG
  final double fieldGoalPercentage; // FG%
  final double freeThrowPercentage; // FT%

  PlayerAverageStats({
    required this.pointsPerGame,
    required this.reboundsPerGame,
    required this.assistsPerGame,
    required this.fieldGoalPercentage,
    required this.freeThrowPercentage,
  });

  factory PlayerAverageStats.fromJson(Map<String, dynamic> json) {
    return PlayerAverageStats(
      // Используем num и toDouble() для безопасности (вдруг придет int)
      pointsPerGame: (json['ppg'] as num? ?? 0).toDouble(),
      reboundsPerGame: (json['rpg'] as num? ?? 0).toDouble(),
      assistsPerGame: (json['apg'] as num? ?? 0).toDouble(),
      fieldGoalPercentage: (json['fg_percentage'] as num? ?? 0).toDouble(),
      freeThrowPercentage: (json['ft_percentage'] as num? ?? 0).toDouble(),
    );
  }
}

// Эта модель соответствует 'player_stats_log'
// Используется для лога последних игр
class GameStatsLog {
  final String statId;
  final String playerId;
  final String eventDescription;
  final DateTime eventDate;
  final int points;
  final int rebounds;
  final int assists;
  // ... и т.д.

  GameStatsLog({
    required this.statId,
    required this.playerId,
    required this.eventDescription,
    required this.eventDate,
    required this.points,
    required this.rebounds,
    required this.assists,
  });

   factory GameStatsLog.fromJson(Map<String, dynamic> json) {
    return GameStatsLog(
      statId: json['stat_id'] as String,
      playerId: json['player_id'] as String,
      eventDescription: json['event_description'] as String,
      eventDate: DateTime.parse(json['event_date'] as String),
      points: json['points'] as int? ?? 0,
      rebounds: json['rebounds_total'] as int? ?? 0,
      assists: json['assists'] as int? ?? 0,
    );
  }
}
