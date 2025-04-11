import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class RecipeIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const RecipeIconText({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.body2Medium.copyWith(color: AppColor.black),
        ),
      ],
    );
  }
}