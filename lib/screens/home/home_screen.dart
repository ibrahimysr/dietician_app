import 'package:collection/collection.dart';
import 'package:dietician_app/components/diet_plan/active_diet_plan.dart';
import 'package:dietician_app/components/meal/home_todays_meals_section.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';

import 'package:dietician_app/services/diet_plan/diet_plan_service.dart';
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
  bool _isLoading = true;
  String? _errorMessage;
  List<DietPlan> _allDietPlans = [];
  DietPlan? _activeDietPlan;

  @override
  void initState() {
    super.initState();
    _fetchDietPlans();
  }

  Future<void> _fetchDietPlans() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      throw Exception("Oturum bulunamadı, lütfen giriş yapın.");
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      throw Exception("Kullanıcı ID bulunamadı.");
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _activeDietPlan = null;
        _allDietPlans = [];
      });

      final response =
          await _dietPlanService.getDietPlan(id: clientId, token: token);

      if (response.success) {
        _allDietPlans = response.data;
        _activeDietPlan = _allDietPlans
            .firstWhereOrNull((plan) => plan.status.toLowerCase() == 'active');
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            "Diyet planları yüklenirken bir hata oluştu: ${e.toString()}";
        _isLoading = false;
      });
    }
  }
 
   
  @override
  Widget build(BuildContext context) { 
  
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
          onRefresh: _fetchDietPlans,
          color: AppColor.primary,
          child: ListView(
            children: [
              Text("Hoşgeldin İbrahim 👋", style: AppTextStyles.heading3),
              SizedBox(height: context.getDynamicHeight(2)),
              _buildSearchBar(),
              SizedBox(height: context.getDynamicHeight(3)),
              ActiveDietPlanSection(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                allDietPlans: _allDietPlans,
                activeDietPlan: _activeDietPlan,
                onRetry: _fetchDietPlans,
              ),
             TodaysMealsSection(
  activeDietPlan: _activeDietPlan,
  isLoading: _isLoading,
  errorMessage: _errorMessage,
),

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
