import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/user_model.dart';
import 'package:dietician_app/client/services/api/api_client.dart';


class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final body = {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    };

    final response = await _apiClient.post('auth/register', body: body);

    return AuthResponse.fromJson(response);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final body = {
      "email": email,
      "password": password,
    };

    final response = await _apiClient.post('auth/login', body: body); 
          
         
    final authResponse = AuthResponse.fromJson(response);

    await AuthStorage.saveId(authResponse.data.user.id);

      return authResponse;
  }
}