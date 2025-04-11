
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DetailsInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isMultiline;

  const DetailsInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppColor.secondary),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body2Regular.copyWith(color: AppColor.secondary),
              ),
              SizedBox(height: isMultiline ? 4 : 2),
              Text(
                value,
                style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}