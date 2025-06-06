import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/models/diet_plan_model.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:collection/collection.dart';
import 'package:dietician_app/client/screens/meal/meal_detail_screen.dart';
 import 'package:dietician_app/client/core/utils/formatters.dart'; 



class AllMealsScreen extends StatelessWidget {
  final DietPlan activePlan;

  const AllMealsScreen({super.key, required this.activePlan});

   

  @override
  Widget build(BuildContext context) {
    final groupedMeals = groupBy(activePlan.meals, (Meal meal) => meal.dayNumber);
    final sortedDays = groupedMeals.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: "Tüm Öğünler",),
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
    clipBehavior: Clip.antiAlias,
    child: Container(
      color: AppColor.grey,
      child: ExpansionTile(
        title: Text("Gün $dayNumber", style: AppTextStyles.heading4.copyWith(color: AppColor.black)),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        shape: Border(),
        collapsedShape: Border(),
        childrenPadding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
        children: meals.map((meal) => _buildMealItem(context, meal)).toList(),
      ),
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
          style: AppTextStyles.body2Regular.copyWith(color: AppColor.black.withValues(alpha:0.8)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.end, 
           children: [
              Text(
                 "${meal.calories} kcal",
                 style: AppTextStyles.body1Medium.copyWith(color: AppColor.primary, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2), 
              Icon(Icons.chevron_right, color: AppColor.greyLight, size: 20),
           ],
        ),
        onTap: () {
          DateTime? startDate; 
          try {
            if (activePlan.startDate.isNotEmpty) {
              startDate = DateTime.parse(activePlan.startDate.split('T')[0]);
            } else {
               throw FormatException("Diyet planı başlangıç tarihi boş.");
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Öğün detayı gösterilemiyor: Geçersiz plan başlangıç tarihi.'),
                backgroundColor: Colors.redAccent,
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MealDetailScreen(
                meal: meal,
                dietPlanStartDate: startDate!, 
              ),
            ),
          );
        },
        visualDensity: VisualDensity.compact,
    );
  }
}