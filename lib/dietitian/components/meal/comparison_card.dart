import 'package:flutter/material.dart';
import 'package:dietician_app/client/models/compare_diet_plan_model.dart'; 
import 'package:dietician_app/client/core/theme/color.dart'; 
import 'package:dietician_app/client/core/theme/textstyle.dart'; 

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
      elevation: 1.0, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.white, 
      margin: EdgeInsets.zero, 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title, 
              style: AppTextStyles.heading4.copyWith(color: AppColor.primary), 
            ),
            const SizedBox(height: 10),

            _buildHeaderRow(),
            Divider(height: 15, thickness: 1, color: AppColor.greyLight.withOpacity(0.5)),

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
              label: '🍞 Karbonhidrat', 
              plannedValue: planned.carbs,
              loggedValue: logged.carbs,
              differenceValue: difference.carbs,
              unit: 'g',
            ),

           
            if (showItems && (planned.items.isNotEmpty || logged.items.isNotEmpty)) ...[
              Divider(height: 25, thickness: 1, color: AppColor.greyLight.withOpacity(0.5)),
              Text(
                "Detaylar:",
                style: AppTextStyles.body1Medium.copyWith(color: AppColor.black.withOpacity(0.8)),
              ),
              const SizedBox(height: 8),
              if (planned.items.isNotEmpty) ...[
                Text(
                  "Planlanan Öğeler:",
                  style: AppTextStyles.body2Medium.copyWith(color: AppColor.black),
                ),
                ...planned.items.map((item) => _buildComparisonItemRow(item, isPlanned: true)),
                const SizedBox(height: 10),
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


  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0), 
      child: Row(
        children: [
          Expanded(
            flex: 3, 
            child: Text(
              'Besin Değeri',
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.black, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2, 
            child: Text(
              'Plan',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.black, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Yenilen',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.black, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Fark',
              textAlign: TextAlign.right,
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.black, fontWeight: FontWeight.w600),
            ),
          ),
        ],
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
    final diffStrAbs = isCalorie ? differenceValue.abs().toInt().toString() : differenceValue.abs().toStringAsFixed(1);

    final Color diffColor;
    if (differenceValue > (isCalorie ? 50 : 5)) { 
      diffColor = Colors.redAccent;
    } else if (differenceValue < (isCalorie ? -50 : -5)) { 
      diffColor = Colors.orange.shade700;
    } else { 
      diffColor = Colors.green.shade700;
    }

    final String diffText;
    if (differenceValue.abs() < 0.1 && !isCalorie) { 
       diffText = '-';
    } else if (differenceValue > 0) {
       diffText = '+$diffStrAbs $unit';
    } else if (differenceValue < 0) {
       diffText = '-$diffStrAbs $unit';
    } else {
       diffText = '-'; 
    }


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: AppTextStyles.body1Medium.copyWith(color: AppColor.black)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$plannedStr $unit',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$loggedStr $unit',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.black), 
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              diffText,
              textAlign: TextAlign.right,
              style: AppTextStyles.body1Medium.copyWith(color: diffColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItemRow(ComparisonItem item, {required bool isPlanned}) {

    final proteinStr = item.protein > 0 ? " P:${item.protein.toStringAsFixed(1)}g" : "";
    final fatStr = item.fat > 0 ? " Y:${item.fat.toStringAsFixed(1)}g" : "";
    final carbsStr = item.carbs > 0 ? " K:${item.carbs.toStringAsFixed(1)}g" : "";

    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "• ${item.description}", 
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              "${item.calories}kcal$proteinStr$fatStr$carbsStr", 
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.secondary.withOpacity(0.9)),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}