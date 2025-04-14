import 'dart:convert';
import 'dart:developer';

import 'package:dietician_app/client/services/api/api_client.dart';
import 'package:image_picker/image_picker.dart';

class DietitiansRecipeService { 
 final ApiClient _apiClient;

  DietitiansRecipeService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
   
   Future<Map<String, dynamic>> addRecipe({
    required String token,
    required Map<String, dynamic> recipeData,
    XFile? photo,
  }) async {
    const String endpoint = 'recipes-add';
    log("Tarif Ekleme Servisi Çağrıldı: Endpoint: $endpoint");
    log("Gönderilecek Ham Veri: $recipeData");
    if (photo != null) {
      log("Seçilen Fotoğraf: ${photo.name}");
    }

    final Map<String, String> fields = {};
    recipeData.forEach((key, value) {
      if (key == 'ingredients' && value is List) {
        fields[key] = jsonEncode(value);
        log("Alan Hazırlandı (JSON String): '$key': ${fields[key]}");
      } else if (key == 'is_public' && value is bool) {
        fields[key] = value ? '1' : '0';
        log("Alan Hazırlandı (Boolean -> String 0/1): '$key': ${fields[key]}");
      }
       else if (value != null) {
        fields[key] = value.toString();
        log("Alan Hazırlandı: '$key': ${fields[key]}");
      }
    });

    log("API'ye Gönderilecek Son Alanlar (fields): $fields");

    try {
      final response = await _apiClient.postMultipart(
        endpoint,
        fields: fields,
        token: token,
        file: photo,
        fileField: 'photo',
      );
      log("API Yanıtı Alındı: $response");
      return response;
    } on ApiException catch (e) {
      log("API Hatası (ApiException): $e");
      rethrow;
    } catch (e) {
      log("Tarif Ekleme Servis Genel Hata: $e");
      throw Exception("Tarif eklenirken beklenmedik bir hata oluştu: ${e.toString()}");
    }
  } 

  
  Future<Map<String, dynamic>> updateRecipe({
    required String token,
    required int recipeId,
    required Map<String, dynamic> recipeData,
    XFile? photo,
    bool isPhotoRemoved = false, 
  }) async {
    final String endpoint = 'recipes-update/$recipeId';
    log("Tarif Güncelleme Servisi Çağrıldı: Endpoint: $endpoint");
    log("Gönderilecek Ham Veri: $recipeData");
    if (photo != null) log("Yeni Fotoğraf: ${photo.name}");
    if (isPhotoRemoved) log("Mevcut fotoğraf kaldırılacak.");

    final Map<String, String> fields = {};
    recipeData.forEach((key, value) {
       if (key == 'user_id') return;

       if (key == 'ingredients' && value is List) {
         fields[key] = jsonEncode(value);
       } else if (key == 'is_public' && value is bool) {
         fields[key] = value ? '1' : '0';
       } else if (value != null) {
         fields[key] = value.toString();
       }
    });

   
     fields['_method'] = 'PUT'; 

  
     if (isPhotoRemoved) {
        fields['remove_photo'] = '1'; 
     }


    log("API'ye Gönderilecek Son Alanlar (fields): $fields");

    try {
     
      final response = await _apiClient.postMultipart(
        endpoint, 
        fields: fields,
        token: token,
        file: photo, 
        fileField: 'photo',
      );
      log("API Güncelleme Yanıtı Alındı: $response");
      return response;
    } on ApiException catch (e) {
      log("API Güncelleme Hatası (ApiException): $e");
      rethrow;
    } catch (e) {
      log("Tarif Güncelleme Servis Genel Hata: $e");
      throw Exception("Tarif güncellenirken beklenmedik bir hata oluştu: ${e.toString()}");
    }
  }


  Future<Map<String, dynamic>> deleteRecipe({
    required String token,
    required int recipeId,
  }) async {
    final String endpoint = 'recipes-delete/$recipeId';
    log("Tarif Silme Servisi Çağrıldı: Endpoint: $endpoint");

    try {
      final response = await _apiClient.delete(endpoint, token: token);
      log("API Silme Yanıtı Alındı: $response");
  
      return response; 
    } on ApiException catch (e) {
      log("API Silme Hatası (ApiException): $e");
      rethrow;
    } catch (e) {
      log("Tarif Silme Servis Genel Hata: $e");
      throw Exception("Tarif silinirken beklenmedik bir hata oluştu: ${e.toString()}");
    }
  }
}
