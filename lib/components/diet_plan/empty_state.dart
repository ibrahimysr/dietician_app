import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String filterStatus;

  const EmptyState({super.key, required this.filterStatus});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppColor.greyLight,
          ),
          SizedBox(height: 16),
          Text(
            "Gösterilecek diyet planı bulunamadı",
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight),
          ),
          SizedBox(height: 8),
          Text(
            filterStatus != 'all'
                ? "Filtre kriterlerinizi değiştirmeyi deneyin"
                : "Yeni bir diyet planı için diyetisyeninizle iletişime geçin",
            style: AppTextStyles.body2Regular.copyWith(color: AppColor.greyLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}