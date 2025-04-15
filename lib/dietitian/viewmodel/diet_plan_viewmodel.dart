import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:dietician_app/dietitian/service/diet_plan/diet_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDietPlanScreenViewModel extends ChangeNotifier {
  final DietPlanService _dietPlanService = DietPlanService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedFinishDate;

  bool _isPublic = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditMode = false;
  int? _dietPlanId;

  static final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get titleController => _titleController;
  TextEditingController get caloriesController => _caloriesController;
  TextEditingController get notesController => _notesController;
  DateTime? get selectedStartDate => _selectedStartDate;
  DateTime? get selectedFinishDate => _selectedFinishDate;
  bool get isPublic => _isPublic;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditMode => _isEditMode;

  AddDietPlanScreenViewModel({ClientDietPlan? dietPlan}) {
    if (dietPlan != null) {
      _isEditMode = true;
      _dietPlanId = dietPlan.id;
      _titleController.text = dietPlan.title;
      _caloriesController.text = dietPlan.dailyCalories.toString();
      _notesController.text = dietPlan.notes;
      _selectedStartDate =
          dietPlan.startDate.isNotEmpty ? _formatter.parse(dietPlan.startDate) : null;
      _selectedFinishDate =
          dietPlan.endDate.isNotEmpty ? _formatter.parse(dietPlan.endDate) : null;
      _isPublic = dietPlan.status == 'active';
    }
  }

  void updateDates(DateTime? startDate, DateTime? finishDate) {
    _selectedStartDate = startDate;
    _selectedFinishDate = finishDate;
    notifyListeners();
  }

  void setIsPublic(bool value) {
    _isPublic = value;
    notifyListeners();
  }

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return "Bu alan zorunludur";
    }
    return null;
  }

  String? validateRequiredNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Bu alan zorunludur";
    }
    if (int.tryParse(value) == null) {
      return "Geçerli bir sayı giriniz";
    }
    return null;
  }

  Future<bool> submitForm(int clientId) async {
    if (_isLoading) return false;

    if (_formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      return false;
    }

    final String? token;
    try {
      token = await AuthStorage.getToken();
      if (token == null) {
        throw Exception("Kimlik Bilgileri Alınamadı");
      }
    } catch (e) {
      _errorMessage = "Oturum Bilgileri Alınamadı. Lütfen Tekrar Giriş Yapın";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    String? formattedStartDate;
    String? formattedFinishDate;

    if (_selectedStartDate != null) {
      formattedStartDate = _formatter.format(_selectedStartDate!);
    }
    if (_selectedFinishDate != null) {
      formattedFinishDate = _formatter.format(_selectedFinishDate!);
    }

    Map<String, dynamic> dietPlanData = {
      "client_id": clientId,
      "title": _titleController.text,
      if (formattedStartDate != null) "start_date": formattedStartDate,
      if (formattedFinishDate != null) "end_date": formattedFinishDate,
      "daily_calories": int.tryParse(_caloriesController.text) ?? 0,
      "notes": _notesController.text,
      "status": _isPublic ? "active" : "paused",
      "is_ongoing": false,
    };

    try {
      Map<String, dynamic>? response;
      if (_isEditMode && _dietPlanId != null) {
        response = await _dietPlanService.updateDietPlan(
          token: token,
          data: dietPlanData,
          dietplanid: _dietPlanId!
        );
      } else {
        response = await _dietPlanService.addDietPlan(
          token: token,
          data: dietPlanData,
        );
      }
      _isLoading = false;
      notifyListeners();

      return response?["success"] == true;
    } catch (e) {
      _errorMessage = _isEditMode
          ? "Diyet planı güncellenirken hata oluştu: ${e.toString()}"
          : "Diyet planı eklenirken hata oluştu: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}