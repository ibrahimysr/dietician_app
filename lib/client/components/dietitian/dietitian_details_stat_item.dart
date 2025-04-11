import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DietitianDetailsStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const DietitianDetailsStatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28, color: iconColor),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.body1Medium.copyWith(color: AppColor.black)),
        const SizedBox(height: 3),
        Text(
          label,
          style: AppTextStyles.body2Regular.copyWith(color: AppColor.black.withValues(alpha: 0.65)),
        ),
      ],
    );
  }
}