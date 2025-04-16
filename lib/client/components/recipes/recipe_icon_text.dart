import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class RecipeIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final bool isCompact;

  const RecipeIconText({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: isCompact ? 16 : 20,
        ),
        SizedBox(width: isCompact ? 4 : 8),
        Text(
          text,
          style: isCompact 
              ? AppTextStyles.body1Medium.copyWith(color: color)
              : AppTextStyles.body2Regular.copyWith(color: color),
        ),
      ],
    );
  }
}