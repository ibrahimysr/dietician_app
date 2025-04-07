import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DietitianDetailsErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const DietitianDetailsErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: AppColor.greyLight),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              "Tekrar Dene",
              style: AppTextStyles.body2Medium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }
}