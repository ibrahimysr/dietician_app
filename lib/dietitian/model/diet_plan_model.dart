import 'package:dietician_app/dietitian/model/dietitian_model.dart';

class ClientDietPlanListResponse {
  final bool success;
  final String message;
  final List<ClientDietPlan> data;

  ClientDietPlanListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClientDietPlanListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<ClientDietPlan> dietPlanList = list != null
        ? list.map((i) => ClientDietPlan.fromJson(i)).toList()
        : [];
    return ClientDietPlanListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dietPlanList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((plan) => plan.toJson()).toList(),
    };
  }
}

class ClientDietPlan {
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
  final DietitianData dietitian;
  final List<ClientMeal> meals;

  ClientDietPlan({
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
    required this.dietitian,
    required this.meals,
  });

  factory ClientDietPlan.fromJson(Map<String, dynamic> json) {
    var mealList = json['meals'] as List?;
    List<ClientMeal> mealsData = mealList != null
        ? mealList.map((m) => ClientMeal.fromJson(m)).toList()
        : [];

    final dietitianData = json['dietitian'] != null
        ? DietitianData.fromJson(json['dietitian'])
        : DietitianData(
            id: 0,
            userId: 0,
            specialty: '',
            bio: '',
            hourlyRate: 0,
            experienceYears: 0,
            isActive: false,
            createdAt: '',
            updatedAt: '',
            clients: [],
            subscriptionPlans: [],
            recipes: []);

    return ClientDietPlan(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      dietitianId: json['dietitian_id'] ?? 0,
      title: json['title'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      dailyCalories: json['daily_calories'] ?? 0,
      notes: json['notes'] ?? '',
      status: json['status'] ?? 'unknown',
      isOngoing: json['is_ongoing'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      dietitian: dietitianData,
      meals: mealsData,
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
      'dietitian': dietitian.toJson(),
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}

class ClientMeal {
  final int id;
  final int dietPlanId;
  final int dayNumber;
  final String mealType;
  final String description;
  final int calories;
  final String protein;
  final String fat;
  final String carbs;
  final String? photoUrl;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ClientMeal({
    required this.id,
    required this.dietPlanId,
    required this.dayNumber,
    required this.mealType,
    required this.description,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ClientMeal.fromJson(Map<String, dynamic> json) {
    return ClientMeal(
      id: json['id'] ?? 0,
      dietPlanId: json['diet_plan_id'] ?? 0,
      dayNumber: json['day_number'] ?? 0,
      mealType: json['meal_type'] ?? '',
      description: json['description'] ?? '',
      calories: json['calories'] ?? 0,
      protein: json['protein']?.toString() ?? '0.00',
      fat: json['fat']?.toString() ?? '0.00',
      carbs: json['carbs']?.toString() ?? '0.00',
      photoUrl: json['photo_url'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diet_plan_id': dietPlanId,
      'day_number': dayNumber,
      'meal_type': mealType,
      'description': description,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'photo_url': photoUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
