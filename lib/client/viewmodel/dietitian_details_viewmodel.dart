import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/dietitian_model.dart';
import 'package:dietician_app/client/services/auth/client_service.dart';
import 'package:dietician_app/client/services/dietian/dietitians_servici.dart';

class DietitianDetailViewModel extends ChangeNotifier {
  final DietitiansService _dietitianService = DietitiansService();
  final ClientService _clientService = ClientService();

  late int dietitianId;

  bool _isLoading = false;
  bool _isUpdatingDietitian = false;
  SingleDietitianResponse? _dietitianResponse;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isUpdatingDietitian => _isUpdatingDietitian;
  SingleDietitianResponse? get dietitianResponse => _dietitianResponse;
  String? get errorMessage => _errorMessage;

  Future<void> init(int id) async {
    dietitianId = id;
    await fetchDietitianDetails();
  }

  Future<void> fetchDietitianDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await AuthStorage.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Oturum bulunamadı, lütfen giriş yapın.");
      }
      if (dietitianId <= 0) {
        throw Exception("Geçersiz Diyetisyen ID'si.");
      }

      _dietitianResponse = await _dietitianService.getDietitian(
        id: dietitianId,
        token: token,
      );
    } catch (e) {
      log("Error fetching dietitian details (ID: $dietitianId): $e");
      _errorMessage = "Diyetisyen detayları yüklenirken bir hata oluştu.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> selectDietitian() async {
    if (_isUpdatingDietitian) return null;

    _isUpdatingDietitian = true;
    notifyListeners();

    try {
      final token = await AuthStorage.getToken();
      final clientId = await AuthStorage.getClientId();

      if (token == null || token.isEmpty) {
        throw Exception("Oturumunuz bulunamadı. Lütfen tekrar giriş yapın.");
      }
      if (clientId == null) {
        throw Exception("Kullanıcı kimliği bulunamadı. Lütfen tekrar giriş yapın.");
      }

      final Map<String, dynamic> updateData = {
        "dietitian_id": dietitianId,
      };

      final updateResponse = await _clientService.updateDietitian(
        token: token,
        clientId: clientId,
        updateData: updateData,
      );

      if (updateResponse.success) {
        log("Danışan diyetisyeni başarıyla güncellendi!");
        return null; 
      } else {
        log('Güncelleme başarısız: ${updateResponse.message}');
        return updateResponse.message.isNotEmpty
            ? updateResponse.message
            : "Diyetisyen ataması güncellenemedi.";
      }
    } catch (e) {
      log("Diyetisyen seçme hatası: $e");
      return "İşlem sırasında bir hata oluştu. Lütfen tekrar deneyin.";
    } finally {
      _isUpdatingDietitian = false;
      notifyListeners();
    }
  }
}
