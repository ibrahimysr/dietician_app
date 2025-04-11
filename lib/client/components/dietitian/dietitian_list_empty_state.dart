import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DietitianListEmptyState extends StatelessWidget {
  final String message;

  const DietitianListEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: AppColor.greyLight),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}