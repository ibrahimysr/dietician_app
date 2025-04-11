
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class DietitianCardFooter extends StatelessWidget {
  final ClientDietPlan plan;

  const DietitianCardFooter({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final int mealCount = plan.meals.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.grey, 
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
         border: Border(top: BorderSide(color: AppColor.greyLight.withValues(alpha:0.5), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Row(
            children: [
               Icon(Icons.restaurant_menu_outlined, size: 16, color: AppColor.black.withValues(alpha:0.8)),
               const SizedBox(width: 6),
               Text(
                mealCount > 0 ? "$mealCount öğün tanımlı" : "Öğün tanımlanmamış",
                style: AppTextStyles.body2Regular.copyWith(
                  color: AppColor.black.withValues(alpha:0.9), 
                ),
              ),
            ],
          ),

          
          Row(
            children: [
              Text(
                "Planı Görüntüle", 
                style: AppTextStyles.body2Medium.copyWith(color: AppColor.primary, fontWeight: FontWeight.w500), 
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColor.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}