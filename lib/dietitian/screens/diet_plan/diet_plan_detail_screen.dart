
import 'package:collection/collection.dart'; 
import 'package:dietician_app/dietitian/components/diet_plan/details_day_meals_card.dart';
import 'package:dietician_app/dietitian/components/diet_plan/details_general_info_card.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:flutter/material.dart';


import 'package:dietician_app/client/components/diet_plan/details_empty_meals_card.dart';
import 'package:dietician_app/client/components/diet_plan/details_section_header.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';

import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';


class DietPlanDetailScreen extends StatelessWidget {
  final ClientDietPlan plan;

  const DietPlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final groupedMeals = groupBy(plan.meals, (ClientMeal meal) => meal.dayNumber);
    final sortedDays = groupedMeals.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColor.white, 
      appBar: CustomAppBar(title: plan.title.isNotEmpty ? plan.title : "Diyet Planı Detayı"),
      body: ListView(
        padding: context.paddingNormal, 
        children: [
          const DetailsSectionHeader(title: "Genel Bilgiler"),
          DietitianDetailsGeneralInfoCard(plan: plan),
          SizedBox(height: context.getDynamicHeight(2.5)),
          
          SizedBox(height: context.getDynamicHeight(2.5)),

          const DetailsSectionHeader(title: "Öğünler"),
          if (plan.meals.isEmpty)
            const DetailsEmptyMealsCard() 
          else
            ...sortedDays
                .map((dayNumber) =>DietitianDetailsDayMealsCard (
                      dayNumber: dayNumber,
                      meals: groupedMeals[dayNumber]!,
                        plan: plan,
                    ))
                .expand((widget) => [widget, SizedBox(height: context.getDynamicHeight(1.5))]),

          SizedBox(height: context.getDynamicHeight(2)), 
        ],
      ),
    );
  }
}