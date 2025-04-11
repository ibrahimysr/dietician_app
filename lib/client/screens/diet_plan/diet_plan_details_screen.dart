import 'package:collection/collection.dart';

import 'package:dietician_app/client/components/diet_plan/details_day_meals_card.dart';
import 'package:dietician_app/client/components/diet_plan/details_dietitian_card.dart';
import 'package:dietician_app/client/components/diet_plan/details_empty_meals_card.dart';
import 'package:dietician_app/client/components/diet_plan/details_general_info_card.dart';
import 'package:dietician_app/client/components/diet_plan/details_section_header.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class DietPlanDetailScreen extends StatelessWidget {
  final DietPlan plan;

  const DietPlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final groupedMeals = groupBy(plan.meals, (Meal meal) => meal.dayNumber);
    final sortedDays = groupedMeals.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: plan.title),
      body: ListView(
        padding: context.paddingNormal,
        children: [
          DetailsSectionHeader(title: "Genel Bilgiler"),
          DetailsGeneralInfoCard(plan: plan),
          SizedBox(height: context.getDynamicHeight(2.5)),
          DetailsSectionHeader(title: "Diyetisyen Bilgileri"),
          DetailsDietitianCard(plan: plan),
          SizedBox(height: context.getDynamicHeight(2.5)),
          DetailsSectionHeader(title: "Öğünler"),
          if (plan.meals.isEmpty)
            DetailsEmptyMealsCard()
          else
            ...sortedDays
                .map((dayNumber) => DetailsDayMealsCard(
                      dayNumber: dayNumber,
                      meals: groupedMeals[dayNumber]!,
                    ))
                .expand((widget) => [widget, SizedBox(height: context.getDynamicHeight(1.5))]),
          SizedBox(height: context.getDynamicHeight(2)),
        ],
      ),
    );
  }
}