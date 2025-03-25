// class ClientResponse {
//   final bool success;
//   final String message;
//   final ClientData data;

//   ClientResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory ClientResponse.fromJson(Map<String, dynamic> json) {
//     return ClientResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: ClientData.fromJson(json['data'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data.toJson(),
//     };
//   }
// }

// class ClientData {
//   final int userId;
//   final int? dietitianId;
//   final String birthDate;
//   final String gender;
//   final String height;
//   final String weight;
//   final String activityLevel;
//   final String goal;
//   final String allergies;
//   final String preferences;
//   final String medicalConditions;
//   final String updatedAt;
//   final String createdAt;
//   final int id;

//   ClientData({
//     required this.userId,
//     this.dietitianId,
//     required this.birthDate,
//     required this.gender,
//     required this.height,
//     required this.weight,
//     required this.activityLevel,
//     required this.goal,
//     required this.allergies,
//     required this.preferences,
//     required this.medicalConditions,
//     required this.updatedAt,
//     required this.createdAt,
//     required this.id,
//   });

//   factory ClientData.fromJson(Map<String, dynamic> json) {
//     return ClientData(
//       userId: json['user_id'] ?? 0,
//       dietitianId: json['dietitian_id'],
//       birthDate: json['birth_date'] ?? '',
//       gender: json['gender'] ?? '',
//       height: json['height'] ?? '',
//       weight: json['weight'] ?? '',
//       activityLevel: json['activity_level'] ?? '',
//       goal: json['goal'] ?? '',
//       allergies: json['allergies'] ?? '',
//       preferences: json['preferences'] ?? '',
//       medicalConditions: json['medical_conditions'] ?? '',
//       updatedAt: json['updated_at'] ?? '',
//       createdAt: json['created_at'] ?? '',
//       id: json['id'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'user_id': userId,
//       'dietitian_id': dietitianId,
//       'birth_date': birthDate,
//       'gender': gender,
//       'height': height,
//       'weight': weight,
//       'activity_level': activityLevel,
//       'goal': goal,
//       'allergies': allergies,
//       'preferences': preferences,
//       'medical_conditions': medicalConditions,
//       'updated_at': updatedAt,
//       'created_at': createdAt,
//       'id': id,
//     };
//   }
// }

// models/client_response.dart

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

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? profilePhoto;
  final String role;
  final String? lastLoginAt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhoto,
    required this.role,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePhoto: json['profile_photo'],
      role: json['role'] ?? '',
      lastLoginAt: json['last_login_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_photo': profilePhoto,
      'role': role,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

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
    };
  }
}

class DietPlan {
  final int id;
  final int clientId;
  final int dietitianId;
  final String title;
  final String startDate;
  final String endDate;
  final int dailyCalories;
  final String notes;
  final String status;
  final bool isOngoing;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  DietPlan({
    required this.id,
    required this.clientId,
    required this.dietitianId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.dailyCalories,
    required this.notes,
    required this.status,
    required this.isOngoing,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      dietitianId: json['dietitian_id'] ?? 0,
      title: json['title'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      dailyCalories: json['daily_calories'] ?? 0,
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
      isOngoing: json['is_ongoing'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'dietitian_id': dietitianId,
      'title': title,
      'start_date': startDate,
      'end_date': endDate,
      'daily_calories': dailyCalories,
      'notes': notes,
      'status': status,
      'is_ongoing': isOngoing,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class Progress {
  final int id;
  final int clientId;
  final String date;
  final String weight;
  final String waist;
  final String arm;
  final String chest;
  final String hip;
  final String bodyFatPercentage;
  final String notes;
  final String photoUrl;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Progress({
    required this.id,
    required this.clientId,
    required this.date,
    required this.weight,
    required this.waist,
    required this.arm,
    required this.chest,
    required this.hip,
    required this.bodyFatPercentage,
    required this.notes,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      date: json['date'] ?? '',
      weight: json['weight'] ?? '',
      waist: json['waist'] ?? '',
      arm: json['arm'] ?? '',
      chest: json['chest'] ?? '',
      hip: json['hip'] ?? '',
      bodyFatPercentage: json['body_fat_percentage'] ?? '',
      notes: json['notes'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'date': date,
      'weight': weight,
      'waist': waist,
      'arm': arm,
      'chest': chest,
      'hip': hip,
      'body_fat_percentage': bodyFatPercentage,
      'notes': notes,
      'photo_url': photoUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}