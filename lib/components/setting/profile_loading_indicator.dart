import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/color.dart';

class ProfileLoadingIndicator extends StatelessWidget {
  const ProfileLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColor.primary,
        strokeWidth: 3,
      ).animate().fade(duration: 300.ms).scale(delay: 100.ms),
    );
  }
}