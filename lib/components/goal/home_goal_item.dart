import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/goal_model.dart';
import 'package:flutter/material.dart';

class GoalItem extends StatelessWidget {
  final Goal goal;
  final Function(Goal) onUpdateProgress;

  const GoalItem({
    super.key,
    required this.goal,
    required this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    double progress = goal.calculatedProgress;
    Color progressColor = Color.lerp(AppColor.primary, AppColor.primary, progress) ?? AppColor.primary;
    String currentValueStr = goal.currentValue?.toStringAsFixed(0) ?? '-';
    String targetValueStr = goal.targetValue?.toStringAsFixed(0) ?? '-';
    String unitStr = goal.unit ?? '';

    return Card(
      elevation: 0.0,
      color: AppColor.grey,
      margin: EdgeInsets.only(bottom: context.getDynamicHeight(1.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.flag_outlined, color: progressColor, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    goal.title,
                    style: AppTextStyles.body1Medium.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_note, color: AppColor.secondary, size: 24),
                  tooltip: "İlerlemeyi Güncelle",
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () => onUpdateProgress(goal),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$currentValueStr / $targetValueStr $unitStr",
                  style: AppTextStyles.body1Regular.copyWith(color: AppColor.black.withValues(alpha: 0.8)),
                ),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: AppTextStyles.body1Medium.copyWith(color: progressColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: progressColor.withOpacity(0.2),
              ),
            ),
            if (targetValueStr.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    targetValueStr,
                    style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}