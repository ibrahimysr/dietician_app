import 'dart:convert';
import 'dart:developer';

import 'package:dietician_app/client/models/recipes_model.dart'; 

class DietitianUser {
  final int id;
  final String name;
  final String email;
  final String? phone; 
  final String? profilePhoto; 
  final String role;
  final String? lastLoginAt; 
  final String createdAt;
  final String updatedAt;
  final String? deletedAt; 

  DietitianUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePhoto,
    required this.role,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory DietitianUser.fromJson(Map<String, dynamic> json) {
    return DietitianUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Bilinmiyor', 
      email: json['email'] ?? '',
      phone: json['phone'],
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


class DietitianResponse {
  final bool success;
  final String message;
  final DietitianData? data; 

  DietitianResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DietitianResponse.fromJson(Map<String, dynamic> json) {
    return DietitianResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['success'] == true && json['data'] != null && json['data'] is Map<String, dynamic>
          ? DietitianData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class DietitianData {
  final int id;
  final int userId;
  final String specialty;
  final String bio;
  final double hourlyRate;
  final int experienceYears;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final DietitianUser? user; 
  final List<DietitianClient> clients;
  final List<DietitianSubscriptionPlan> subscriptionPlans;
  final List<Recipes> recipes;

  DietitianData({
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
    this.user, 
    required this.clients,
    required this.subscriptionPlans,
    required this.recipes,
  });

  factory DietitianData.fromJson(Map<String, dynamic> json) {
    var clientList = json['clients'] as List?;
    List<DietitianClient> clientsData = clientList != null
        ? clientList.map((c) => DietitianClient.fromJson(c)).toList()
        : [];

    var planList = json['subscription_plans'] as List?;
    List<DietitianSubscriptionPlan> plansData = planList != null
        ? planList.map((p) => DietitianSubscriptionPlan.fromJson(p)).toList()
        : [];

    var recipeList = json['recipes'] as List?;
    List<Recipes> recipesData = recipeList != null
        ? recipeList.map((r) => Recipes.fromJson(r)).toList()
        : [];

    return DietitianData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      specialty: json['specialty'] ?? '',
      bio: json['bio'] ?? '',
      hourlyRate: double.tryParse(json['hourly_rate']?.toString() ?? '0.0') ?? 0.0,
      experienceYears: json['experience_years'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      user: json['user'] != null ? DietitianUser.fromJson(json['user']) : null,
      clients: clientsData,
      subscriptionPlans: plansData,
      recipes: recipesData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'specialty': specialty,
      'bio': bio,
      'hourly_rate': hourlyRate.toStringAsFixed(2),
      'experience_years': experienceYears,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'user': user?.toJson(), 
      'clients': clients.map((c) => c.toJson()).toList(),
      'subscription_plans': subscriptionPlans.map((p) => p.toJson()).toList(),
      'recipes': recipes.map((r) => r.toJson()).toList(),
    };
  }
}

class DietitianClient {
  final int id;
  final int userId;
  final int dietitianId;
  final String birthDate;
  final String gender;
  final double height;
  final double weight;
  final String activityLevel;
  final String goal;
  final String allergies;
  final String preferences;
  final String medicalConditions;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final DietitianUser? user; 

  DietitianClient({
    required this.id,
    required this.userId,
    required this.dietitianId,
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
  });

  factory DietitianClient.fromJson(Map<String, dynamic> json) {
    return DietitianClient(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      dietitianId: json['dietitian_id'] ?? 0,
      birthDate: json['birth_date'] ?? '',
      gender: json['gender'] ?? '',
      height: double.tryParse(json['height']?.toString() ?? '0.0') ?? 0.0,
      weight: double.tryParse(json['weight']?.toString() ?? '0.0') ?? 0.0,
      activityLevel: json['activity_level'] ?? '',
      goal: json['goal'] ?? '',
      allergies: json['allergies'] ?? '',
      preferences: json['preferences'] ?? '',
      medicalConditions: json['medical_conditions'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      user: json['user'] != null ? DietitianUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'dietitian_id': dietitianId,
      'birth_date': birthDate,
      'gender': gender,
      'height': height.toStringAsFixed(2),
      'weight': weight.toStringAsFixed(2),
      'activity_level': activityLevel,
      'goal': goal,
      'allergies': allergies,
      'preferences': preferences,
      'medical_conditions': medicalConditions,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'user': user?.toJson(), 
    };
  }
}


class DietitianSubscriptionPlan {
  final int id;
  final int dietitianId;
  final String name;
  final String description;
  final int duration;
  final double price;
  final List<String> features;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  DietitianSubscriptionPlan({
    required this.id,
    required this.dietitianId,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.features,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory DietitianSubscriptionPlan.fromJson(Map<String, dynamic> json) {
    List<String> featuresList = [];
    if (json['features'] != null && json['features'] is List) {
      featuresList = List<String>.from(json['features'].map((item) => item.toString()));
    } else if (json['features'] is String) {
        try {
             var decoded = jsonDecode(json['features']);
             if (decoded is List) {
                 featuresList = List<String>.from(decoded.map((item) => item.toString()));
             }
        } catch (e) {
             featuresList = [json['features']];
             log("Uyarı: Özellikler JSON string olarak çözümlenemedi: ${json['features']}");
        }
    }

    return DietitianSubscriptionPlan(
      id: json['id'] ?? 0,
      dietitianId: json['dietitian_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      features: featuresList,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dietitian_id': dietitianId,
      'name': name,
      'description': description,
      'duration': duration,
      'price': price.toStringAsFixed(2),
      'features': features,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

