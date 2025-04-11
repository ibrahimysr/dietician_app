import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:flutter/material.dart';

import 'package:dietician_app/client/components/diet_plan/details_info_row.dart';
import 'package:dietician_app/client/components/diet_plan/details_status_badge.dart';

import 'package:dietician_app/client/core/theme/color.dart';

class DietitianDetailsGeneralInfoCard extends StatelessWidget {
  final ClientDietPlan plan;

  const DietitianDetailsGeneralInfoCard({super.key, required this.plan});

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Belirtilmemiş';
    try {
      final datePart =
          dateString.contains('T') ? dateString.split('T')[0] : dateString;
      final dateTime = DateTime.parse(datePart);
      return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.grey,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: DetailsStatusBadge(status: plan.status),
            ),
            const SizedBox(height: 12),
            DetailsInfoRow(
              icon: Icons.calendar_today_outlined,
              label: "Başlangıç Tarihi:",
              value: _formatDate(plan.startDate),
            ),
            const SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.event_available_outlined,
              label: "Bitiş Tarihi:",
              value: _formatDate(plan.endDate),
            ),
            const SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.local_fire_department_outlined,
              label: "Günlük Kalori:",
              value: "${plan.dailyCalories} kcal",
            ),
            if (plan.notes.isNotEmpty) ...[
              Divider(
                  color: AppColor.greyLight.withOpacity(0.5),
                  height: 25,
                  thickness: 1),
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
