import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class DetailsSectionHeader extends StatelessWidget {
  final String title;

  const DetailsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: AppTextStyles.heading3.copyWith(color: AppColor.black),
      ),
    );
  }
}