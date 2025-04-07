import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DietitianDetailsSectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const DietitianDetailsSectionTitle({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(color: color),
    );
  }
}