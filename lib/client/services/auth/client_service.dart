import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/client_model.dart';
import 'package:dietician_app/client/services/api/api_client.dart';


class ClientService {
  final ApiClient _apiClient;

  ClientService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<ClientResponse> addClient({
    required int userId,
    int? dietitianId,
    required String birthDate,
    required String gender,
    required double height,
    required double weight,
    required String activityLevel,
    required String goal,
    required String allergies,
    required String preferences,
    required String medicalConditions,
    String? token,
  }) async {
    final body = {
      "user_id": userId,
      "dietitian_id": dietitianId,
      "birth_date": birthDate,
      "gender": gender,
      "height": height.toString(),
      "weight": weight.toString(),
      "activity_level": activityLevel,
      "goal": goal,
      "allergies": allergies,
      "preferences": preferences,
      "medical_conditions": medicalConditions,
    };

    final response = await _apiClient.post('clients-add', body: body, token: token);

    return ClientResponse.fromJson(response);
  }

  Future<ClientResponse> getClient({required int userId, String? token}) async {
    final response = await _apiClient.get('clients-get/$userId', token: token);

    return ClientResponse.fromJson(response);
  } 
  Future<void> getUserClient({required int userId, String? token}) async {
    final response = await _apiClient.get('users/$userId/client', token: token);
     final data =  ClientResponse.fromJson(response); 
      await AuthStorage.saveId(data.data.userId);
      await AuthStorage.saveClientId(data.data.id);
  } 

  Future<ClientResponse> updateDietitian({
    required String token,
    required int clientId,
    required Map<String, dynamic> updateData,
  }) async {
   
      final String path = 'clients-update/$clientId';

      final response = await _apiClient.put(
        path,
        body: updateData, 
        token: token,
      );
      return ClientResponse.fromJson(response);
  }
}