import 'package:dietician_app/client/models/diet_plan_model.dart';
import 'package:dietician_app/client/models/dietitian_model.dart';
import 'package:dietician_app/client/models/user_model.dart';
import 'package:dietician_app/client/models/progress_model.dart';

class ClientResponse {
  final bool success;
  final String message;
  final ClientData data;

  ClientResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ClientData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ClientData {
  final int id;
  final int userId;
  final int? dietitianId;
  final String birthDate;
  final String gender;
  final String height;
  final String weight;
  final String activityLevel;
  final String goal;
  final String allergies;
  final String preferences;
  final String medicalConditions;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final User? user;
  final Dietitian? dietitian;
  final List<DietPlan> dietPlans;
  final List<Progress> progress;

  ClientData({
    required this.id,
    required this.userId,
    this.dietitianId,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.goal,
    required this.allergies,
    required this.preferences,
    required this.medicalConditions,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.user,
    this.dietitian,
    required this.dietPlans,
    required this.progress,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      dietitianId: json['dietitian_id'],
      birthDate: json['birth_date'] ?? '',
      gender: json['gender'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      activityLevel: json['activity_level'] ?? '',
      goal: json['goal'] ?? '',
      allergies: json['allergies'] ?? '',
      preferences: json['preferences'] ?? '',
      medicalConditions: json['medical_conditions'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      dietitian: json['dietitian'] != null ? Dietitian.fromJson(json['dietitian']) : null,
      dietPlans: (json['diet_plans'] as List<dynamic>?)
              ?.map((e) => DietPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      progress: (json['progress'] as List<dynamic>?)
              ?.map((e) => Progress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'dietitian_id': dietitianId,
      'birth_date': birthDate,
      'gender': gender,
      'height': height,
      'weight': weight,
      'activity_level': activityLevel,
      'goal': goal,
      'allergies': allergies,
      'preferences': preferences,
      'medical_conditions': medicalConditions,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'user': user?.toJson(),
      'dietitian': dietitian?.toJson(),
      'diet_plans': dietPlans.map((e) => e.toJson()).toList(),
      'progress': progress.map((e) => e.toJson()).toList(),
    };
  }
}






