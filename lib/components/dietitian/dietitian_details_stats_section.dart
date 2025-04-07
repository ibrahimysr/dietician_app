import 'package:dietician_app/components/dietitian/dietitian_details_stat_item.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/models/dietitian_model.dart';
import 'package:flutter/material.dart';

class DietitianDetailsStatsSection extends StatelessWidget {
  final Dietitian dietitian;

  const DietitianDetailsStatsSection({super.key, required this.dietitian});

  String _displayValue(String? value, {String defaultValue = "Belirtilmemiş"}) {
    return (value == null || value.isEmpty) ? defaultValue : value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColor.grey?.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DietitianDetailsStatItem(
            icon: Icons.workspace_premium_outlined,
            label: "Deneyim",
            value: "${dietitian.experienceYears} Yıl",
            iconColor: AppColor.secondary,
          ),
          DietitianDetailsStatItem(
            icon: Icons.price_change_outlined,
            label: "Ücret",
            value: "${_displayValue(dietitian.hourlyRate, defaultValue: '??')} TL/Saat",
            iconColor: AppColor.primary,
          ),
        ],
      ),
    );
  }
}