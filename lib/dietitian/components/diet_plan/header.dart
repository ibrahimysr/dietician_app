
import 'dart:developer';

import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:flutter/material.dart';

import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class CardHeader extends StatelessWidget {
  final ClientDietPlan plan;

  const CardHeader({super.key, required this.plan});

  IconData _getPlanStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.play_circle_outline_rounded; 
      case 'paused':
        return Icons.pause_circle_outline_rounded;
      case 'completed':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade600; 
      case 'paused':
        return Colors.orange.shade700; 
      case 'completed':
        return AppColor.primary; 
      default:
        return Colors.grey.shade600; 
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Aktif';
      case 'paused':
        return 'Duraklatıldı';
      case 'completed':
        return 'Tamamlandı';
      default:
        return 'Bilinmiyor';
    }
  }

  String _calculateDuration(String? startDate, String? endDate) {
    if (startDate == null || endDate == null || startDate.isEmpty || endDate.isEmpty) {
      return ''; 
    }
    try {
      final DateTime start = DateTime.parse(startDate.contains('T') ? startDate.split('T')[0] : startDate);
      final DateTime end = DateTime.parse(endDate.contains('T') ? endDate.split('T')[0] : endDate);

      if (end.isBefore(start)) return '';
      if (end.isAtSameMomentAs(start)) return '1 gün';

      int days = end.difference(start).inDays + 1;

      if (days <= 0) return ''; 

      int weeks = (days / 7).floor();
      int remainingDays = days % 7;

      if (weeks > 0 && remainingDays > 0) {
        return "$weeks hafta $remainingDays gün"; 
      } else if (weeks > 0) {
        return "$weeks hafta";
      } else {
        return "$days gün"; 
      }
    } catch (e) {
      log("Süre hesaplama hatası: $e");
      return ''; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = plan.status;
    final Color statusColor = _getStatusColor(status);
    final String statusText = _getStatusText(status);
    final String durationText = _calculateDuration(plan.startDate, plan.endDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha:0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
       
      ),
      child: Row(
        children: [
          Icon(
            _getPlanStatusIcon(status),
            size: 18, 
            color: statusColor,
          ),
          const SizedBox(width: 8), 

          Text(
            statusText,
            style: AppTextStyles.body2Medium.copyWith(color: statusColor, fontWeight: FontWeight.w600), 
          ),
          const Spacer(),

          if (durationText.isNotEmpty)
            Row(
              children: [
                 Icon(Icons.timer_outlined, size: 14, color: AppColor.black.withValues(alpha:0.8)),
                 const SizedBox(width: 4),
                 Text(
                  durationText,
                  style: AppTextStyles.body1Medium.copyWith( 
                    color: AppColor.black.withValues(alpha:0.9), 
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}