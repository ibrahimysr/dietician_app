import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class FoodEmptyState extends StatelessWidget {
  final bool isSearchActive;

  const FoodEmptyState({super.key, required this.isSearchActive});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColor.greyLight,
          ),
          SizedBox(height: 16),
          Text(
            isSearchActive
                ? "Arama sonucuyla eşleşen besin bulunamadı."
                : "Bu filtreye uygun besin bulunamadı.",
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}