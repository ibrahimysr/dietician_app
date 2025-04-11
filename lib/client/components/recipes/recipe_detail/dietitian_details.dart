import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/dietitian_model.dart';
import 'package:flutter/material.dart';



class DietitianDetails extends StatelessWidget {
  final Dietitian dietitian;

  const DietitianDetails({super.key, required this.dietitian});

  @override
  Widget build(BuildContext context) {
    final user = dietitian.user;
    final profileImageUrl = user?.profilePhoto;
    final hasImage = profileImageUrl != null && profileImageUrl.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha:0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColor.greyLight,
              backgroundImage: hasImage ? NetworkImage(profileImageUrl) : null,
              child: !hasImage
                  ? Icon(Icons.person, size: 35, color: AppColor.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Diyetisyen',
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dietitian.bio,
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColor.black,
                    ),
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