import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DetailsMacroInfo extends StatelessWidget {
  final String label;
  final String value;

  const DetailsMacroInfo({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.body2Medium.copyWith(color: AppColor.secondary)),
        SizedBox(height: 2),
        Text(value, style: AppTextStyles.body1Medium.copyWith(color: AppColor.black)),
      ],
    );
  }
}