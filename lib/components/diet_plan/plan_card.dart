
import 'package:dietician_app/components/diet_plan/card_footer.dart';
import 'package:dietician_app/components/diet_plan/card_header.dart';
import 'package:dietician_app/components/diet_plan/info_chip.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/screens/diet_plan/diet_plan_details_screen.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final DietPlan plan;

  const PlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DietPlanDetailScreen(plan: plan),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(plan: plan),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: AppTextStyles.heading4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColor.greyLight),
                      SizedBox(width: 4),
                      Text(
                        "Dyt. ${plan.dietitian.user?.name ?? 'N/A'}",
                        style: AppTextStyles.body2Regular.copyWith(
                          color: AppColor.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      InfoChip(
                        icon: Icons.calendar_today,
                        text: "${_formatDate(plan.startDate)} - ${_formatDate(plan.endDate)}",
                      ),
                      SizedBox(width: 8),
                      InfoChip(
                        icon: Icons.local_fire_department,
                        text: "${plan.dailyCalories} kcal",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CardFooter(plan: plan),
          ],
        ),
      ),
    );
  }

  String? _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      if (dateString.contains('T')) {
        dateString = dateString.split('T')[0];
      }
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day}.${dateTime.month}.${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }
}