import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/formatters.dart';
import 'package:dietician_app/client/models/compare_diet_plan_model.dart';
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
        child: Center(child: CircularProgressIndicator(color: AppColor.secondary.withValues(alpha:0.7))),
      );
    }

    if (comparisonErrorMessage != null) {
      bool isNoDataError = comparisonErrorMessage!.contains("aktif bir diyet planı bulunamadı") ||
                           comparisonErrorMessage!.contains("no active diet plan") ||
                           comparisonErrorMessage!.contains("belirtilen tarihte"); 

      if (isNoDataError) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: AppColor.greyLight, size: 35),
                const SizedBox(height: 10),
                Text(
                  "Bu tarih için diyet planı veya kayıtlı öğün bulunamadı.\nKarşılaştırma yapılamıyor.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
              const SizedBox(height: 10),
              Text(
                "Karşılaştırma yüklenemedi:\n$comparisonErrorMessage",
                textAlign: TextAlign.center,
                style: AppTextStyles.body1Regular.copyWith(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      );
    }

    if (comparisonData == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, color: AppColor.greyLight, size: 35),
              const SizedBox(height: 10),
              Text(
                "Karşılaştırma verisi bulunamadı.",
                textAlign: TextAlign.center,
                style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
              ),
            ],
          ),
        ),
      );
    }

    final mealTypeKey = mealType.toLowerCase();
    final specificMealComparison = comparisonData!.meals[mealTypeKey];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.getDynamicHeight(2.5)),
        
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