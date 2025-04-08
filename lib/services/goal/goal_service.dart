import 'package:intl/intl.dart';
import 'package:dietician_app/models/goal_model.dart';
import 'package:dietician_app/services/api/api_client.dart';
import 'package:dietician_app/models/simple_api_response.dart';

class GoalService {
  final ApiClient _apiClient;

  GoalService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<GoalListResponse> getGoals({
    required String token,
    required int clientId,
  }) async {
    try {
      final String path = 'clients/$clientId/goals';
      final response = await _apiClient.get(path, token: token);
      return GoalListResponse.fromJson(response);
    } catch (e) {
      return GoalListResponse(
          success: false,
          message: 'Hedefler alınamadı: ${e.toString()}',
          data: []);
    }
  }

  Future<GoalResponse> addGoal({
    required String token,
    required Map<String, dynamic> goalData,
  }) async {
    try {
      if (goalData['start_date'] is DateTime) {
        goalData['start_date'] =
            DateFormat('yyyy-MM-dd').format(goalData['start_date']);
      }
      if (goalData['target_date'] is DateTime) {
        goalData['target_date'] =
            DateFormat('yyyy-MM-dd').format(goalData['target_date']);
      }

      final String path = 'goals-add';
      final response =
          await _apiClient.post(path, body: goalData, token: token);
      return GoalResponse.fromJson(response);
    } catch (e) {
      return GoalResponse(
          success: false,
          message: 'Hedef eklenemedi: ${e.toString()}',
          data: null);
    }
  }

  Future<GoalResponse> updateGoal({
    required String token,
    required int goalId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      if (updateData.containsKey('start_date') &&
          updateData['start_date'] is DateTime) {
        updateData['start_date'] =
            DateFormat('yyyy-MM-dd').format(updateData['start_date']);
      }
      if (updateData.containsKey('target_date') &&
          updateData['target_date'] is DateTime) {
        updateData['target_date'] =
            DateFormat('yyyy-MM-dd').format(updateData['target_date']);
      }

      final String path = 'goals-update/$goalId';
      final response =
          await _apiClient.put(path, body: updateData, token: token);
      return GoalResponse.fromJson(response);
    } catch (e) {
      return GoalResponse(
          success: false,
          message: 'Hedef güncellenemedi: ${e.toString()}',
          data: null);
    }
  }

  Future<SimpleApiResponse> deleteGoal({
    required String token,
    required int goalId,
  }) async {
    try {
      final String path = 'goals-delete/$goalId';
      final response = await _apiClient.delete(path, token: token);
      return SimpleApiResponse.fromJson(response);
    } catch (e) {
      return SimpleApiResponse(
          success: false, message: 'Hedef silinemedi: ${e.toString()}');
    }
  }
}
