import 'package:dietician_app/components/dietitian/dietitian_details_section_title.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/dietitian_model.dart';
import 'package:flutter/material.dart';

class DietitianDetailsAboutSection extends StatelessWidget {
  final Dietitian dietitian;

  const DietitianDetailsAboutSection({super.key, required this.dietitian});

  String _displayValue(String? value, {String defaultValue = "Belirtilmemiş"}) {
    return (value == null || value.isEmpty) ? defaultValue : value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DietitianDetailsSectionTitle(title: 'Hakkında', color: AppColor.black),
          const SizedBox(height: 12),
          Text(
            _displayValue(dietitian.bio, defaultValue: "Diyetisyen hakkında bilgi bulunmamaktadır."),
            style: AppTextStyles.body1Regular.copyWith(
              color: AppColor.black.withValues(alpha: 0.75),
              height: 1.55,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}