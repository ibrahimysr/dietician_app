import 'package:flutter/material.dart';
import 'package:dietician_app/models/food_model.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';

class FoodHeader extends StatelessWidget {
  final Food food;

  const FoodHeader({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                food.name,
                style: AppTextStyles.heading1.copyWith(
                  color: AppColor.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            if (food.isCustom)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.secondary.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Özel',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColor.secondary,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.greyLight.withValues(alpha:0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            food.category,
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColor.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
