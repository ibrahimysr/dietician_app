import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/color.dart';
import '../../core/theme/textstyle.dart';

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Duration delay;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: context.normalValue), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: AppColor.white,
      child: Padding(
        padding: context.paddingNormal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, size: 18, color: AppColor.primary),
                SizedBox(width: context.lowValue),
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.black
                  ),
                ),
              ],
            ),
            Divider(
              height: context.normalValue, 
              thickness: 1, 
              color: AppColor.greyLight
            ),
            ...children,
          ],
        ),
      ),
    ).animate(delay: delay).fadeIn(duration: 400.ms).slideY(
      begin: 0.1, 
      curve: Curves.easeOut
    );
  }
}