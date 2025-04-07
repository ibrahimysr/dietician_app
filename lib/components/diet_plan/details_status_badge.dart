import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DetailsStatusBadge extends StatelessWidget {
  final String status;

  const DetailsStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    Color textColor;
    String text;

    switch (status.toLowerCase()) {
      case 'active':
        icon = Icons.play_circle_fill;
        color = Colors.green;
        text = "Aktif";
        textColor = Colors.green.shade800;
        break;
      case 'paused':
        icon = Icons.pause_circle_filled;
        color = Colors.orange;
        text = "Duraklatıldı";
        textColor = Colors.orange.shade800;
        break;
      case 'completed':
        icon = Icons.check_circle;
        color = AppColor.secondary;
        text = "Tamamlandı";
        textColor = AppColor.secondary;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey.shade400;
        text = status.isNotEmpty ? status[0].toUpperCase() + status.substring(1) : 'Bilinmiyor';
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.body1Medium.copyWith(color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}