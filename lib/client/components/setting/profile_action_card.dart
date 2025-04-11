import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/color.dart';
import '../../core/theme/textstyle.dart';

class ProfileActionCard extends StatelessWidget {
  final Duration delay;

  const ProfileActionCard({
    super.key, 
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: context.normalValue),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: AppColor.white,
      child: Column(
        children: [
          _buildActionTile(
            context,
            icon: FontAwesomeIcons.chartLine,
            label: "Diyetisyen İlerleme",
            color: Colors.blueAccent,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("İlerleme Ekranı Açılıyor...")),
              );
            },
          ),
          Divider(
            height: 1, 
            thickness: 1, 
            indent: context.normalValue, 
            endIndent: context.normalValue, 
            color: AppColor.greyLight
          ),
          _buildActionTile(
            context,
            icon: FontAwesomeIcons.calendarCheck,
            label: "Diyet Planı",
            color: Colors.green,
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Diyet Planı Açılıyor...")),
              );
            },
          ),
        ],
      ),
    ).animate(delay: delay).fadeIn(duration: 400.ms).slideY(
      begin: 0.1, 
      curve: Curves.easeOut
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: context.paddingNormal,
      leading: FaIcon(icon, color: color, size: 22),
      title: Text(
        label,
        style: AppTextStyles.heading4.copyWith(
          fontWeight: FontWeight.w500, 
          color: AppColor.black
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}