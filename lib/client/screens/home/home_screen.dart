import 'dart:developer';

import 'package:dietician_app/client/components/diet_plan/active_diet_plan.dart';
import 'package:dietician_app/client/components/food/home_food_preview_section.dart';
import 'package:dietician_app/client/components/food_log/home_daily_comparison_section.dart';
import 'package:dietician_app/client/components/goal/home_goals_section.dart';
import 'package:dietician_app/client/components/goal/home_update_goal_progress_dialog.dart';
import 'package:dietician_app/client/components/meal/home_todays_meals_section.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/goal_model.dart';
import 'package:dietician_app/client/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          final bool isLoading = viewModel.isDietPlanLoading ||
              viewModel.isFoodLoading ||
              viewModel.isLoadingComparison ||
              viewModel.isLoadingGoals;

          if (isLoading && viewModel.dietitianId == null) {
            return Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(title: "Yükleniyor"),
              body: Center(
                  child: CircularProgressIndicator(color: AppColor.primary)),
            );
          }

          if (viewModel.dietitianId == null || viewModel.dietitianId == 0) {
            log("Dietitian ID kontrolü: Geçersiz ID (${viewModel.dietitianId}), hata mesajı gösteriliyor.");
            return Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(title: "Diyetisyen Bulunamadı"),
              body: Center(
                child: Padding(
                  padding: context.paddingNormal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off_outlined,
                          color: Colors.red.shade700, size: 60),
                      SizedBox(height: 16),
                      Text(
                        'Diyetisyeniniz bulunamadı veya atanmamış.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text('Tekrar Dene'),
                        onPressed: viewModel.fetchAllData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          foregroundColor: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final errorMessages = [
              if (viewModel.dietPlanErrorMessage != null)
                "Diyet Planı: ${viewModel.dietPlanErrorMessage}",
              if (viewModel.foodErrorMessage != null)
                "Besinler: ${viewModel.foodErrorMessage}",
              if (viewModel.comparisonErrorMessage != null)
                "Özet: ${viewModel.comparisonErrorMessage}",
              if (viewModel.goalErrorMessage != null)
                "Hedefler: ${viewModel.goalErrorMessage}",
            ].join('\n');
            if (errorMessages.isNotEmpty && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Bazı veriler yüklenemedi:\n$errorMessages'),
                backgroundColor: Colors.orange.shade800,
              ));
            }
          });

          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AnimatedAppBar(
              vsync: Scaffold.of(context).widget is StatefulWidget
                  ? Scaffold.of(context) as TickerProviderStateMixin
                  : _DefaultTickerProvider(),
              fadeAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: AnimationController(
                    vsync: Scaffold.of(context).widget is StatefulWidget
                        ? Scaffold.of(context) as TickerProviderStateMixin
                        : _DefaultTickerProvider(),
                    duration: const Duration(milliseconds: 800),
                  )..forward(),
                  curve: Curves.easeIn,
                ),
              ),
              greeting: viewModel.greeting,
              currentDate: viewModel.currentDate,
              onMenuPressed: () {},
              onNotificationsPressed: () {},
            ),
            body: Padding(
              padding: context.paddingNormalHorizontal,
              child: RefreshIndicator(
                onRefresh: viewModel.fetchAllData,
                color: AppColor.primary,
                child: ListView(
                  padding: context.paddingNormalVertical,
                  children: [
                    ActiveDietPlanSection(
                      isLoading: viewModel.isDietPlanLoading,
                      errorMessage: viewModel.dietPlanErrorMessage,
                      allDietPlans: viewModel.allDietPlans,
                      activeDietPlan: viewModel.activeDietPlan,
                      onRetry: viewModel.fetchDietPlans,
                    ),
                    SizedBox(height: context.getDynamicHeight(3)),
                    TodaysMealsSection(
                      activeDietPlan: viewModel.activeDietPlan,
                      isLoading: viewModel.isDietPlanLoading,
                      errorMessage: viewModel.dietPlanErrorMessage,
                    ),
                    SizedBox(height: context.getDynamicHeight(3)),
                    DailyComparisonSection(
                      isLoadingComparison: viewModel.isLoadingComparison,
                      comparisonErrorMessage: viewModel.comparisonErrorMessage,
                      dailyComparisonData: viewModel.dailyComparisonData,
                      onRetry: viewModel.fetchDailyComparison,
                    ),
                    SizedBox(height: context.getDynamicHeight(3)),
                    GoalsSection(
                      isLoadingGoals: viewModel.isLoadingGoals,
                      goalErrorMessage: viewModel.goalErrorMessage,
                      goals: viewModel.goals,
                      dietitianId: viewModel.dietitianId!,
                      onRefresh: viewModel.fetchGoals,
                      onUpdateProgress: (goal) =>
                          _showUpdateProgressDialog(context, viewModel, goal),
                    ),
                    SizedBox(height: context.getDynamicHeight(3)),
                    FoodPreviewSection(
                      isLoading: viewModel.isFoodLoading,
                      errorMessage: viewModel.foodErrorMessage,
                      allFoods: viewModel.allFoods,
                    ),
                    SizedBox(height: context.getDynamicHeight(3)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateProgressDialog(
      BuildContext context, HomeViewModel viewModel, Goal goal) {
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

            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _DefaultTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
