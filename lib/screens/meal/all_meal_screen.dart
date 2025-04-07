import 'package:flutter/material.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:collection/collection.dart';
import 'package:dietician_app/screens/meal/meal_detail_screen.dart';
 import 'package:dietician_app/core/utils/formatters.dart'; 



class AllMealsScreen extends StatelessWidget {
  final DietPlan activePlan;

  const AllMealsScreen({super.key, required this.activePlan});

   

  @override
  Widget build(BuildContext context) {
    final groupedMeals = groupBy(activePlan.meals, (Meal meal) => meal.dayNumber);
    final sortedDays = groupedMeals.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.primary, 
        title: Text(
          'Tüm Öğünler', 
          style: AppTextStyles.heading3.copyWith(color: AppColor.white),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              activePlan.title,
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.white.withOpacity(0.8)),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: AppColor.white),
        centerTitle: true,
      ),
      body: activePlan.meals.isEmpty
          ? Center( 
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Bu diyet planı için henüz öğün eklenmemiş.",
                  style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder( 
              padding: context.paddingNormal,
              itemCount: sortedDays.length,
              itemBuilder: (context, index) {
                final dayNumber = sortedDays[index];
                final mealsForDay = groupedMeals[dayNumber]!;
                mealsForDay.sort((a, b) => getMealTypeOrder(a.mealType).compareTo(getMealTypeOrder(b.mealType)));

                return _buildDayMealsCard(context, dayNumber, mealsForDay);
              },
            ),
    );
  }

  Widget _buildDayMealsCard(BuildContext context, int dayNumber, List<Meal> meals) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: context.getDynamicHeight(1.5)), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.white,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text("Gün $dayNumber", style: AppTextStyles.heading4.copyWith(color: AppColor.black)),
        backgroundColor: AppColor.grey?.withOpacity(0.1),
        collapsedBackgroundColor: AppColor.white,
        shape: Border(), 
        collapsedShape: Border(), 
        childrenPadding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
        children: meals.map((meal) => _buildMealItem(context, meal)).toList(),
      ),
    );
  }

  Widget _buildMealItem(BuildContext context, Meal meal) {
    return ListTile(
       contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0), 
       leading: Icon(getMealTypeIcon(meal.mealType), color: AppColor.secondary, size: 28),
       title: Text(
          getMealTypeName(meal.mealType),
          style: AppTextStyles.body1Medium.copyWith(color: AppColor.secondary, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          meal.description,
          style: AppTextStyles.body2Regular.copyWith(color: AppColor.black.withOpacity(0.8)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column( 
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
              Text(
                 "${meal.calories} kcal",
                 style: AppTextStyles.body1Medium.copyWith(color: AppColor.primary, fontWeight: FontWeight.w600),
              ),
               Icon(Icons.chevron_right, color: AppColor.greyLight),
           ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MealDetailScreen(meal: meal), 
            ),
          );
        },
        visualDensity: VisualDensity.compact,
    );

  }
}