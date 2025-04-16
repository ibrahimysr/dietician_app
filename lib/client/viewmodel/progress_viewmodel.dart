import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:dietician_app/client/services/progress/progress_service.dart';
import 'package:flutter/material.dart';

class ProgressViewmodel extends ChangeNotifier {
  final ProgressService _progressService = ProgressService();

  bool _isProgressLoading = true;
  String? _isProgressErrorMessage;
  List<Progress> _allProgres = [];

  bool get isProgressLoading => _isProgressLoading;
  String? get isProgressErrorMessage => _isProgressErrorMessage;
  List<Progress> get allProgress => _allProgres;



  ProgressViewmodel() { 
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    _isProgressLoading = true;
    _isProgressErrorMessage = null;
    notifyListeners();
    await Future.wait([fetchProgress()]);
    notifyListeners();
  }

  Future<void> fetchProgress() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      _isProgressLoading = false;
      _isProgressErrorMessage = "Oturum Bulunamadı, lütfen giriş yapın.";
      notifyListeners();
      return;
    }
    final int? clientId = await AuthStorage.getClientId();

    if (clientId == null && clientId == 0) {
      _isProgressLoading = false;
      _isProgressErrorMessage = "Kullanıcı ID bulunamadı";
      notifyListeners();
      return;
    }
    try {
      final response =
          await _progressService.getProgress(token: token, clientId: clientId!);
      if (response.success) {
        _allProgres = response.data;
        _isProgressLoading = false;
      } else {
        _isProgressErrorMessage = response.message;
        _isProgressLoading = false;
      }
    } catch (e) {
      _isProgressErrorMessage =
          "İlerlemeler yüklenirken bir hata oluştu : ${e.toString()}";
      _isProgressLoading = false;
    }
    notifyListeners();
  }
}
