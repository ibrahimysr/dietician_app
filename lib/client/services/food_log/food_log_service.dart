import 'dart:developer';

import 'package:dietician_app/client/models/compare_diet_plan_model.dart';
import 'package:dietician_app/client/models/simple_api_response.dart';
import 'package:intl/intl.dart';
import 'package:dietician_app/client/models/food_log_model.dart';
import 'package:dietician_app/client/services/api/api_client.dart';

class FoodLogService {
  final ApiClient _apiClient;

  FoodLogService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<FoodLogListResponse> getFoodLog({String? token, required int id}) async {
    final response = await _apiClient.get('clients/$id/food-logs', token: token);
    return FoodLogListResponse.fromJson(response);
  }

  Future<FoodLogListResponse> getFoodLogDate({String? token, required int id, required DateTime date}) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final response = await _apiClient.get('clients/$id/food-logs/$formattedDate', token: token);
    return FoodLogListResponse.fromJson(response);
  }

  Future<FoodLogResponse> addFoodLog({
    required String token,
    required int clientId,
    required DateTime date,      
    required String mealType,
    String? foodDescription,      
    int? foodId,                  
    required double quantity,      
    required int calories,
    double? protein,            
    double? fat,                  
    double? carbs,                
    required DateTime loggedAt,   
    String? photoUrl,           
  }) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
     
      final formattedLoggedAt = loggedAt.toUtc().toIso8601String();

      final Map<String, dynamic> requestBody = {
        'client_id': clientId,
        'date': formattedDate,
        'meal_type': mealType,
        'quantity': quantity, 
        'calories': calories,
        'logged_at': formattedLoggedAt,
        if (foodDescription != null) 'food_description': foodDescription,
        if (foodId != null) 'food_id': foodId,
        if (protein != null) 'protein': protein,
        if (fat != null) 'fat': fat,
        if (carbs != null) 'carbs': carbs,
        if (photoUrl != null) 'photo_url': photoUrl,
      };

      final response = await _apiClient.post(
        'food-logs-add', 
        body: requestBody,
        token: token,
      );

      return FoodLogResponse.fromJson(response);

    } catch (e) {
      log("addFoodLog sırasında hata: $e");
      return FoodLogResponse(success: false, message: 'Kayıt eklenirken bir hata oluştu: ${e.toString()}', data: null);
    }
  } 
   Future<DietComparisonResponse> getDietComparison({
    required String token,
    required int clientId,
    required DateTime date,
  }) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final String path = 'clients/$clientId/compare-diet-plan/$formattedDate';

      final response = await _apiClient.get(path, token: token);

      return DietComparisonResponse.fromJson(response);
    } catch (e) {
      log("getDietComparison sırasında hata: $e");
      return DietComparisonResponse(
        success: false,
        message: 'Karşılaştırma verisi alınırken bir hata oluştu: ${e.toString()}',
        data: null,
      );
    }
  } 

  Future<SimpleApiResponse> deleteFoodLog({
    required String token,
    required int logId,
  }) async {
    try {
      final String path = 'food-logs-delete/$logId';
      final response = await _apiClient.delete(path, token: token);
      return SimpleApiResponse.fromJson(response);
      
    } catch (e) {
      log("deleteFoodLog sırasında hata: $e");
      return SimpleApiResponse(
          success: false, message: 'Kayıt silinirken bir hata oluştu: ${e.toString()}');
    }
  }

  Future<FoodLogResponse> updateFoodLog({
    required String token,
    required int logId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      final String path = 'food-logs-update/$logId';

      
      if (updateData.containsKey('logged_at') && updateData['logged_at'] is DateTime) {
         updateData['logged_at'] = (updateData['logged_at'] as DateTime).toUtc().toIso8601String();
      }
       if (updateData.containsKey('date') && updateData['date'] is DateTime) {
         updateData['date'] = DateFormat('yyyy-MM-dd').format(updateData['date']);
      }
      

      final response = await _apiClient.put(
        path,
        body: updateData, 
        token: token,
      );

      return FoodLogResponse.fromJson(response);

    } catch (e) {
      log("updateFoodLog sırasında hata: $e");
      return FoodLogResponse(
        success: false,
        message: 'Kayıt güncellenirken bir hata oluştu: ${e.toString()}',
        data: null,
      );
    }
  }
}