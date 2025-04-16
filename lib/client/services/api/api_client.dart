import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../base/base_service.dart';

class ApiClient {
  final http.Client _client;
  static const String baseUrl = BaseService.baseUrl;
  
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  Map<String, String> _getAuthHeaders(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };
  
  Uri _buildUrl(String path) {
    return Uri.parse('$baseUrl/$path');
  }
  
  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    try {
      final response = await _client.get(
        _buildUrl(path),
        headers: token != null ? _getAuthHeaders(token) : _headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('GET isteği sırasında hata: $e');
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }
  
  Future<Map<String, dynamic>> post(
    String path, 
    {Map<String, dynamic>? body, String? token}
  ) async {
    try {
      final response = await _client.post(
        _buildUrl(path),
        headers: token != null ? _getAuthHeaders(token) : _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('POST isteği sırasında hata: $e');
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }
  
  Future<Map<String, dynamic>> put(
    String path, 
    {Map<String, dynamic>? body, String? token}
  ) async {
    try {
      final response = await _client.put(
        _buildUrl(path),
        headers: token != null ? _getAuthHeaders(token) : _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('PUT isteği sırasında hata: $e');
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }
  
  Future<Map<String, dynamic>> delete(String path, {String? token}) async {
    try {
      final response = await _client.delete(
        _buildUrl(path),
        headers: token != null ? _getAuthHeaders(token) : _headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('DELETE isteği sırasında hata: $e');
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }
   Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    XFile? file, 
    String fileField = 'photo', 
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', url);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json'; 

    request.fields.addAll(fields);

    if (file != null) {
      final fileBytes = await file.readAsBytes();
      final httpImage = http.MultipartFile.fromBytes(
        fileField, 
        fileBytes,
        filename: file.name,
        contentType: MediaType.parse(file.mimeType ?? 'image/jpeg'), 
      );
      request.files.add(httpImage);
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
      
        Map<String, dynamic> errorData = {'message': 'Bilinmeyen bir hata oluştu.'};
        try {
           errorData = jsonDecode(response.body) as Map<String, dynamic>;
        } catch(e) {
          errorData['message'] = response.body;
        }
        throw ApiException(
            statusCode: response.statusCode,
            message: errorData['message'] ?? 'Sunucu hatası',
            errors: errorData['data'] 
            );
      }
    } catch (e) {
      print('API Request Exception: $e');
      throw Exception('İstek gönderilirken bir hata oluştu: $e');
    }
  }
  
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      log('API Hatası: ${response.statusCode} - ${response.body}');
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'API isteği başarısız oldu');
    }
  }
  
  void dispose() {
    _client.close();
  }
} 

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic errors; 
  ApiException({this.statusCode, required this.message, this.errors});

  @override
  String toString() {
    String errorDetails = errors != null ? '\nDetaylar: $errors' : '';
    return 'ApiException [StatusCode: $statusCode]: $message$errorDetails';
  }
}