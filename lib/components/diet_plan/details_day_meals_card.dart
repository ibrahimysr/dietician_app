import 'package:dietician_app/components/diet_plan/details_meal_item.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class DetailsDayMealsCard extends StatelessWidget {
  final int dayNumber;
  final List<Meal> meals;

  const DetailsDayMealsCard({super.key, required this.dayNumber, required this.meals});

  @override
  Widget build(BuildContext context) {
    meals.sort((a, b) => getMealTypeOrder(a.mealType).compareTo(getMealTypeOrder(b.mealType)));
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.white,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text("Gün $dayNumber", style: AppTextStyles.heading4.copyWith(color: AppColor.black)),
        initiallyExpanded: dayNumber == 1,
        backgroundColor: AppColor.grey?.withValues(alpha: 0.1),
        collapsedBackgroundColor: AppColor.white,
        shape: Border(),
        collapsedShape: Border(),
        childrenPadding: EdgeInsets.only(bottom: 10, left: 16, right: 16),
        children: meals.map((meal) => DetailsMealItem(meal: meal)).toList(),
      ),
    );
  }
}