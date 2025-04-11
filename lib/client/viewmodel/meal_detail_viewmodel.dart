import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/compare_diet_plan_model.dart';
import 'package:dietician_app/client/models/diet_plan_model.dart';
import 'package:dietician_app/client/models/food_log_model.dart';
import 'package:dietician_app/client/services/food_log/food_log_service.dart';
import 'package:flutter/material.dart';

class MealDetailScreenViewModel extends ChangeNotifier {
  final FoodLogService _foodLogService = FoodLogService();

  List<FoodLog> _mealLogs = [];
  bool _isLoadingLogs = true;
  String? _logErrorMessage;
  int? _clientId;
  DietComparisonData? _comparisonData;
  bool _isLoadingComparison = true;
  String? _comparisonErrorMessage;

  List<FoodLog> get mealLogs => _mealLogs;
  bool get isLoadingLogs => _isLoadingLogs;
  String? get logErrorMessage => _logErrorMessage;
  DietComparisonData? get comparisonData => _comparisonData;
  bool get isLoadingComparison => _isLoadingComparison;
  String? get comparisonErrorMessage => _comparisonErrorMessage;

  MealDetailScreenViewModel(Meal meal, DateTime dietPlanStartDate) {
    fetchAllScreenData(meal, dietPlanStartDate);
  }

  Future<void> fetchAllScreenData(Meal meal, DateTime dietPlanStartDate) async {
    await _fetchClientId();
    if (_clientId != null) {
      await Future.wait([
        fetchFoodLogs(meal, dietPlanStartDate),
        fetchComparisonData(meal, dietPlanStartDate),
      ]);
    } else {
      _isLoadingLogs = false;
      _isLoadingComparison = false;
      _logErrorMessage = "Kullanıcı kimliği alınamadı.";
      _comparisonErrorMessage = "Kullanıcı kimliği alınamadı.";
      notifyListeners();
    }
  }

  Future<void> _fetchClientId() async {
    _clientId = await AuthStorage.getId();
    notifyListeners();
  }

  Future<void> fetchFoodLogs(Meal meal, DateTime dietPlanStartDate) async {
    if (_clientId == null) return;

    _isLoadingLogs = true;
    _logErrorMessage = null;
    notifyListeners();

    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        _logErrorMessage = "Oturum bulunamadı.";
        _isLoadingLogs = false;
        notifyListeners();
        return;
      }

      final targetDate = dietPlanStartDate.add(Duration(days: meal.dayNumber - 1));
      final response = await _foodLogService.getFoodLogDate(
        token: token,
        id: _clientId!,
        date: targetDate,
      );

      if (response.success) {
        _mealLogs = response.data
            .where((log) => log.mealType.toLowerCase() == meal.mealType.toLowerCase())
            .toList();
        _mealLogs.sort((a, b) => DateTime.parse(b.loggedAt).compareTo(DateTime.parse(a.loggedAt)));
      } else {
        _logErrorMessage = response.message;
      }
    } catch (e) {
      _logErrorMessage = "Yemek kayıtları getirilirken bir hata oluştu: ${e.toString()}";
    } finally {
      _isLoadingLogs = false;
      notifyListeners();
    }
  }

  Future<void> fetchComparisonData(Meal meal, DateTime dietPlanStartDate) async {
    if (_clientId == null) return;

    _isLoadingComparison = true;
    _comparisonErrorMessage = null;
    notifyListeners();

    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bulunamadı.");

      final targetDate = dietPlanStartDate.add(Duration(days: meal.dayNumber - 1));
      final response = await _foodLogService.getDietComparison(
        token: token,
        clientId: _clientId!,
        date: targetDate,
      );

      if (response.success && response.data != null) {
        _comparisonData = response.data;
      } else {
        _comparisonErrorMessage = response.message;
      }
    } catch (e) {
      _comparisonErrorMessage = "Karşılaştırma verisi alınırken hata: ${e.toString()}";
    } finally {
      _isLoadingComparison = false;
      notifyListeners();
    }
  }

  Future<bool> addFoodLog({
    required Meal meal,
    required DateTime dietPlanStartDate,
    required String foodDescription,
    required double quantity,
    required int calories,
    double? protein,
    double? fat,
    double? carbs,
    required DateTime loggedAt,
  }) async {
    if (_clientId == null) return false;

    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bulunamadı.");

      final targetDate = dietPlanStartDate.add(Duration(days: meal.dayNumber - 1));
      final response = await _foodLogService.addFoodLog(
        token: token,
        clientId: _clientId!,
        date: targetDate,
        mealType: meal.mealType,
        foodDescription: foodDescription,
        quantity: quantity,
        calories: calories,
        protein: protein,
        fat: fat,
        carbs: carbs,
        loggedAt: loggedAt,
      );

      if (response.success && response.data != null) {
        _mealLogs.insert(0, response.data!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateFoodLog({
    required int logId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bulunamadı.");

      final response = await _foodLogService.updateFoodLog(
        token: token,
        logId: logId,
        updateData: updatedData,
      );

      if (response.success && response.data != null) {
        final index = _mealLogs.indexWhere((log) => log.id == logId);
        if (index != -1) {
          _mealLogs[index] = response.data!;
          _mealLogs.sort((a, b) => DateTime.parse(b.loggedAt).compareTo(DateTime.parse(a.loggedAt)));
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFoodLog(int logId) async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bulunamadı.");

      final response = await _foodLogService.deleteFoodLog(token: token, logId: logId);

      if (response.success) {
        _mealLogs.removeWhere((log) => log.id == logId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}