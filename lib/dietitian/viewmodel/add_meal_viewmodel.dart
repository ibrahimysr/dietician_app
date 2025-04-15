import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:dietician_app/dietitian/service/meal/meal_service.dart';
import 'package:flutter/material.dart';

class AddMealScreenViewModel extends ChangeNotifier {
  final MealService _mealService = MealService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dayNumber = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _calories = TextEditingController();
  final TextEditingController _protein = TextEditingController();
  final TextEditingController _fat = TextEditingController();
  final TextEditingController _carbs = TextEditingController();

  String? _selectedMealType; 
  static const Map<String, String> _mealTypeMapping = {
    "Kahvaltı": "breakfast",
    "Öğle Yemeği": "lunch",
    "Akşam Yemeği": "dinner",
    "Ara Öğün": "snack",
  };

  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditMode = false;
  int? _dietPlanId;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get dayNumber => _dayNumber;
  TextEditingController get description => _description;
  TextEditingController get calories => _calories;
  TextEditingController get protein => _protein;
  TextEditingController get fat => _fat;
  TextEditingController get carbs => _carbs;
  String? get selectedMealType => _selectedMealType;
  List<String> get mealTypeOptions => _mealTypeMapping.keys.toList();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditMode => _isEditMode;

  AddMealScreenViewModel({ClientMeal? meal, required dietPlanId}) {
    _dietPlanId = dietPlanId;
    if (meal != null) {
      _isEditMode = true;
      dayNumber.text = meal.dayNumber.toString();
      description.text = meal.description;
      calories.text = meal.calories.toString();
      protein.text = meal.protein.toString();
      fat.text = meal.fat.toString();
      carbs.text = meal.carbs.toString();

      _selectedMealType = _mealTypeMapping.entries
          .firstWhere((entry) => entry.value == meal.mealType,
              orElse: () => _mealTypeMapping.entries.first)
          .key;
    }
  }

  void setMealType(String? newValue) {
    _selectedMealType = newValue;
    notifyListeners();
  }

  Future<bool> submitForm() async {
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

    Map<String, dynamic> dietPlanData = {
      "diet_plan_id": _dietPlanId,
      "day_number": int.tryParse(dayNumber.text) ?? 0,
      "meal_type": _mealTypeMapping[_selectedMealType] ?? "breakfast", 
      "description": description.text,
      "calories": int.tryParse(calories.text) ?? 0,
      "protein": int.tryParse(protein.text) ?? 0,
      "fat": int.tryParse(fat.text) ?? 0,
      "carbs": int.tryParse(carbs.text) ?? 0,
    };

    try {
      Map<String, dynamic>? response;
      if (_isEditMode && _dietPlanId != null) {
        response = await _mealService.updateMeal(
          token: token,
          data: dietPlanData,
          mealId: _dietPlanId!
        );
      } else {
        response = await _mealService.addMeal(
          token: token,
          data: dietPlanData,
        );
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
    _calories.dispose();
    _carbs.dispose();
    _fat.dispose();
    _description.dispose();
    _dayNumber.dispose();
    _protein.dispose();
    super.dispose();
  }
}