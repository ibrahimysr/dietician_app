import 'package:dietician_app/models/client_model.dart';
import 'package:dietician_app/models/subscription_plans_model.dart';
import 'package:dietician_app/models/user_model.dart';

class DietitianResponse{
   final bool success;
  final String message;
   final List<Dietitian> data;

  DietitianResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DietitianResponse.fromJson(Map<String, dynamic> json) {
    List<Dietitian> dietitians = [];
    if (json['data'] != null && json['data'] is List) {
      dietitians = (json['data'] as List)
          .map((item) => Dietitian.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return DietitianResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dietitians, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((d) => d.toJson()).toList(),
    };
  }
}


class SingleDietitianResponse {
  final bool success;
  final String message;
  final Dietitian? data;
  SingleDietitianResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SingleDietitianResponse.fromJson(Map<String, dynamic> json) {
    return SingleDietitianResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? Dietitian.fromJson(json['data'] as Map<String, dynamic>)
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
  final User? user;
  final List<ClientData> client; 
  final List<SubscriptionPlansModel> subscriptionPlans; 

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
    this.user,
    this.client = const [], 
    this.subscriptionPlans = const [], 
  });

  factory Dietitian.fromJson(Map<String, dynamic> json) {
    User? parsedUser;
    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
       parsedUser = User.fromJson(json['user'] as Map<String, dynamic>);
    }

    List<ClientData> parsedClients = [];
    if (json['clients'] != null && json['clients'] is List) {
      parsedClients = (json['clients'] as List)
          .map((e) => ClientData.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<SubscriptionPlansModel> parsedPlans = [];
     if (json['subscription_plans'] != null && json['subscription_plans'] is List) {
       parsedPlans = (json['subscription_plans'] as List)
           .map((e) => SubscriptionPlansModel.fromJson(e as Map<String, dynamic>))
           .toList();
     }

    return Dietitian(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      specialty: json['specialty'] ?? '',
      bio: json['bio'] ?? '',
      hourlyRate: json['hourly_rate'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      isActive: (json['is_active'] is bool ? json['is_active'] : (json['is_active'] == 1)) ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      user: parsedUser,
      client: parsedClients,
      subscriptionPlans: parsedPlans,
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
      'user': user?.toJson(), 
      'clients': client.map((e) => e.toJson()).toList(),
      'subscription_plans': subscriptionPlans.map((e) => e.toJson()).toList(),
    };
  }
}