class UserAnalytics {
  final int userId;
  final String username;
  final int totalBookings;
  final int canceledBookings;
  final double attendanceRate;
  final DateTime? lastTrainingDate;

  UserAnalytics({
    required this.userId,
    required this.username,
    required this.totalBookings,
    required this.canceledBookings,
    required this.attendanceRate,
    this.lastTrainingDate,
  });

  factory UserAnalytics.fromJson(Map<String, dynamic> json) {
    return UserAnalytics(
      userId: json['userId'] as int,
      username: json['username'] as String,
      totalBookings: json['totalBookings'] as int,
      canceledBookings: json['canceledBookings'] as int,
      attendanceRate: json['attendanceRate'] as double,
      lastTrainingDate: json['lastTrainingDate'] != null 
          ? DateTime.parse(json['lastTrainingDate'] as String)
          : null,
    );
  }
}