import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  final DietPlan plan;

  const CardHeader({super.key, required this.plan});

  IconData _getPlanStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.play_circle_outline;
      case 'paused':
        return Icons.pause_circle_outline;
      case 'completed':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'completed':
        return AppColor.primary;
      default:
        return Colors.grey;
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
        return 'Bilinmeyen';
    }
  }

  String _calculateDuration(String? startDate, String? endDate) {
    if (startDate == null || endDate == null || startDate.isEmpty || endDate.isEmpty) {
      return '';
    }
    try {
      DateTime start = DateTime.parse(startDate.split('T')[0]);
      DateTime end = DateTime.parse(endDate.split('T')[0]);
      int days = end.difference(start).inDays + 1;
      int weeks = (days / 7).floor();
      return weeks > 0 ? "$weeks hafta" : "$days gün";
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(plan.status);
    String statusText = _getStatusText(plan.status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getPlanStatusIcon(plan.status),
            size: 16,
            color: statusColor,
          ),
          SizedBox(width: 6),
          Text(
            statusText,
            style: AppTextStyles.body2Medium.copyWith(color: statusColor),
          ),
          Spacer(),
          Text(
            _calculateDuration(plan.startDate, plan.endDate),
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColor.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}