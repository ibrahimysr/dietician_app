import 'dart:developer';

import 'package:dietician_app/client/services/api/api_client.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';

class DietPlanService {
  final ApiClient _apiClient;

  DietPlanService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<ClientDietPlanListResponse> getClientDietPlans({
    required int clientId,
    required String? token,
  }) async {
    final String endpoint = 'clients/$clientId/diet-plans';

    try {
      final response = await _apiClient.get(endpoint, token: token);

      return ClientDietPlanListResponse.fromJson(response);
    } catch (e) {
      return ClientDietPlanListResponse(
          success: false,
          message: "Planlar alınırken bir hata oluştu: $e",
          data: []);
    }
  }

  Future<Map<String, dynamic>?> addDietPlan(
      {required String token, required Map<String, dynamic> data}) async {
    final String endpoint = "diet-plans-add";
    try {
      final response =
          await _apiClient.post(endpoint, token: token, body: data);

      return response;
    } on ApiException catch (e) {
      log("API Hatası (ApiException): $e");
      rethrow;
    } catch (e) {
      log("Diyet Planı Ekleme Servis Genel Hata: $e");
      throw Exception(
          "Diyet Planı eklenirken beklenmedik bir hata oluştu: ${e.toString()}");
    }
  } 

   Future<Map<String, dynamic>?> updateDietPlan(
      {required String token, required Map<String, dynamic> data,required int dietplanid}) async {
    final String endpoint = "diet-plans-update/$dietplanid";
    try {
      final response =
          await _apiClient.put(endpoint, token: token, body: data);

      return response;
    } on ApiException catch (e) {
      log("API Hatası (ApiException): $e");
      rethrow;
    } catch (e) {
      log("Diyet Planı Güncelleme Servis Genel Hata: $e");
      throw Exception(
          "Diyet Planı Güncellenirken beklenmedik bir hata oluştu: ${e.toString()}");
    }
  } 

   Future<Map<String, dynamic>?> deleteDietPlan(
      {required String token,required int dietplanid}) async {
    final String endpoint = "diet-plans-deletes/$dietplanid";
    try {
      final response =
          await _apiClient.delete(endpoint, token: token);

      return response;
    } on ApiException catch (e) {
      log("API Hatası (ApiException): $e");
      rethrow;
    } catch (e) {
      log("Diyet Planı Silerken Servis Genel Hata: $e");
      throw Exception(
          "Diyet Planı Silerken beklenmedik bir hata oluştu: ${e.toString()}");
    }
  }
}
