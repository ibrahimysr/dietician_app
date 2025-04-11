import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String filterStatus;
  final Function(String) onFilterSelected;

  const FilterChips({
    super.key,
    required this.filterStatus,
    required this.onFilterSelected,
  });

  Widget _buildFilterChip(String status, String label, bool isSelected) {
    return InkWell(
      onTap: () => onFilterSelected(status),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : AppColor.grey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.greyLight,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2Medium.copyWith(
            color: isSelected ? AppColor.white : AppColor.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('all', 'Tümü', filterStatus == 'all'),
            SizedBox(width: 8),
            _buildFilterChip('active', 'Aktif', filterStatus == 'active'),
            SizedBox(width: 8),
            _buildFilterChip('paused', 'Duraklatıldı', filterStatus == 'paused'),
            SizedBox(width: 8),
            _buildFilterChip('completed', 'Tamamlandı', filterStatus == 'completed'),
          ],
        ),
      ),
    );
  }
}