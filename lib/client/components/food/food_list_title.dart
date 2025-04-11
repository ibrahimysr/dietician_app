import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class FoodListTitle extends StatelessWidget {
  const FoodListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColor.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Besin Listesi",
              style: AppTextStyles.body2Medium.copyWith(color: AppColor.greyLight),
            ),
          ),
          Expanded(child: Divider(color: AppColor.grey)),
        ],
      ),
    );
  }
}