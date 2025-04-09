import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class MacroInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const MacroInfo({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.body2Medium.copyWith(color: AppColor.secondary),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.heading4.copyWith(color: valueColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}