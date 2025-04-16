import 'package:flutter/material.dart';
import 'package:dietician_app/client/models/diet_plan_model.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/screens/meal/all_meal_screen.dart';
import 'package:dietician_app/client/screens/meal/meal_detail_screen.dart';
import 'package:dietician_app/client/core/utils/formatters.dart'; 

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
      if (today.isBefore(startOnly)) {
         return 0; 
      }
      final diff = today.difference(startOnly);
      return diff.inDays + 1; 
    } catch (e) {
      return -2; 
    }
  }

  List<Meal> _getTodaysMeals() {
    final dayNumber = _calculateTodaysDayNumber();
    if (dayNumber <= 0 || activeDietPlan == null || activeDietPlan!.meals.isEmpty) {
      return [];
    }
    final meals = activeDietPlan!.meals
        .where((meal) => meal.dayNumber == dayNumber)
        .toList();
    meals.sort((a, b) =>
        getMealTypeOrder(a.mealType).compareTo(getMealTypeOrder(b.mealType)));
    return meals;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || errorMessage != null || activeDietPlan == null) {
      return const SizedBox.shrink(); 
    }

    if (activeDietPlan!.meals.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bugünün Öğünleri",
            style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: context.getDynamicHeight(1.5)),
          _buildInfoCard(
            "Diyetisyeniz henüz bu plana öğün eklememiş.", 
            Icons.menu_book_outlined, 
            alignment: MainAxisAlignment.center, 
          ),
        ],
      );
    }


    final dayNumber = _calculateTodaysDayNumber();
    final meals = _getTodaysMeals();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dayNumber > 0 ? "Bugünün Öğünleri (Gün $dayNumber)" : "Bugünün Öğünleri",
              style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllMealsScreen(activePlan: activeDietPlan!),
                  ),
                );
              },
              child: Text("Tümünü Gör",
                  style: AppTextStyles.body1Medium.copyWith(color: AppColor.primary)),
            ),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(1.5)),

        if (dayNumber == -2) 
          _buildInfoCard("Günün öğünleri getirilirken bir sorun oluştu.", Icons.error_outline, alignment: MainAxisAlignment.center)
        else if (dayNumber == -1) 
           _buildInfoCard("Plan başlangıç tarihi okunamadı.", Icons.error_outline, alignment: MainAxisAlignment.center)
        else if (dayNumber == 0) 
          _buildInfoCard("Diyet planınız ${formatDate(activeDietPlan!.startDate)} tarihinde başlayacak.", Icons.calendar_today_outlined, alignment: MainAxisAlignment.center)
        else if (meals.isEmpty) 
          _buildInfoCard("Bugün için planlanmış öğün bulunmamaktadır.", Icons.no_food_outlined, alignment: MainAxisAlignment.center)
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

  Widget _buildInfoCard(String message, IconData icon, {MainAxisAlignment? alignment}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.start, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColor.secondary, size: 22), 
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
              textAlign: alignment == MainAxisAlignment.center ? TextAlign.center : TextAlign.start, 
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
          onTap: () {
            DateTime? startDate;
            try {
              startDate = DateTime.parse(activeDietPlan!.startDate.split('T')[0]);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Plan başlangıç tarihi okunamadı.")));
              return; 
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MealDetailScreen(
                        meal: meal,
                        dietPlanStartDate: startDate!,
                      )),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Row(
                  children: [
                    Icon(getMealTypeIcon(meal.mealType), color: AppColor.secondary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        getMealTypeName(meal.mealType),
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
                    meal.description.isNotEmpty ? meal.description : "Açıklama yok",
                    style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
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
                      style: AppTextStyles.body1Medium.copyWith(
                          color: AppColor.primary, 
                          fontWeight: FontWeight.w600),
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
}