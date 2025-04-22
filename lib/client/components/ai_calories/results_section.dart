import 'package:dietician_app/client/components/ai_calories/nutrition_item.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:flutter/material.dart';

Widget buildResultsSection(  Map<String, dynamic>? _foodDetails) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _foodDetails!['food_name'] ?? 'Bilinmeyen Yiyecek',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          buildNutritionItem(
            'Kalori',
            '${_foodDetails['calories']?.toStringAsFixed(0) ?? 'Bilinmiyor'} kcal',
            Colors.orange,
            Icons.local_fire_department,
          ),
          const Divider(height: 24),
          buildNutritionItem(
            'Protein',
            '${_foodDetails['protein']?.toStringAsFixed(1) ?? '0'} g',
            Colors.red,
            Icons.fitness_center,
          ),
          const Divider(height: 24),
          buildNutritionItem(
            'Yağ',
            '${_foodDetails['fat']?.toStringAsFixed(1) ?? '0'} g',
            Colors.yellow[700]!,
            Icons.opacity,
          ),
          const Divider(height: 24),
          buildNutritionItem(
            'Karbonhidrat',
            '${_foodDetails['carbs']?.toStringAsFixed(1) ?? '0'} g',
            Colors.green,
            Icons.grain,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:AppColor.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children:  [
                Icon(Icons.info_outline, color:AppColor.primary, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Not: Kalori ve besin değerleri tahmini olup gerçek değerlerden farklı olabilir.',
                    style: TextStyle(fontSize: 12, color:AppColor.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
         
        ],
      ),
    );
  }