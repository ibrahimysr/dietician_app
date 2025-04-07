import 'dart:developer';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/dietitian_model.dart';
import 'package:flutter/material.dart';

class DietitianDetailsHeaderSection extends StatelessWidget {
  final Dietitian dietitian;

  const DietitianDetailsHeaderSection({super.key, required this.dietitian});

  String _displayValue(String? value, {String defaultValue = "Belirtilmemiş"}) {
    return (value == null || value.isEmpty) ? defaultValue : value;
  }

  @override
  Widget build(BuildContext context) {
    String displayName = _displayValue(dietitian.user?.name, defaultValue: "İsim Yok");
    String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    String? profilePhotoUrl = dietitian.user?.profilePhoto;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: 'dietitian_avatar_${dietitian.id}',
            child: CircleAvatar(
              radius: 45,
              backgroundColor: AppColor.white,
              backgroundImage: (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
                  ? NetworkImage(profilePhotoUrl)
                  : null,
              onBackgroundImageError: profilePhotoUrl != null ? (e, s) => log("Profil resmi hatası: $e") : null,
              child: (profilePhotoUrl == null || profilePhotoUrl.isEmpty)
                  ? Text(initial, style: AppTextStyles.displayBold.copyWith(color: AppColor.primary))
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.heading2.copyWith(color: AppColor.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  _displayValue(dietitian.specialty),
                  style: AppTextStyles.body1Medium.copyWith(color: AppColor.white.withValues(alpha: 0.9)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}