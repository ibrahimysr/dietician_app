
import 'package:dietician_app/models/dietitian_model.dart';

class DietPlanListResponse {
  final bool success;
  final String message;
  final List<DietPlan> data; 

  DietPlanListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DietPlanListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?; 
    List<DietPlan> dietPlanList = list != null
        ? list.map((i) => DietPlan.fromJson(i)).toList()
        : []; 

    return DietPlanListResponse(
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



class Meal {
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

  Meal({
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

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? 0,
      dietPlanId: json['diet_plan_id'] ?? 0,
      dayNumber: json['day_number'] ?? 0,
      mealType: json['meal_type'] ?? '',
      description: json['description'] ?? '',
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? '0.00',
      fat: json['fat'] ?? '0.00',
      carbs: json['carbs'] ?? '0.00',
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




 

class DietPlan {
  final int id;
  final int clientId;
  final int dietitianId;
  final String title;
  final String startDate; // String olarak bırakmak genellikle daha güvenlidir
  final String endDate;   // İstersen DateTime'a çevirebilirsin
  final int dailyCalories;
  final String notes;
  final String status;
  final bool isOngoing;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt; // Null olabilir
  final Dietitian dietitian; // İç içe nesne
  final List<Meal> meals;   // İç içe liste

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
    required this.dietitian,
    required this.meals,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    // 'meals' listesini ayrıştırma
    var mealList = json['meals'] as List?;
    List<Meal> mealsData = mealList != null
        ? mealList.map((m) => Meal.fromJson(m)).toList()
        : [];

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
      dietitian: Dietitian.fromJson(json['dietitian'] ?? {}), 
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