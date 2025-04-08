import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:dietician_app/models/compare_diet_plan_model.dart';
import 'package:flutter/material.dart';
import 'comparison_card.dart';

class ComparisonSection extends StatelessWidget {
  final bool isLoadingComparison;
  final String? comparisonErrorMessage;
  final DietComparisonData? comparisonData;
  final String mealType;

  const ComparisonSection({
    super.key,
    required this.isLoadingComparison,
    required this.comparisonErrorMessage,
    required this.comparisonData,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingComparison) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Center(child: CircularProgressIndicator(color: AppColor.secondary.withOpacity(0.7))),
      );
    }

    if (comparisonErrorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Text(
            "Karşılaştırma yüklenemedi: $comparisonErrorMessage",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    if (comparisonData == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(child: Text("Karşılaştırma verisi bulunamadı.")),
      );
    }

    final mealTypeKey = mealType.toLowerCase();
    final specificMealComparison = comparisonData!.meals[mealTypeKey];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.getDynamicHeight(2.5)),
        Text(
          "Günlük Karşılaştırma (${formatDate(comparisonData!.date, format: 'dd MMMM')})",
          style: AppTextStyles.heading4,
        ),
        SizedBox(height: context.getDynamicHeight(1)),
        ComparisonCard(
          title: "Günlük Toplamlar",
          planned: comparisonData!.dailyTotals.dietPlan,
          logged: comparisonData!.dailyTotals.foodLogs,
          difference: comparisonData!.dailyTotals.difference,
        ),
        if (specificMealComparison != null) ...[
          SizedBox(height: context.getDynamicHeight(2.5)),
          Text(
            "${getMealTypeName(mealType)} Karşılaştırması",
            style: AppTextStyles.heading4,
          ),
          SizedBox(height: context.getDynamicHeight(1)),
          ComparisonCard(
            title: getMealTypeName(mealType),
            planned: specificMealComparison.dietPlan,
            logged: specificMealComparison.foodLogs,
            difference: specificMealComparison.difference,
            showItems: true,
          ),
        ] else ...[
          SizedBox(height: context.getDynamicHeight(2.5)),
          Text(
            "${getMealTypeName(mealType)} için karşılaştırma verisi bulunamadı.",
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
          ),
        ],
      ],
    );
  }

  
}