import 'dart:developer';

import 'package:dietician_app/client/models/progress_model.dart';
import 'package:dietician_app/client/services/api/api_client.dart';
import 'package:dietician_app/client/models/simple_api_response.dart';

class ProgressService {
  final ApiClient _apiClient;

  ProgressService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<ProgressResponse> getProgress({
    required String token,
    required int clientId,
  }) async {
    try {
      final String path = 'clients/$clientId/progress';
      final response = await _apiClient.get(path, token: token);
      return ProgressResponse.fromJson(response);
    } catch (e) {
      return ProgressResponse(
          success: false,
          message: 'İlerlemeler alınamadı: ${e.toString()}',
          data: []);
    }
  }

  Future<Map<String,dynamic>> addProgress({
    required String token,
    required Map<String, dynamic> progressData,
  }) async {
    try {
      final String path = 'progress-add';
      final response =
          await _apiClient.post(path, body: progressData, token: token);
          return response;

    }on ApiException catch (e) {
      log("API Hatası (ApiException): $e");
      rethrow;
    } catch (e) {
      log("Diyet Planı Güncelleme Servis Genel Hata: $e");
      throw Exception(
          "Diyet Planı Güncellenirken beklenmedik bir hata oluştu: ${e.toString()}");
    }
  }

  Future<Map<String,dynamic>> updateProgress({
    required String token,
    required int progressId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
     

      final String path = 'progress-update/$progressId';
      final response =
          await _apiClient.put(path, body: updateData, token: token);
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

  Future<SimpleApiResponse> deleteProgress({
    required String token,
    required int progressId,
  }) async {
    try {
      final String path = 'progress-delete/$progressId';
      final response = await _apiClient.delete(path, token: token);
      return SimpleApiResponse.fromJson(response);
    } catch (e) {
      return SimpleApiResponse(
          success: false, message: 'Hedef silinemedi: ${e.toString()}');
    }
  }
}
