import 'package:collection/collection.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/models/compare_diet_plan_model.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/models/food_model.dart';
import 'package:dietician_app/models/goal_model.dart';
import 'package:dietician_app/services/diet_plan/diet_plan_service.dart';
import 'package:dietician_app/services/food/food_service.dart';
import 'package:dietician_app/services/food_log/food_log_service.dart';
import 'package:dietician_app/services/goal/goal_service.dart';
import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  final DietPlanService _dietPlanService = DietPlanService();
  final FoodService _foodService = FoodService();
  final FoodLogService _foodLogService = FoodLogService();
  final GoalService _goalService = GoalService();

  bool _isDietPlanLoading = true;
  String? _dietPlanErrorMessage;
  List<DietPlan> _allDietPlans = [];
  DietPlan? _activeDietPlan;

  bool _isFoodLoading = true;
  String? _foodErrorMessage;
  List<Food> _allFoods = [];

  bool _isLoadingComparison = true;
  String? _comparisonErrorMessage;
  DietComparisonData? _dailyComparisonData;

  bool _isLoadingGoals = true;
  String? _goalErrorMessage;
  List<Goal> _goals = [];

  late DateTime _currentDate;
  late String _greeting;

  // Getter'lar
  bool get isDietPlanLoading => _isDietPlanLoading;
  String? get dietPlanErrorMessage => _dietPlanErrorMessage;
  List<DietPlan> get allDietPlans => _allDietPlans;
  DietPlan? get activeDietPlan => _activeDietPlan;

  bool get isFoodLoading => _isFoodLoading;
  String? get foodErrorMessage => _foodErrorMessage;
  List<Food> get allFoods => _allFoods;

  bool get isLoadingComparison => _isLoadingComparison;
  String? get comparisonErrorMessage => _comparisonErrorMessage;
  DietComparisonData? get dailyComparisonData => _dailyComparisonData;

  bool get isLoadingGoals => _isLoadingGoals;
  String? get goalErrorMessage => _goalErrorMessage;
  List<Goal> get goals => _goals;

  DateTime get currentDate => _currentDate;
  String get greeting => _greeting;

  HomeViewModel() {
    _setGreetingMessage();
    fetchAllData();
  }

  void _setGreetingMessage() {
    _currentDate = DateTime.now();
    final hour = _currentDate.hour;

    if (hour < 12) {
      _greeting = "Günaydın";
    } else if (hour < 18) {
      _greeting = "İyi Günler";
    } else {
      _greeting = "İyi Akşamlar";
    }
  }

  Future<void> fetchAllData() async {
    _isDietPlanLoading = true;
    _isFoodLoading = true;
    _isLoadingComparison = true;
    _isLoadingGoals = true;
    _dietPlanErrorMessage = null;
    _foodErrorMessage = null;
    _comparisonErrorMessage = null;
    _goalErrorMessage = null;
    notifyListeners();

    await Future.wait([
      fetchDietPlans(),
      _fetchFoods(),
      fetchDailyComparison(),
      fetchGoals(),
    ]);

    notifyListeners();
  }

  Future<void> fetchDietPlans() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      _isDietPlanLoading = false;
      _dietPlanErrorMessage = "Oturum bulunamadı, lütfen giriş yapın.";
      notifyListeners();
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      _isDietPlanLoading = false;
      _dietPlanErrorMessage = "Kullanıcı ID bulunamadı.";
      notifyListeners();
      return;
    }

    try {
      final response = await _dietPlanService.getDietPlan(id: clientId, token: token);
      if (response.success) {
        _allDietPlans = response.data;
        _activeDietPlan = _allDietPlans.firstWhereOrNull((plan) => plan.status.toLowerCase() == 'active');
        _isDietPlanLoading = false;
      } else {
        _dietPlanErrorMessage = response.message;
        _isDietPlanLoading = false;
      }
    } catch (e) {
      _dietPlanErrorMessage = "Diyet planları yüklenirken bir hata oluştu: ${e.toString()}";
      _isDietPlanLoading = false;
    }
    notifyListeners();
  }

  Future<void> _fetchFoods() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      _isFoodLoading = false;
      _foodErrorMessage = "Oturum bulunamadı (besinler için).";
      notifyListeners();
      return;
    }

    try {
      final response = await _foodService.getFood(token: token);
      if (response.success) {
        _allFoods = response.data;
        _isFoodLoading = false;
      } else {
        _foodErrorMessage = response.message;
        _isFoodLoading = false;
      }
    } catch (e) {
      _foodErrorMessage = "Besinler yüklenirken bir hata oluştu: ${e.toString()}";
      _isFoodLoading = false;
    }
    notifyListeners();
  }

  Future<void> fetchDailyComparison() async {
    _comparisonErrorMessage = null;

    final token = await AuthStorage.getToken();
    if (token == null) {
      _isLoadingComparison = false;
      _comparisonErrorMessage = "Oturum bulunamadı.";
      notifyListeners();
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      _isLoadingComparison = false;
      _comparisonErrorMessage = "Kullanıcı ID bulunamadı.";
      notifyListeners();
      return;
    }

    try {
      final today = DateTime.now();
      final response = await _foodLogService.getDietComparison(
        token: token,
        clientId: clientId,
        date: today,
      );

      if (response.success && response.data != null) {
        _dailyComparisonData = response.data;
      } else {
        _comparisonErrorMessage = response.message;
      }
    } catch (e) {
      _comparisonErrorMessage = "Günlük özet alınamadı: ${e.toString()}";
    } finally {
      _isLoadingComparison = false;
      notifyListeners();
    }
  }

  Future<void> fetchGoals() async {
    _goalErrorMessage = null;

    final token = await AuthStorage.getToken();
    if (token == null) {
      _isLoadingGoals = false;
      _goalErrorMessage = "Oturum bulunamadı (Hedefler).";
      notifyListeners();
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      _isLoadingGoals = false;
      _goalErrorMessage = "Kullanıcı ID bulunamadı (Hedefler).";
      notifyListeners();
      return;
    }

    try {
      final response = await _goalService.getGoals(token: token, clientId: clientId);
      if (response.success) {
        _goals = response.data;
      } else {
        _goalErrorMessage = response.message;
      }
    } catch (e) {
      _goalErrorMessage = "Hedefler alınırken hata oluştu: ${e.toString()}";
    } finally {
      _isLoadingGoals = false;
      notifyListeners();
    }
  }

  Future<void> markGoalAsCompleted(int goalId) async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      print("Tamamlama için token bulunamadı.");
      return;
    }
    try {
      print("Hedef $goalId tamamlandı olarak işaretleniyor...");
      await _goalService.updateGoal(
        token: token,
        goalId: goalId,
        updateData: {'status': 'completed'},
      );
      await fetchGoals();
    } catch (e) {
      print("Hedef tamamlandı olarak işaretlenirken hata: $e");
    }
  }

  Future<bool> updateGoalProgress(int goalId, double newValue) async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      return false;
    }

    try {
      final updateResponse = await _goalService.updateGoal(
        token: token,
        goalId: goalId,
        updateData: {'current_value': newValue},
      );

      if (updateResponse.success) {
        Goal? updatedGoal = updateResponse.data;
        bool shouldMarkCompleted = false;
        if (updatedGoal != null && updatedGoal.calculatedProgress >= 1.0 && updatedGoal.status.toLowerCase() == 'in_progress') {
          shouldMarkCompleted = true;
        } else if (updatedGoal == null) {
          final goal = _goals.firstWhere((g) => g.id == goalId);
          double tempProgress = goal.targetValue != null && goal.targetValue != 0
              ? (newValue / goal.targetValue!).clamp(0.0, 1.0)
              : (newValue >= (goal.targetValue ?? 0) ? 1.0 : 0.0);
          if (tempProgress >= 1.0 && goal.status.toLowerCase() == 'in_progress') {
            shouldMarkCompleted = true;
          }
        }

        if (shouldMarkCompleted) {
          await markGoalAsCompleted(goalId);
        }

        await fetchGoals();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Güncelleme hatası: $e");
      return false;
    }
  }
}