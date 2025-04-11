import 'package:dietician_app/client/models/client_model.dart';
import 'package:dietician_app/client/models/food_model.dart';

class FoodLog {
  final int id;
  final int clientId;
  final int? foodId;
  final String date; 
  final String mealType; 
  final String? foodDescription; 
  final String quantity; 
  final int calories;
  final String? protein; 
  final String? fat;    
  final String? carbs;  
  final String? photoUrl; 
  final String loggedAt;
  final String createdAt; 
  final String updatedAt; 
  final String? deletedAt; 
  final ClientData? client; 
  final Food? food; 

  FoodLog({
    required this.id,
    required this.clientId,
    this.foodId,
    required this.date,
    required this.mealType,
    this.foodDescription,
    required this.quantity,
    required this.calories,
    this.protein,
    this.fat,
    this.carbs,
    this.photoUrl,
    required this.loggedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.client,
    this.food,
  });

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      foodId: json['food_id'], 
      date: json['date'] ?? '',
      mealType: json['meal_type'] ?? '',
      foodDescription: json['food_description'],
      quantity: (json['quantity'] ?? '0.00').toString(),
      calories: json['calories'] ?? 0,
      protein: json['protein']?.toString(),
      fat: json['fat']?.toString(),
      carbs: json['carbs']?.toString(),
      photoUrl: json['photo_url'], 
      loggedAt: json['logged_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      client: json['client'] != null && json['client'] is Map<String, dynamic>
          ? ClientData.fromJson(json['client'])
          : null,
      food: json['food'] != null && json['food'] is Map<String, dynamic>
          ? Food.fromJson(json['food'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'food_id': foodId,
      'date': date,
      'meal_type': mealType,
      'food_description': foodDescription,
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'photo_url': photoUrl,
      'logged_at': loggedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'client': client?.toJson(),
      'food': food?.toJson(),
    };
  }
}

class FoodLogListResponse {
  final bool success;
  final String message;
  final List<FoodLog> data;

  FoodLogListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FoodLogListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<FoodLog> logList = list != null
        ? list.map((i) => FoodLog.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return FoodLogListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: logList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((log) => log.toJson()).toList(),
    };
  }
}

class FoodLogResponse {
  final bool success;
  final String message;
  final FoodLog? data;
  FoodLogResponse({
    required this.success,
    required this.message,
    this.data, 
  });

  factory FoodLogResponse.fromJson(Map<String, dynamic> json) {
     FoodLog? parsedData;
     if (json['data'] != null && json['data'] is Map<String, dynamic>) {
       parsedData = FoodLog.fromJson(json['data']);
     } else {
       parsedData = null;
     }

    return FoodLogResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
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