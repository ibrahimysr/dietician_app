
import 'package:dietician_app/models/recipes_model.dart';
import 'package:dietician_app/services/api/api_client.dart';

class RecipesService { 
 final ApiClient _apiClient; 

   RecipesService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

    Future<RecipesResponse> getRecipes({String? token}) async {
      final response = await _apiClient.get('recipes-list', token: token);
  
      return RecipesResponse.fromJson(response);
    }

 
}