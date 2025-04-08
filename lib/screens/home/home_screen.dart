import 'package:collection/collection.dart';
import 'package:dietician_app/components/diet_plan/active_diet_plan.dart';
import 'package:dietician_app/components/food/home_food_preview_section.dart';
import 'package:dietician_app/components/food_log/home_daily_comparison_section.dart';
import 'package:dietician_app/components/goal/home_goals_section.dart';
import 'package:dietician_app/components/goal/home_update_goal_progress_dialog.dart';
import 'package:dietician_app/components/meal/home_todays_meals_section.dart';
import 'package:dietician_app/components/shared/custom_app_bar.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/theme/color.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late DateTime _currentDate;
  late String _greeting;

  bool _isLoadingGoals = true;
  String? _goalErrorMessage;
  List<Goal> _goals = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _setGreetingMessage();

    _fetchAllData().then((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
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

  Future<void> _fetchAllData() async {
    setState(() {
      _isDietPlanLoading = true;
      _isFoodLoading = true;
      _isLoadingComparison = true;
      _isLoadingGoals = true;
      _dietPlanErrorMessage = null;
      _foodErrorMessage = null;
      _comparisonErrorMessage = null;
      _goalErrorMessage = null;
    });

    await Future.wait([
      _fetchDietPlans(),
      _fetchFoods(),
      _fetchDailyComparison(),
      _fetchGoals(),
    ]);

    if (mounted) {}
  }

  Future<void> _fetchGoals() async {
    setState(() {
      _goalErrorMessage = null;
    });

    final token = await AuthStorage.getToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          _isLoadingGoals = false;
          _goalErrorMessage = "Oturum bulunamadı (Hedefler).";
        });
      }
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      if (mounted) {
        setState(() {
          _isLoadingGoals = false;
          _goalErrorMessage = "Kullanıcı ID bulunamadı (Hedefler).";
        });
      }
      return;
    }

    try {
      final response = await _goalService.getGoals(token: token, clientId: clientId);
      if (!mounted) return;
      if (response.success) {
        _goals = response.data;
      } else {
        _goalErrorMessage = response.message;
      }
    } catch (e) {
      if (!mounted) return;
      _goalErrorMessage = "Hedefler alınırken hata oluştu: ${e.toString()}";
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingGoals = false;
        });
      }
    }
  }

  Future<void> _fetchDietPlans() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      setState(() {
        _isDietPlanLoading = false;
        _dietPlanErrorMessage = "Oturum bulunamadı, lütfen giriş yapın.";
      });
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      setState(() {
        _isDietPlanLoading = false;
        _dietPlanErrorMessage = "Kullanıcı ID bulunamadı.";
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isDietPlanLoading = true;
      _dietPlanErrorMessage = null;
    });

    try {
      final response = await _dietPlanService.getDietPlan(id: clientId, token: token);

      if (!mounted) return;

      if (response.success) {
        _allDietPlans = response.data;
        _activeDietPlan = _allDietPlans.firstWhereOrNull((plan) => plan.status.toLowerCase() == 'active');
        setState(() {
          _isDietPlanLoading = false;
        });
      } else {
        setState(() {
          _dietPlanErrorMessage = response.message;
          _isDietPlanLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _dietPlanErrorMessage = "Diyet planları yüklenirken bir hata oluştu: ${e.toString()}";
        _isDietPlanLoading = false;
      });
    }
  }

  Future<void> _fetchFoods() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      setState(() {
        _isFoodLoading = false;
        _foodErrorMessage = "Oturum bulunamadı (besinler için).";
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isFoodLoading = true;
      _foodErrorMessage = null;
    });

    try {
      final response = await _foodService.getFood(token: token);
      if (!mounted) return;

      if (response.success) {
        setState(() {
          _allFoods = response.data;
          _isFoodLoading = false;
        });
      } else {
        setState(() {
          _foodErrorMessage = response.message;
          _isFoodLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _foodErrorMessage = "Besinler yüklenirken bir hata oluştu: ${e.toString()}";
        _isFoodLoading = false;
      });
    }
  }

  Future<void> _fetchDailyComparison() async {
    setState(() {
      _comparisonErrorMessage = null;
    });

    final token = await AuthStorage.getToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          _isLoadingComparison = false;
          _comparisonErrorMessage = "Oturum bulunamadı.";
        });
      }
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      if (mounted) {
        setState(() {
          _isLoadingComparison = false;
          _comparisonErrorMessage = "Kullanıcı ID bulunamadı.";
        });
      }
      return;
    }

    try {
      final today = DateTime.now();
      final response = await _foodLogService.getDietComparison(
        token: token,
        clientId: clientId,
        date: today,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        _dailyComparisonData = response.data;
      } else {
        _comparisonErrorMessage = response.message;
      }
    } catch (e) {
      if (!mounted) return;
      _comparisonErrorMessage = "Günlük özet alınamadı: ${e.toString()}";
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingComparison = false;
        });
      }
    }
  }

  Future<void> _markGoalAsCompleted(int goalId) async {
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
      print("Hedef $goalId durumu güncellendi (veya API çağrısı yapıldı).");
    } catch (e) {
      print("Hedef tamamlandı olarak işaretlenirken hata: $e");
    }
  }

  void _showUpdateProgressDialog(Goal goal) {
    showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return UpdateGoalProgressDialog(
          goal: goal,
          onSave: (newValue) async {
            Navigator.pop(dialogContext);

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => Center(child: CircularProgressIndicator()),
            );

            final token = await AuthStorage.getToken();
            if (token == null) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Oturum bulunamadı"), backgroundColor: Colors.red),
              );
              return;
            }

            GoalResponse updateResponse;
            try {
              updateResponse = await _goalService.updateGoal(
                token: token,
                goalId: goal.id,
                updateData: {'current_value': newValue},
              );
              Navigator.pop(context);
              if (!mounted) return;

              if (updateResponse.success) {
                Goal? updatedGoal = updateResponse.data;
                bool shouldMarkCompleted = false;
                if (updatedGoal != null && updatedGoal.calculatedProgress >= 1.0 && updatedGoal.status.toLowerCase() == 'in_progress') {
                  shouldMarkCompleted = true;
                } else if (updatedGoal == null) {
                  double tempProgress = goal.targetValue != null && goal.targetValue != 0
                      ? (newValue / goal.targetValue!).clamp(0.0, 1.0)
                      : (newValue >= (goal.targetValue ?? 0) ? 1.0 : 0.0);
                  if (tempProgress >= 1.0 && goal.status.toLowerCase() == 'in_progress') {
                    shouldMarkCompleted = true;
                  }
                }

                if (shouldMarkCompleted) {
                  await _markGoalAsCompleted(goal.id);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("İlerleme güncellendi."), backgroundColor: Colors.green),
                );
                await _fetchGoals();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(updateResponse.message), backgroundColor: Colors.red),
                );
              }
            } catch (e) {
              Navigator.pop(context);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Güncelleme hatası: $e"), backgroundColor: Colors.red),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> errorMessages = [
      if (_dietPlanErrorMessage != null) "Diyet Planı: $_dietPlanErrorMessage",
      if (_foodErrorMessage != null) "Besinler: $_foodErrorMessage",
      if (_comparisonErrorMessage != null) "Özet: $_comparisonErrorMessage",
      if (_goalErrorMessage != null) "Hedefler: $_goalErrorMessage",
    ];
    String? combinedErrorMessage = errorMessages.isNotEmpty ? errorMessages.join('\n') : null;

    bool isInitialLoading = _isDietPlanLoading &&
        _isFoodLoading &&
        _isLoadingComparison &&
        _isLoadingGoals &&
        _allDietPlans.isEmpty &&
        _allFoods.isEmpty &&
        _dailyComparisonData == null &&
        _goals.isEmpty;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AnimatedAppBar(
        fadeAnimation: _fadeAnimation,
        greeting: _greeting,
        currentDate: _currentDate,
        onMenuPressed: () {},
        onNotificationsPressed: () {},
      ),
      body: Padding(
        padding: context.paddingNormal,
        child: RefreshIndicator(
          onRefresh: _fetchAllData,
          color: AppColor.primary,
          child: isInitialLoading
              ? Center(child: CircularProgressIndicator(color: AppColor.primary))
              : combinedErrorMessage != null &&
                      _allDietPlans.isEmpty &&
                      _allFoods.isEmpty &&
                      _dailyComparisonData == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Veriler yüklenirken hata oluştu:\n$combinedErrorMessage'),
                          ElevatedButton(
                            onPressed: _fetchAllData,
                            child: Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        SizedBox(height: context.getDynamicHeight(2)),
                        SearchBar(onChanged: (value) {}),
                        SizedBox(height: context.getDynamicHeight(3)),
                        ActiveDietPlanSection(
                          isLoading: _isDietPlanLoading,
                          errorMessage: _dietPlanErrorMessage,
                          allDietPlans: _allDietPlans,
                          activeDietPlan: _activeDietPlan,
                          onRetry: _fetchDietPlans,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                        TodaysMealsSection(
                          activeDietPlan: _activeDietPlan,
                          isLoading: _isDietPlanLoading,
                          errorMessage: _dietPlanErrorMessage,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                        DailyComparisonSection(
                          isLoadingComparison: _isLoadingComparison,
                          comparisonErrorMessage: _comparisonErrorMessage,
                          dailyComparisonData: _dailyComparisonData,
                          onRetry: _fetchDailyComparison,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                        GoalsSection(
                          isLoadingGoals: _isLoadingGoals,
                          goalErrorMessage: _goalErrorMessage,
                          goals: _goals,
                          dietitianId: _allDietPlans.isNotEmpty ? _allDietPlans.first.dietitianId : 0,
                          onRefresh: _fetchGoals,
                          onUpdateProgress: _showUpdateProgressDialog,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                        FoodPreviewSection(
                          isLoading: _isFoodLoading,
                          errorMessage: _foodErrorMessage,
                          allFoods: _allFoods,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                      ],
                    ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}