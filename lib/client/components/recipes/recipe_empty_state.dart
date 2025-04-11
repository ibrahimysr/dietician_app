import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class RecipeEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const RecipeEmptyState({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_food_outlined, 
            color: AppColor.greyLight,
            size: 80,
          ),
          const SizedBox(height: 20),
          Text(
            'Tarif Bulunamadı',
            style: AppTextStyles.heading3.copyWith(color: AppColor.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Yeni tarifler için daha sonra tekrar kontrol edin!',
            style: AppTextStyles.body2Regular.copyWith(color: AppColor.greyLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh, color: AppColor.white),
            label: Text(
              'Yenile', 
              style: AppTextStyles.buttonText.copyWith(color: AppColor.white),
            ),
            onPressed: onRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
          )
        ],
      ),
    );
  }
}