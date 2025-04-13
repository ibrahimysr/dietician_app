import 'package:dietician_app/client/components/diet_plan/active_diet_plan.dart';
import 'package:dietician_app/client/components/food/home_food_preview_section.dart';
import 'package:dietician_app/client/components/food_log/home_daily_comparison_section.dart';
import 'package:dietician_app/client/components/goal/home_goals_section.dart';
import 'package:dietician_app/client/components/goal/home_update_goal_progress_dialog.dart';
import 'package:dietician_app/client/components/meal/home_todays_meals_section.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/components/shared/search_bar.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/goal_model.dart';
import 'package:dietician_app/client/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          final isInitialLoading = viewModel.isDietPlanLoading &&
              viewModel.isFoodLoading &&
              viewModel.isLoadingComparison &&
              viewModel.isLoadingGoals &&
              viewModel.allDietPlans.isEmpty &&
              viewModel.allFoods.isEmpty &&
              viewModel.dailyComparisonData == null &&
              viewModel.goals.isEmpty;

          final errorMessages = [
            if (viewModel.dietPlanErrorMessage != null) "Diyet Planı: ${viewModel.dietPlanErrorMessage}",
            if (viewModel.foodErrorMessage != null) "Besinler: ${viewModel.foodErrorMessage}",
            if (viewModel.comparisonErrorMessage != null) "Özet: ${viewModel.comparisonErrorMessage}",
            if (viewModel.goalErrorMessage != null) "Hedefler: ${viewModel.goalErrorMessage}",
          ];
          final combinedErrorMessage = errorMessages.isNotEmpty ? errorMessages.join('\n') : null;

          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AnimatedAppBar(
              fadeAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: AnimationController(
                    vsync: Navigator.of(context),
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
              padding: context.paddingNormal,
              child: RefreshIndicator(
                onRefresh: viewModel.fetchAllData,
                color: AppColor.primary,
                child: isInitialLoading
                    ? Center(child: CircularProgressIndicator(color: AppColor.primary))
                    : combinedErrorMessage != null &&
                            viewModel.allDietPlans.isEmpty &&
                            viewModel.allFoods.isEmpty &&
                            viewModel.dailyComparisonData == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Veriler yüklenirken hata oluştu:\n$combinedErrorMessage'),
                                ElevatedButton(
                                  onPressed: viewModel.fetchAllData,
                                  child: Text('Tekrar Dene'),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            children: [
                              SizedBox(height: context.getDynamicHeight(2)),
                              buildSearchBar(),
                              SizedBox(height: context.getDynamicHeight(3)),
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
                                dietitianId: viewModel.allDietPlans.isNotEmpty ? viewModel.allDietPlans.first.dietitianId : 0,
                                onRefresh: viewModel.fetchGoals,
                                onUpdateProgress: (goal) => _showUpdateProgressDialog(context, viewModel, goal),
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

  void _showUpdateProgressDialog(BuildContext context, HomeViewModel viewModel, Goal goal) {
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