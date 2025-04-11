
import 'package:dietician_app/client/services/api/api_client.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart'; 

class DietPlanService {
  final ApiClient _apiClient;

  DietPlanService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<ClientDietPlanListResponse> getClientDietPlans({
    required int clientId,
    required String? token, 
  }) async {
    final String endpoint = 'clients/$clientId/diet-plans';

    try {
      final response = await _apiClient.get(endpoint, token: token);

      return ClientDietPlanListResponse.fromJson(response);
    } catch (e) {
      return ClientDietPlanListResponse(success: false, message: "Planlar alınırken bir hata oluştu: $e", data: []);
    }
  }

}