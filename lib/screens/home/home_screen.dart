import 'package:collection/collection.dart';
import 'package:dietician_app/components/diet_plan/active_diet_plan.dart';
import 'package:dietician_app/components/food/home_food_preview_section.dart';
import 'package:dietician_app/components/food_log/home_daily_comparison_section.dart';
import 'package:dietician_app/components/meal/home_todays_meals_section.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/generated/asset.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/models/compare_diet_plan_model.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/models/food_model.dart';
import 'package:dietician_app/services/diet_plan/diet_plan_service.dart';
import 'package:dietician_app/services/food/food_service.dart';
import 'package:dietician_app/services/food_log/food_log_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final DietPlanService _dietPlanService = DietPlanService();
  final FoodService _foodService = FoodService();
  final FoodLogService _foodLogService = FoodLogService();

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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

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
      _dietPlanErrorMessage = null;
      _foodErrorMessage = null;
      _comparisonErrorMessage = null;
    });

    await Future.wait([
      _fetchDietPlans(),
      _fetchFoods(),
      _fetchDailyComparison(),
    ]);

    if (mounted) {}
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
      final response =
          await _dietPlanService.getDietPlan(id: clientId, token: token);

      if (!mounted) return;

      if (response.success) {
        _allDietPlans = response.data;
        _activeDietPlan = _allDietPlans
            .firstWhereOrNull((plan) => plan.status.toLowerCase() == 'active');
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
        _dietPlanErrorMessage =
            "Diyet planları yüklenirken bir hata oluştu: ${e.toString()}";
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
        _foodErrorMessage =
            "Besinler yüklenirken bir hata oluştu: ${e.toString()}";
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

  @override
  Widget build(BuildContext context) {
    List<String> errorMessages = [
      if (_dietPlanErrorMessage != null) "Diyet Planı: $_dietPlanErrorMessage",
      if (_foodErrorMessage != null) "Besinler: $_foodErrorMessage",
      if (_comparisonErrorMessage != null) "Özet: $_comparisonErrorMessage",
    ];
    String? combinedErrorMessage =
        errorMessages.isNotEmpty ? errorMessages.join('\n') : null;

    bool isInitialLoading = _isDietPlanLoading &&
        _isFoodLoading &&
        _isLoadingComparison &&
        _allDietPlans.isEmpty &&
        _allFoods.isEmpty &&
        _dailyComparisonData == null;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: _buildAnimatedAppBar(),
      body: Padding(
        padding: context.paddingNormal,
        child: RefreshIndicator(
          onRefresh: _fetchAllData,
          color: AppColor.primary,
          child: isInitialLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColor.primary))
              : combinedErrorMessage != null &&
                      _allDietPlans.isEmpty &&
                      _allFoods.isEmpty &&
                      _dailyComparisonData == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Veriler yüklenirken hata oluştu:\n$combinedErrorMessage'),
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
                        _buildSearchBar(),
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

  PreferredSizeWidget _buildAnimatedAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.primary, AppColor.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColor.white),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: AppColor.white),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppColor.white,
            radius: 18,
            child: Lottie.asset(
              AppAssets.loginAnimation,
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
      centerTitle: false,
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$_greeting İbrahim 👋",
              style: AppTextStyles.heading3.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${_currentDate.day}/${_currentDate.month}/${_currentDate.year}",
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSearchBar() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: AppColor.grey),
    child: TextFormField(
      decoration: InputDecoration(
        hintText: "Diyet planı ara...",
        prefixIcon: Icon(Icons.search, color: AppColor.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      ),
      onChanged: (value) {},
    ),
  );
}
