import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/color.dart';
import '../../core/theme/textstyle.dart';

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero, 
      dense: true,
      leading: FaIcon(icon, size: 20, color: AppColor.secondary),
      title: Text(
        label, 
        style: AppTextStyles.body1Medium.copyWith(color: AppColor.black)
      ),
      trailing: Text(
        value,
        style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
        textAlign: TextAlign.right,
      ),
    );
  }
}