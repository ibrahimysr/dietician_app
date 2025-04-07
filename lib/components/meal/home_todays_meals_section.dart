import 'package:flutter/material.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/screens/meal/all_meal_screen.dart';
import 'package:dietician_app/screens/meal/meal_detail_screen.dart';
import 'package:dietician_app/core/utils/formatters.dart';

class TodaysMealsSection extends StatelessWidget {
  final DietPlan? activeDietPlan;
  final bool isLoading;
  final String? errorMessage;

  const TodaysMealsSection({
    super.key,
    required this.activeDietPlan,
    required this.isLoading,
    required this.errorMessage,
  });

  int _calculateTodaysDayNumber() {
    if (activeDietPlan == null || activeDietPlan!.startDate.isEmpty) return -1;
    try {
      final startDate = DateTime.parse(activeDietPlan!.startDate.split('T')[0]);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
      final diff = today.difference(startOnly);
      return !diff.isNegative ? diff.inDays + 1 : 0;
    } catch (_) {
      return -2;
    }
  }

  List<Meal> _getTodaysMeals() {
    final dayNumber = _calculateTodaysDayNumber();
    if (dayNumber <= 0 || activeDietPlan == null) return [];
    final meals = activeDietPlan!.meals
        .where((meal) => meal.dayNumber == dayNumber)
        .toList();
    meals.sort((a, b) => _mealTypeOrder(a.mealType).compareTo(_mealTypeOrder(b.mealType)));
    return meals;
  }

  @override
  Widget build(BuildContext context) {
    final dayNumber = _calculateTodaysDayNumber();
    final meals = _getTodaysMeals();
    final canShowAll = activeDietPlan?.meals.isNotEmpty == true;

    if (isLoading || errorMessage != null || activeDietPlan == null || dayNumber == -1) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dayNumber > 0
                  ? "Bugünün Öğünleri (Gün $dayNumber)"
                  : "Bugünün Öğünleri",
              style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
            ),
            if (canShowAll)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllMealsScreen(activePlan: activeDietPlan!),
                    ),
                  );
                },
                child: Text("Tümünü Gör", style: AppTextStyles.body1Medium.copyWith(color: AppColor.primary)),
              ),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(1.5)),

        if (dayNumber == -2)
          _buildInfoCard("Günün öğünleri getirilirken bir sorun oluştu.", Icons.error_outline)
        else if (dayNumber == 0)
          _buildInfoCard("Diyet planınız ${formatDate(activeDietPlan!.startDate)} tarihinde başlayacak.", Icons.calendar_today_outlined)
        else if (meals.isEmpty)
          _buildInfoCard("Bugün için planlanmış öğün bulunmamaktadır.", Icons.no_food_outlined)
        else
          SizedBox(
            height: context.getDynamicHeight(16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: meals.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: context.getDynamicWidth(3)),
                child: _buildMealCard(context, meals[index]),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoCard(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.grey?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColor.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.black.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, Meal meal) {
    return SizedBox(
      width: context.getDynamicWidth(45),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: AppColor.grey,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal)),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_getMealTypeIcon(meal.mealType), color: AppColor.secondary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getMealTypeName(meal.mealType),
                        style: AppTextStyles.body1Medium.copyWith(
                          color: AppColor.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    meal.description,
                    style: AppTextStyles.body2Regular.copyWith(color: AppColor.black.withOpacity(0.8)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "${meal.calories} kcal",
                      style: AppTextStyles.body1Medium.copyWith(color: AppColor.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getMealTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast': return Icons.free_breakfast_outlined;
      case 'lunch': return Icons.lunch_dining_outlined;
      case 'dinner': return Icons.dinner_dining_outlined;
      case 'snack': return Icons.fastfood_outlined;
      default: return Icons.restaurant_menu_outlined;
    }
  }

  String _getMealTypeName(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast': return 'Kahvaltı';
      case 'lunch': return 'Öğle Yemeği';
      case 'dinner': return 'Akşam Yemeği';
      case 'snack': return 'Ara Öğün';
      default: return type;
    }
  }

  int _mealTypeOrder(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast': return 1;
      case 'snack': return 2;
      case 'lunch': return 3;
      case 'dinner': return 5;
      default: return 99;
    }
  }
}
