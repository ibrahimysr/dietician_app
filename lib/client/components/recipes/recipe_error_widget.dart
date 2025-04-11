import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class RecipeErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const RecipeErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColor.primary,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Bir şeyler ters gitti.',
              style: AppTextStyles.heading3.copyWith(color: AppColor.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh, color: AppColor.white),
              label: Text(
                'Yeniden Dene', 
                style: AppTextStyles.buttonText.copyWith(color: AppColor.white),
              ),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}