import 'package:dietician_app/client/services/api/api_client.dart';
import 'package:dietician_app/dietitian/model/dietitian_model.dart';

class DietitiansService { 
 final ApiClient _apiClient;

  DietitiansService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
   
   Future<DietitianResponse> getDietitinInformation({ String? token,int? id}) async {
    final response = await _apiClient.get('users/$id/dietitian', token: token);
     return DietitianResponse.fromJson(response); 
      
  } 

   
}