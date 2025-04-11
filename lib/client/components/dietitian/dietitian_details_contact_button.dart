import 'dart:developer';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/dietitian_model.dart';
import 'package:flutter/material.dart';

class DietitianDetailsContactButton extends StatelessWidget {
  final Dietitian dietitian;

  const DietitianDetailsContactButton({super.key, required this.dietitian});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
      child: ElevatedButton.icon(
        icon: Icon(Icons.outgoing_mail, color: AppColor.white),
        label: Text(
          'İletişime Geç',
          style: AppTextStyles.buttonText.copyWith(color: AppColor.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: AppColor.secondary.withValues(alpha: 0.4),
        ),
        onPressed: () {
          log("İletişime Geç butonuna tıklandı: ${dietitian.user?.name}");
        },
      ),
    );
  }
}