import 'dart:developer';

import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/dietitian/model/dietitian_model.dart';
import 'package:dietician_app/dietitian/service/dietitian/dietitian_service.dart';
import 'package:flutter/material.dart';

class DietitianProvider extends ChangeNotifier {
  final DietitiansService _dietitiansService = DietitiansService();

  bool _isLoading = true;
  DietitianData? _dietitianData;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  DietitianData? get dietitianData => _dietitianData;
  String? get errorMessage => _errorMessage;

  DietitianProvider() {
    fetchDietitianInfo();
  }

  Future<void> fetchDietitianInfo() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? token;
    int? userId;

    try {
      token = await AuthStorage.getToken();
      userId = await AuthStorage.getId();

      if (token == null || userId == null) {
        throw Exception("Kimlik bilgileri bulunamadı. Lütfen tekrar giriş yapın.");
      }

      final response = await _dietitiansService.getDietitinInformation(
        id: userId,
        token: token,
      );

      if (response.success && response.data != null) {
        if (response.data is DietitianData) {
          _dietitianData = response.data;
          _isLoading = false;
        } else {
          throw Exception(
              "Sunucudan beklenmeyen veri formatı alındı. Alınan tip: ${response.data.runtimeType}");
        }
      } else {
        throw Exception(response.message.isNotEmpty
            ? response.message
            : "Diyetisyen bilgileri alınamadı.");
      }
    } catch (e) {
      log("Diyetisyen bilgisi alınırken hata: $e");
      _errorMessage = "Bir hata oluştu: ${e.toString()}";
      _isLoading = false;
    }
    notifyListeners();
  }
}