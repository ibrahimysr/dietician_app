
import 'package:dietician_app/models/food_model.dart';
import 'package:dietician_app/services/api/api_client.dart';

class FoodService { 
 final ApiClient _apiClient; 

   FoodService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

    Future<FoodListResponse> getFood({String? token}) async {
      final response = await _apiClient.get('foods-list', token: token);
  
      return FoodListResponse.fromJson(response);
    }

 
}