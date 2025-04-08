import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:dietician_app/models/compare_diet_plan_model.dart';
import 'package:flutter/material.dart';

class DailyComparisonSection extends StatelessWidget {
  final bool isLoadingComparison;
  final String? comparisonErrorMessage;
  final DietComparisonData? dailyComparisonData;
  final VoidCallback onRetry;

  const DailyComparisonSection({
    super.key,
    required this.isLoadingComparison,
    required this.comparisonErrorMessage,
    required this.dailyComparisonData,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingComparison) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: CircularProgressIndicator(color: AppColor.primary.withOpacity(0.7)),
        ),
      );
    }

    if (comparisonErrorMessage != null && dailyComparisonData == null) {
      return Card(
        color: AppColor.grey,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Günlük özet yüklenemedi.",
                  style: AppTextStyles.body2Regular.copyWith(color: Colors.orange.shade900),
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 18),
                onPressed: onRetry,
                tooltip: "Tekrar dene",
                color: Colors.orange.shade900,
              ),
            ],
          ),
        ),
      );
    }

    if (dailyComparisonData == null) {
      return SizedBox.shrink();
    }

    final totals = dailyComparisonData!.dailyTotals;
    final plannedCal = totals.dietPlan.calories;
    final loggedCal = totals.foodLogs.calories;
    final diffCal = totals.difference.calories;
    final diffCalColor = diffCal > 50
        ? Colors.redAccent
        : diffCal < -50
            ? Colors.orange.shade700
            : Colors.green;

    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bugünkü Özet (${formatDate(DateTime.now(), format: 'dd MMMM')})",
                  style: AppTextStyles.heading4.copyWith(color: AppColor.secondary),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kalori (kcal)",
                      style: AppTextStyles.body1Medium.copyWith(color: AppColor.black.withValues(alpha: 0.7)),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "$loggedCal",
                          style: AppTextStyles.heading2.copyWith(color: AppColor.primary, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " / $plannedCal",
                          style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Fark",
                      style: AppTextStyles.body2Medium.copyWith(color: AppColor.greyLight),
                    ),
                    SizedBox(height: 4),
                    Text(
                      diffCal == 0 ? '-' : (diffCal > 0 ? '+${diffCal.toInt()}' : '${diffCal.toInt()}'),
                      style: AppTextStyles.heading3.copyWith(color: diffCalColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            if (plannedCal > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (loggedCal / plannedCal).clamp(0.0, 1.5),
                    minHeight: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                    backgroundColor: AppColor.primary.withOpacity(0.2),
                  ),
                ),
              ),
            if (plannedCal <= 0) SizedBox(height: 15),
            Divider(color: AppColor.grey?.withAlpha(100)),
            SizedBox(height: 10),
            NutrientProgressRow(
              label: "Protein",
              unit: "g",
              loggedValue: totals.foodLogs.protein,
              plannedValue: totals.dietPlan.protein,
              color: Colors.blue.shade700,
            ),
            NutrientProgressRow(
              label: "Yağ",
              unit: "g",
              loggedValue: totals.foodLogs.fat,
              plannedValue: totals.dietPlan.fat,
              color: Colors.orange.shade700,
            ),
            NutrientProgressRow(
              label: "Karbonhidrat",
              unit: "g",
              loggedValue: totals.foodLogs.carbs,
              plannedValue: totals.dietPlan.carbs,
              color: Colors.purple.shade700,
            ),
          ],
        ),
      ),
    );
  }
}


class NutrientProgressRow extends StatelessWidget {
  final String label;
  final String unit;
  final double loggedValue;
  final double plannedValue;
  final Color color;

  const NutrientProgressRow({
    super.key,
    required this.label,
    required this.unit,
    required this.loggedValue,
    required this.plannedValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double progress = plannedValue > 0 ? (loggedValue / plannedValue).clamp(0.0, 1.5) : 0.0;
    String loggedStr = loggedValue.toStringAsFixed(1);
    String plannedStr = plannedValue.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.body1Medium),
              Text(
                "$loggedStr / $plannedStr $unit",
                style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
              ),
            ],
          ),
          SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: color.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}