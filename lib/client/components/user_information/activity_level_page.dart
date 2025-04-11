import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';

class ActivityLevelSelector extends StatelessWidget {
  final String? activityLevel;
  final Function(String?) onActivityLevelSelected;

  const ActivityLevelSelector({
    super.key,
    required this.activityLevel,
    required this.onActivityLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    const List<Map<String, String>> activityOptions = [
      {"title": "Hareketsiz yaşam", "value": "sedentary"},
      {"title": "Hafif hareketli", "value": "light"},
      {"title": "Orta düzeyde aktif", "value": "moderate"},
      {"title": "Aktif yaşam", "value": "active"},
      {"title": "Çok aktif yaşam", "value": "very_active"},
    ];

    return Padding(
      padding: context.paddingNormal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Aktivite Seviyeniz Nedir?",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.getDynamicHeight(3)),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(activityOptions.length, (index) {
              final option = activityOptions[index];
              final isSelected = activityLevel == option["value"];

              if (index == activityOptions.length - 1) {
                return Container(
                  alignment: Alignment.center,
                  child: _buildActivityCard(option, isSelected,context),
                );
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: _buildActivityCard(option, isSelected,context),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, String> option, bool isSelected,BuildContext context) {
    return GestureDetector(
      onTap: () {
        onActivityLevelSelected(option["value"]);
      },
      child: AnimatedContainer(
        height: context.getDynamicHeight(18),
        width: context.getDynamicWidth(45),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: context.paddingNormal,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.secondary : AppColor.grey,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              option["title"]!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Medium.copyWith(
                color: isSelected ? AppColor.white : AppColor.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
