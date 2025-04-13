
import 'dart:developer';

import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:dietician_app/dietitian/screens/meal/meal_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/components/diet_plan/details_macro_info.dart'; 
import 'package:dietician_app/client/core/utils/formatters.dart'; 

import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';


class DietitianDetailsMealItem extends StatelessWidget {
  final ClientMeal meal; 
    final ClientDietPlan plan;

  const DietitianDetailsMealItem({super.key, required this.meal, required this.plan,});

  @override
  Widget build(BuildContext context) {
    String mealTypeName;
    try {
      mealTypeName = getMealTypeName(meal.mealType);
    } catch (e) {
      log("getMealTypeName fonksiyonu bulunamadı veya hata verdi: $e");
      mealTypeName = meal.mealType; 
    }

    return InkWell( 
      onTap: () { 
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailScreen(
              meal: meal, 
              plan: plan,  
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealTypeName, 
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.secondary), 
            ),
            const SizedBox(height: 6),
      
            Text(
              meal.description.isNotEmpty ? meal.description : "Açıklama yok", 
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.secondary), 
            ),
            const SizedBox(height: 10),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                DetailsMacroInfo(label: "Kalori", value: "${meal.calories} kcal"),
                DetailsMacroInfo(label: "Protein", value: "${meal.protein}g"), 
                DetailsMacroInfo(label: "Yağ", value: "${meal.fat}g"),        
                DetailsMacroInfo(label: "Karbonhidrat", value: "${meal.carbs}g"), 
              ],
      
              
            ),
      
          
      
          
          ],
        ),
      ),
    );
  }
}