import 'package:dietician_app/client/components/diet_plan/details_info_row.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class DetailsDietitianCard extends StatelessWidget {
  final DietPlan plan;

  const DetailsDietitianCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final user = plan.dietitian.user;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsInfoRow(
              icon: Icons.person_pin_outlined,
              label: "Adı:",
              value: "Dyt. ${user?.name ?? 'Belirtilmemiş'}",
            ),
            SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.email_outlined,
              label: "E-posta:",
              value: user?.email ?? 'N/A',
            ),
            SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.phone_outlined,
              label: "Telefon:",
              value: user?.phone ?? 'N/A',
            ),
            SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.star_border_outlined,
              label: "Uzmanlık:",
              value: plan.dietitian.specialty.isNotEmpty ? plan.dietitian.specialty : 'Belirtilmemiş',
            ),
            SizedBox(height: 10),
            if (plan.dietitian.bio.isNotEmpty) ...[
              Divider(color: AppColor.greyLight.withValues(alpha: 0.5), height: 20),
              DetailsInfoRow(
                icon: Icons.info_outline,
                label: "Bio:",
                value: plan.dietitian.bio,
                isMultiline: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}