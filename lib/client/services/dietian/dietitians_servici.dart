import 'package:dietician_app/client/models/dietitian_model.dart';
import 'package:dietician_app/client/services/api/api_client.dart';

class DietitiansService { 
 final ApiClient _apiClient;

  DietitiansService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
   
   Future<DietitianResponse> getDietitiansList({ String? token}) async {
    final response = await _apiClient.get('dietitians-list', token: token);
     return DietitianResponse.fromJson(response); 
      
  } 

     Future<SingleDietitianResponse> getDietitian({required int id,  String? token}) async {
    final response = await _apiClient.get('dietitians-get/$id', token: token);
     return SingleDietitianResponse.fromJson(response); 
      
  }
}