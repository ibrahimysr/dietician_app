import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/services/api/api_client.dart';

class DietPlanService { 
 final ApiClient _apiClient;

  DietPlanService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
   


     Future<DietPlanListResponse> getDietPlan({required int id,  String? token}) async {
    final response = await _apiClient.get('clients/$id/diet-plans', token: token);
     return DietPlanListResponse.fromJson(response); 
      
  }
}