import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/food_model.dart';
import 'package:flutter/material.dart';

class FoodMacronutrient extends StatelessWidget {
      final Food food;

  const FoodMacronutrient({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
     double totalMacros = double.tryParse(food.protein)! + 
                       double.tryParse(food.fat)! + 
                       double.tryParse(food.carbs)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Makro Besin Değerleri',
          style: AppTextStyles.heading3.copyWith(color: AppColor.black),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMacroCard(
                name: 'Protein',
                value: food.protein,
                color: Colors.blue.shade700,
                icon: Icons.fitness_center,
                percentage: totalMacros > 0 ? 
                  (double.tryParse(food.protein)! / totalMacros) : 0,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildMacroCard(
                name: 'Yağ',
                value: food.fat,
                color: Colors.redAccent,
                icon: Icons.water_drop,
                percentage: totalMacros > 0 ? 
                  (double.tryParse(food.fat)! / totalMacros) : 0,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildMacroCard(
                name: 'Karb',
                value: food.carbs,
                color: Colors.green.shade600,
                icon: Icons.grain,
                percentage: totalMacros > 0 ? 
                  (double.tryParse(food.carbs)! / totalMacros) : 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  
  Widget _buildMacroCard({
    required String name,
    required String value,
    required Color color,
    required IconData icon,
    required double percentage,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          SizedBox(height: 12),
          Text(
            name,
            style: AppTextStyles.body2Medium.copyWith(color: color),
          ),
          SizedBox(height: 8),
          Text(
            '$value g',
            style: AppTextStyles.heading4.copyWith(color: color),
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${(percentage * 100).toStringAsFixed(0)}%',
            style: AppTextStyles.body2Regular.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}