import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class CardFooter extends StatelessWidget {
  final DietPlan plan;

  const CardFooter({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Text(
            "${plan.meals.length} öğün",
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColor.black.withValues(alpha: 0.6),
            ),
          ),
          Spacer(),
          Text(
            "Detaylar",
            style: AppTextStyles.body2Medium.copyWith(color: AppColor.primary),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColor.primary,
          ),
        ],
      ),
    );
  }
}