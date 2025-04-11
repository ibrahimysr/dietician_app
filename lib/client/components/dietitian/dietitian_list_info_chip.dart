import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DietitianListInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final bool isBold;

  const DietitianListInfoChip({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.textColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: isBold
              ? AppTextStyles.body2Medium.copyWith(color: textColor)
              : AppTextStyles.body2Regular.copyWith(color: textColor),
        ),
      ],
    );
  }
}