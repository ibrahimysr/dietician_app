import 'package:collection/collection.dart';
import 'package:dietician_app/components/diet_plan/active_diet_plan.dart';
import 'package:dietician_app/components/food/home_food_preview_section.dart';
import 'package:dietician_app/components/meal/home_todays_meals_section.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/models/food_model.dart';
import 'package:dietician_app/services/diet_plan/diet_plan_service.dart';
import 'package:dietician_app/services/food/food_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/generated/asset.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/diet_plan_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DietPlanService _dietPlanService = DietPlanService();
  final FoodService _foodService = FoodService();

  bool _isDietPlanLoading = true;
  String? _dietPlanErrorMessage;
  List<DietPlan> _allDietPlans = [];
  DietPlan? _activeDietPlan;

  bool _isFoodLoading = true;
  String? _foodErrorMessage;
  List<Food> _allFoods = [];

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    await Future.wait([
      _fetchDietPlans(),
      _fetchFoods(),
    ]);
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

  bool get _isLoading => _isDietPlanLoading || _isFoodLoading;

  @override
  Widget build(BuildContext context) {
    String? errorMessage = _dietPlanErrorMessage ?? _foodErrorMessage;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColor.primary),
          onPressed: () {},
        ),
        actions: [
          SizedBox(
            width: 50,
            height: 50,
            child: Lottie.asset(AppAssets.loginAnimation),
          )
        ],
        backgroundColor: AppColor.white,
        title: Text("Ana Sayfa", style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: Padding(
        padding: context.paddingNormal,
        child: RefreshIndicator(
          onRefresh: _fetchAllData,
          color: AppColor.primary,
          child: _isLoading && _allDietPlans.isEmpty && _allFoods.isEmpty
              ? Center(
                  child: CircularProgressIndicator(color: AppColor.primary))
              : errorMessage != null &&
                      _allDietPlans.isEmpty &&
                      _allFoods.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Hata: $errorMessage'),
                          ElevatedButton(
                            onPressed: _fetchAllData,
                            child: Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        Text("Hoşgeldin İbrahim 👋",
                            style: AppTextStyles.heading3),
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
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        ),
        onChanged: (value) {},
      ),
    );
  }
}
