import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/compare_diet_plan_model.dart';
import 'package:flutter/material.dart';

class ComparisonCard extends StatelessWidget {
  final String title;
  final ComparisonDetails planned;
  final ComparisonDetails logged;
  final DifferenceDetails difference;
  final bool showItems;

  const ComparisonCard({
    super.key,
    required this.title,
    required this.planned,
    required this.logged,
    required this.difference,
    this.showItems = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Besin',
                    style: AppTextStyles.body2Medium.copyWith(color: AppColor.secondary),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Plan',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body2Medium.copyWith(color: AppColor.secondary),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Yenilen',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body2Medium.copyWith(color: AppColor.secondary),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Fark',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body2Medium.copyWith(color: AppColor.secondary),
                  ),
                ),
              ],
            ),
            Divider(height: 15),
            _buildComparisonDetailRow(
              label: '🔥 Kalori',
              plannedValue: planned.calories.toDouble(),
              loggedValue: logged.calories.toDouble(),
              differenceValue: difference.calories,
              unit: 'kcal',
              isCalorie: true,
            ),
            _buildComparisonDetailRow(
              label: '💪 Protein',
              plannedValue: planned.protein,
              loggedValue: logged.protein,
              differenceValue: difference.protein,
              unit: 'g',
            ),
            _buildComparisonDetailRow(
              label: '🥑 Yağ',
              plannedValue: planned.fat,
              loggedValue: logged.fat,
              differenceValue: difference.fat,
              unit: 'g',
            ),
            _buildComparisonDetailRow(
              label: '🍞 Karb.',
              plannedValue: planned.carbs,
              loggedValue: logged.carbs,
              differenceValue: difference.carbs,
              unit: 'g',
            ),
            if (showItems && (planned.items.isNotEmpty || logged.items.isNotEmpty)) ...[
              Divider(height: 25),
              Text(
                "Detaylar:",
                style: AppTextStyles.body1Medium.copyWith(color: AppColor.black.withValues(alpha: 0.7)),
              ),
              SizedBox(height: 8),
              if (planned.items.isNotEmpty) ...[
                Text(
                  "Planlanan Öğeler:",
                  style: AppTextStyles.body2Medium.copyWith(color: AppColor.black),
                ),
                ...planned.items.map((item) => _buildComparisonItemRow(item, isPlanned: true)),
                SizedBox(height: 10),
              ],
              if (logged.items.isNotEmpty) ...[
                Text(
                  "Yenilen Öğeler:",
                  style: AppTextStyles.body2Medium.copyWith(color: AppColor.black),
                ),
                ...logged.items.map((item) => _buildComparisonItemRow(item, isPlanned: false)),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonDetailRow({
    required String label,
    required double plannedValue,
    required double loggedValue,
    required double differenceValue,
    required String unit,
    bool isCalorie = false,
  }) {
    final plannedStr = isCalorie ? plannedValue.toInt().toString() : plannedValue.toStringAsFixed(1);
    final loggedStr = isCalorie ? loggedValue.toInt().toString() : loggedValue.toStringAsFixed(1);
    final diffStr = '${isCalorie ? differenceValue.toInt().toString() : differenceValue.toStringAsFixed(1)} $unit';
    final diffColor = differenceValue > 5
        ? Colors.redAccent
        : differenceValue < -5
            ? Colors.orange.shade700
            : Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: AppTextStyles.body1Medium),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$plannedStr $unit',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Regular,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$loggedStr $unit',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Regular,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              differenceValue == 0 ? '-' : (differenceValue > 0 ? '+$diffStr' : diffStr),
              textAlign: TextAlign.right,
              style: AppTextStyles.body1Medium.copyWith(color: diffColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItemRow(ComparisonItem item, {required bool isPlanned}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              isPlanned ? "• ${item.description}" : "• ${item.description} (${item.quantity ?? '?'} pors.)",
              style: AppTextStyles.body2Regular,
            ),
          ),
          SizedBox(width: 10),
          Text(
            "${item.calories}kcal, P:${item.protein.toStringAsFixed(1)}g, Y:${item.fat.toStringAsFixed(1)}g, K:${item.carbs.toStringAsFixed(1)}g",
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.secondary),
          ),
        ],
      ),
    );
  }
}