import 'dart:convert';

class UserModel {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime? dateOfBirth;
  final String? profilePhotoUrl;

  UserModel({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.dateOfBirth,
    this.profilePhotoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      role: json['role'] as String,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      profilePhotoUrl: json['profile_photo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'profile_photo_url': profilePhotoUrl,
    };
  }
}
