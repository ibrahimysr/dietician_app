import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DetailsEmptyMealsCard extends StatelessWidget {
  const DetailsEmptyMealsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.grey?.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_food_outlined, color: AppColor.greyLight, size: 20),
            SizedBox(width: 10),
            Text(
              "Bu plan için öğün bulunmamaktadır.",
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
            ),
          ],
        ),
      ),
    );
  }
}