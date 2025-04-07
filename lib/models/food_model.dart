import 'package:dietician_app/models/user_model.dart';

class FoodListResponse {
  final bool success;
  final String message;
  final List<Food> data; 

  FoodListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

 factory FoodListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<Food> foodList = list != null
        ? list.map((i) => Food.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return FoodListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: foodList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((food) => food.toJson()).toList(),
    };
  }
}


class Food {
  final int id;
  final String name;
  final String category;
  final String servingSize;
  final int calories;
  final String protein;
  final String fat;
  final String carbs;
  final String fiber;
  final String sugar;
  final bool isCustom;
  final int? createdBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final User? creator; 

  Food({
    required this.id,
    required this.name,
    required this.category,
    required this.servingSize,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.sugar,
    required this.isCustom,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.creator, 
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      servingSize: json['serving_size'] ?? '0.00',
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? '0.00',
      fat: json['fat'] ?? '0.00',
      carbs: json['carbs'] ?? '0.00',
      fiber: json['fiber'] ?? '0.00',
      sugar: json['sugar'] ?? '0.00',
      isCustom: json['is_custom'] ?? false,
      createdBy: json['created_by'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      creator: json['creator'] != null && json['creator'] is Map<String, dynamic>
               ? User.fromJson(json['creator']) 
               : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'serving_size': servingSize,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
      'sugar': sugar,
      'is_custom': isCustom,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'creator': creator?.toJson(),
    };
  }
}

