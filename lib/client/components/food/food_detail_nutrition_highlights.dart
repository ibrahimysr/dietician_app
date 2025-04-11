import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/food_model.dart';
import 'package:flutter/material.dart';

class FoodNutritionHighlights extends StatelessWidget {
    final Food food;

  const FoodNutritionHighlights({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.scale_outlined,
                  color: AppColor.primary,
                  size: 28,
                ),
                SizedBox(height: 8),
                Text(
                  'Porsiyon',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColor.secondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${food.servingSize} gr',
                  style: AppTextStyles.body1Medium,
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 1,
            color: AppColor.grey,
          ),
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: AppColor.primary,
                  size: 28,
                ),
                SizedBox(height: 8),
                Text(
                  'Kalori',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColor.secondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${food.calories} kcal',
                  style: AppTextStyles.body1Medium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}