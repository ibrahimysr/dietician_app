import 'package:dietician_app/components/diet_plan/details_macro_info.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class DetailsMealItem extends StatelessWidget {
  final Meal meal;

  const DetailsMealItem({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getMealTypeName(meal.mealType),
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.secondary, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            meal.description,
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DetailsMacroInfo(label: "Kalori", value: "${meal.calories} kcal"),
              DetailsMacroInfo(label: "P", value: "${meal.protein}g"),
              DetailsMacroInfo(label: "Y", value: "${meal.fat}g"),
              DetailsMacroInfo(label: "K", value: "${meal.carbs}g"),
            ],
          ),
          Divider(color: AppColor.grey?.withValues(alpha: 0.3), height: 20),
        ],
      ),
    );
  }
}