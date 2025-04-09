import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/goal_model.dart';
import 'package:dietician_app/screens/goal/all_goal_screen.dart';
import 'package:flutter/material.dart';
import 'home_goal_item.dart';

class GoalsSection extends StatelessWidget {
  final bool isLoadingGoals;
  final String? goalErrorMessage;
  final List<Goal> goals;
  final int dietitianId;
  final VoidCallback onRefresh;
  final Function(Goal) onUpdateProgress;

  const GoalsSection({
    super.key,
    required this.isLoadingGoals,
    required this.goalErrorMessage,
    required this.goals,
    required this.dietitianId,
    required this.onRefresh,
    required this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    final activeGoals = goals.where((g) => g.status.toLowerCase() == 'in_progress').take(3).toList();
    final hasMoreGoals = goals.isNotEmpty || goals.any((g) => g.status.toLowerCase() != 'in_progress');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Aktif Hedefler", style: AppTextStyles.heading4),
            if (hasMoreGoals)
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AllGoalsScreen(dietitianId: dietitianId)))
                      .then((_) => onRefresh());
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                child: Text(
                  "Tümünü Gör",
                  style: AppTextStyles.body1Medium.copyWith(color: AppColor.primary),
                ),
              ),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(1.5)),
        if (isLoadingGoals)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: AppColor.primary.withValues(alpha:0.7)),
            ),
          )
        else if (goalErrorMessage != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Hedefler yüklenemedi.", style: TextStyle(color: Colors.redAccent)),
            ),
          )
        else if (goals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColor.grey?.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.grey!.withAlpha(100), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag_outlined, color: AppColor.greyLight, size: 20),
                SizedBox(width: 10),
                Text(
                  "Şu anda aktif bir hedefiniz bulunmuyor.",
                  style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
                ),
              ],
            ),
          )
        else if (activeGoals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColor.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Şu anda devam eden bir hedefiniz yok.\nTüm hedeflerinizi görmek için 'Tümünü Gör'e dokunun.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: activeGoals.length,
            itemBuilder: (context, index) {
              return GoalItem(
                goal: activeGoals[index],
                onUpdateProgress: onUpdateProgress,
              );
            },
          ),
      ],
    );
  }
}