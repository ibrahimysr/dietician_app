
import 'package:dietician_app/dietitian/components/diet_plan/details_meal_item.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/formatters.dart'; 

class DietitianDetailsDayMealsCard extends StatelessWidget {
  final int dayNumber;
  final List<ClientMeal> meals;
  final ClientDietPlan plan;

  const DietitianDetailsDayMealsCard({super.key, required this.dayNumber, required this.meals,  required this.plan,});

  @override
  Widget build(BuildContext context) {
    
      meals.sort((a, b) => getMealTypeOrder(a.mealType).compareTo(getMealTypeOrder(b.mealType)));
    
  

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1, 
      clipBehavior: Clip.antiAlias, 
      margin: EdgeInsets.zero,
      color: AppColor.grey, 
      child: ExpansionTile(
        title: Text("Gün $dayNumber", style: AppTextStyles.body1Medium.copyWith(color: AppColor.black)),
        initiallyExpanded: dayNumber == 1,
        iconColor: AppColor.primary,
        collapsedIconColor: AppColor.secondary,
        backgroundColor: Colors.transparent, 
        collapsedBackgroundColor: Colors.transparent, 
        shape: const Border(),
        collapsedShape: const Border(),
        childrenPadding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
        children: meals.map((meal) => DietitianDetailsMealItem(meal: meal,  plan: plan)).toList(),
      ),
    );
  }
}