import 'package:dietician_app/models/User.dart';

class Dietitian {
  final int id;
  final int userId;
  final String specialty;
  final String bio;
  final String hourlyRate;
  final int experienceYears;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final User? user; // User opsiyonel olarak tanımlanıyor

  Dietitian({
    required this.id,
    required this.userId,
    required this.specialty,
    required this.bio,
    required this.hourlyRate,
    required this.experienceYears,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.user, // Varsayılan olarak null olabilir
  });

  factory Dietitian.fromJson(Map<String, dynamic> json) {
    return Dietitian(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      specialty: json['specialty'] ?? '',
      bio: json['bio'] ?? '',
      hourlyRate: json['hourly_rate'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null, // Null kontrolü
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'specialty': specialty,
      'bio': bio,
      'hourly_rate': hourlyRate,
      'experience_years': experienceYears,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'user': user?.toJson(), // User null ise null döner
    };
  }
}