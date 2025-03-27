import 'package:dietician_app/models/Dietitian.dart';

class RecipesResponse { 
  final bool success;
  final String message; 
  final List<Recipes> data;  // Change this to a List

  RecipesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RecipesResponse.fromJson(Map<String, dynamic> json) {
    return RecipesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
          ?.map((item) => Recipes.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((recipe) => recipe.toJson()).toList(),
    };
  }
} 


class Recipes { 
  final int id; 
  final int dietitianId; 
  final String title;
  final String description;
  final List ingredients; 
  final String instructions; 
  final int prepTime; 
  final int cookTime;
  final int servings;
  final int calories; 
  final String protein; 
  final String carbs;
  final String fat;
  final String tags;
  final String photoUrl; 
  final bool isPublic; 
  final String createdAt;
  final String updatedAt;
  final Dietitian dietitian; 

  Recipes({
    required this.id,
    required this.dietitianId,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.tags,
    required this.photoUrl,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
    required this.dietitian,
  });

  factory Recipes.fromJson(Map<String, dynamic> json) {
    return Recipes(
      id: json['id'] ?? 0,
      dietitianId: json['dietitian_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ingredients: json['ingredients'] ?? [],
      instructions: json['instructions'] ?? '',
      prepTime: json['prep_time'] ?? 0,
      cookTime: json['cook_time'] ?? 0,
      servings: json['servings'] ?? 0,
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? '',
      carbs: json['carbs'] ?? '',
      fat: json['fat'] ?? '',
      tags: json['tags'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      isPublic: json['is_public'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      dietitian: Dietitian.fromJson(json['dietitian'] ?? {}),
    );
  }

  Map<String,dynamic> toJson(){ 
    return { 
      "id": id,
      "dietitian_id": dietitianId,
      "title": title,
      "description": description,
      "ingredients": ingredients,
      "instructions": instructions,
      "prep_time": prepTime,
      "cook_time": cookTime,
      "servings": servings,
      "calories": calories,
      "protein": protein,
      "carbs": carbs,
      "fat": fat,
      "tags": tags,
      "photo_url": photoUrl,
      "is_public": isPublic,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "dietitian": dietitian.toJson(),
    };
  }
}
