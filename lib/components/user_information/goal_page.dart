import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';

class GoalSelector extends StatelessWidget {
  final String? goal;
  final Function(String?) onGoalSelected;

  const GoalSelector({
    super.key,
    required this.goal,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    const List<Map<String, String>> goalOptions = [
      {"title": "Kilo Vermek", "value": "lose_weight"},
      {"title": "Kilo Almak", "value": "gain_weight"},
      {"title": "Formda Kalmak", "value": "maintain_weight"},
    ];

    return Padding(
      padding: context.paddingNormal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hedefiniz Nedir?",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
           SizedBox(height: context.getDynamicHeight(2)),
          Column(
            children: goalOptions.map((option) {
              final isSelected = goal == option["value"];
              return GestureDetector(
                onTap: () {
                  onGoalSelected(option["value"]);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: context.paddingNormal,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.secondary
                        : AppColor.grey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColor.secondary : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha:  isSelected ? 0.4 : 0.2),
                        blurRadius: isSelected ? 10 : 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      option["title"]!,
                      style: AppTextStyles.body1Medium.copyWith(
                        color: isSelected ? AppColor.white : AppColor.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
