import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/recipes_model.dart';
import 'package:flutter/material.dart';


class QuickInfoSection extends StatelessWidget {
  final Recipes recipe;

  const QuickInfoSection({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha:0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickInfoItem(
              Icons.timer_outlined,
              '${recipe.prepTime} dk',
              'Hazırlama Süresi',
              AppColor.primary,
            ),
            _buildQuickInfoItem(
              Icons.local_fire_department_outlined,
              '${recipe.calories} Kal',
              'Kalori',
              AppColor.secondary,
            ),
            _buildQuickInfoItem(
              Icons.people_outline,
              '${recipe.servings} Porsiyon',
              'Porsiyon',
              AppColor.greyLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.body2Regular.copyWith(
            color: AppColor.secondary,
          ),
        ),
      ],
    );
  }
}