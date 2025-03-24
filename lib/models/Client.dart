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
  final String updatedAt;
  final String createdAt;
  final int id;

  ClientData({
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
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
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
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}