import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/color.dart';
import '../../core/theme/textstyle.dart';

class ProfileErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ProfileErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingNormalHorizontal * 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 60,
            ),
            SizedBox(height: 20),
            Text(
              "Bir Sorun Oluştu",
              style: AppTextStyles.heading2.copyWith(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              errorMessage,
              style: AppTextStyles.body1Medium.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh, size: 20),
              label: Text("Tekrar Dene"),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ).animate().fade().slideY(
          begin: 0.2, 
          duration: 400.ms, 
          curve: Curves.easeOut
        ),
      ),
    );
  }
}