import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:dietician_app/client/services/progress/progress_service.dart';

import 'package:flutter/material.dart';

class AddProgressViewmodel extends ChangeNotifier {
  final ProgressService _progressService = ProgressService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _waist = TextEditingController();
  final TextEditingController _arm = TextEditingController();
  final TextEditingController _chest = TextEditingController(); 
    final TextEditingController _hip = TextEditingController();
  final TextEditingController _bodyFatPercentage = TextEditingController();

 
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditMode = false;
  int? _dietPlanId;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get date => _date;
  TextEditingController get notes => _notes;
  TextEditingController get weight => _weight;
  TextEditingController get waist => _waist;
  TextEditingController get arm => _arm;
  TextEditingController get chest => _chest;
   TextEditingController get hip => _hip;
    TextEditingController get bodyFatPercentage => _bodyFatPercentage;
  

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditMode => _isEditMode;

  AddProgressViewmodel({Progress? progress}) {
    if (progress != null) {
      _isEditMode = true;
      date.text = progress.date.toString();
      notes.text = progress.notes!;
      weight.text = progress.weight.toString();
      waist.text = progress.waist.toString();
      arm.text = progress.arm.toString();
      chest.text = progress.chest.toString();
    }
  }

  Future<bool?> submitForm() async {
    if (_isLoading) return false;

    if (_formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      return false;
    }

    final String? token;
    final int? clientId;
    try {
      token = await AuthStorage.getToken();
      clientId = await AuthStorage.getClientId();

      if (token == null) {
        throw Exception("Kimlik Bilgileri Alınamadı");
      }
    } catch (e) {
      _errorMessage = "Oturum Bilgileri Alınamadı. Lütfen Tekrar Giriş Yapın";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    Map<String, dynamic> progressData = {
    "client_id":clientId,
    "date": _date.text,
    "weight": _weight.text,
    "waist": _waist.text,
    "arm": _arm.text,
    "chest": _chest.text,
    "hip": _hip.text,
    "body_fat_percentage": _bodyFatPercentage.text,
    "notes": _notes.text
    };

    try {
   Map<String,dynamic>? response;
      if (_isEditMode && _dietPlanId != null) {
        // response = await _progressService.updateProgress(
        //   token: token,
        //   progressId: 
        
        // );
      } else {
        response = await _progressService.addProgress(
          token: token,
          progressData:progressData ,
        ) ;
      }
      _isLoading = false;
      notifyListeners();

      return response?["success"] == true;
    } catch (e) {
      _errorMessage = _isEditMode
          ? "Öğün planı güncellenirken hata oluştu: ${e.toString()}"
          : "Öğün planı eklenirken hata oluştu: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _weight.dispose();
    _chest.dispose();
    _arm.dispose();
    _notes.dispose();
    _date.dispose();
    _waist.dispose();
    super.dispose();
  }
}