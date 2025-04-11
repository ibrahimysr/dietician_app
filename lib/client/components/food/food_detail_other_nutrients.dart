import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/food_model.dart';
import 'package:flutter/material.dart';

class FoodOtherNutrients extends StatelessWidget { 
      final Food food;

  const FoodOtherNutrients({super.key, required this.food});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Diğer Besin Değerleri',
            style: AppTextStyles.heading4.copyWith(color: AppColor.black),
          ),
          SizedBox(height: 16),
          _buildNutrientRow(
            icon: Icons.texture,
            name: 'Lif',
            value: '${food.fiber} g',
            color: Colors.brown.shade300,
          ),
          SizedBox(height: 12),
          _buildNutrientRow(
            icon: Icons.cake,
            name: 'Şeker',
            value: '${food.sugar} g',
            color: Colors.pink.shade300,
          ),
        ],
      ),
    );
  } 
  Widget _buildNutrientRow({
    required IconData icon,
    required String name,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(width: 16),
        Text(
          name,
          style: AppTextStyles.body1Medium,
        ),
        Spacer(),
        Text(
          value,
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColor.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}