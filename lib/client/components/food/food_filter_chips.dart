import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/screens/food/all_food_screen.dart';
import 'package:flutter/material.dart';

class FoodFilterChips extends StatelessWidget {
  final FoodFilter currentFilter;
  final Function(FoodFilter) onFilterSelected;

  const FoodFilterChips({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
  });

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : AppColor.grey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body2Medium.copyWith(
              color: isSelected ? AppColor.white : AppColor.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip("Tümü", currentFilter == FoodFilter.all, () {
            onFilterSelected(FoodFilter.all);
          }),
          const SizedBox(width: 12),
          _buildFilterChip("Özel Besinler", currentFilter == FoodFilter.custom, () {
            onFilterSelected(FoodFilter.custom);
          }),
          const SizedBox(width: 12),
          _buildFilterChip("Genel Besinler", currentFilter == FoodFilter.nonCustom, () {
            onFilterSelected(FoodFilter.nonCustom);
          }),
        ],
      ),
    );
  }
}