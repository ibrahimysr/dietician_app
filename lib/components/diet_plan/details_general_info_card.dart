
import 'package:dietician_app/components/diet_plan/details_info_row.dart';
import 'package:dietician_app/components/diet_plan/details_status_badge.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class DetailsGeneralInfoCard extends StatelessWidget {
  final DietPlan plan;

  const DetailsGeneralInfoCard({super.key, required this.plan});

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Belirtilmemiş';
    try {
      final datePart = dateString.split('T')[0];
      final dateTime = DateTime.parse(datePart);
      return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }

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
            Align(
              alignment: Alignment.centerRight,
              child: DetailsStatusBadge(status: plan.status),
            ),
            SizedBox(height: 12),
            DetailsInfoRow(
              icon: Icons.calendar_today_outlined,
              label: "Başlangıç Tarihi:",
              value: _formatDate(plan.startDate),
            ),
            SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.event_available_outlined,
              label: "Bitiş Tarihi:",
              value: _formatDate(plan.endDate),
            ),
            SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.local_fire_department_outlined,
              label: "Günlük Kalori:",
              value: "${plan.dailyCalories} kcal",
            ),
            SizedBox(height: 10),
            if (plan.notes.isNotEmpty) ...[
              Divider(color: AppColor.greyLight.withValues(alpha: 0.5), height: 20),
              DetailsInfoRow(
                icon: Icons.notes_outlined,
                label: "Notlar:",
                value: plan.notes,
                isMultiline: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}