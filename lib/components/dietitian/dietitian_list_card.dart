import 'dart:developer';
import 'package:dietician_app/components/dietitian/dietitian_list_info_chip.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/dietitian_model.dart';
import 'package:flutter/material.dart';

class DietitianListCard extends StatelessWidget {
  final Dietitian dietitian;
  final VoidCallback onTap;

  const DietitianListCard({
    super.key,
    required this.dietitian,
    required this.onTap,
  });

  String _displayValue(String? value, {String defaultValue = "Belirtilmemiş"}) {
    return (value == null || value.isEmpty) ? defaultValue : value;
  }

  @override
  Widget build(BuildContext context) {
    String displayName = _displayValue(dietitian.user?.name, defaultValue: "İsim Yok");
    String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    String? profilePhotoUrl = dietitian.user?.profilePhoto;

    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      elevation: 5,
      shadowColor: AppColor.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColor.secondary.withValues(alpha: 0.1),
                    backgroundImage: (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
                        ? NetworkImage(profilePhotoUrl)
                        : null,
                    onBackgroundImageError: profilePhotoUrl != null
                        ? (exception, stackTrace) {
                            log("Profil resmi yüklenemedi: $profilePhotoUrl, Hata: $exception");
                          }
                        : null,
                    child: (profilePhotoUrl == null || profilePhotoUrl.isEmpty)
                        ? Text(
                            initial,
                            style: AppTextStyles.heading3.copyWith(color: AppColor.secondary),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: AppTextStyles.heading4.copyWith(color: AppColor.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _displayValue(dietitian.specialty),
                          style: AppTextStyles.body2Medium.copyWith(color: AppColor.secondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppColor.grey?.withValues(alpha: 0.8),
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DietitianListInfoChip(
                    icon: Icons.star_border_rounded,
                    text: "${dietitian.experienceYears} Yıl Deneyim",
                    iconColor: Colors.orangeAccent,
                    textColor: AppColor.black.withValues(alpha: 0.7),
                  ),
                  DietitianListInfoChip(
                    icon: Icons.payments_outlined,
                    text: "${_displayValue(dietitian.hourlyRate, defaultValue: '??')} TL/Saat",
                    iconColor: AppColor.primary,
                    textColor: AppColor.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}