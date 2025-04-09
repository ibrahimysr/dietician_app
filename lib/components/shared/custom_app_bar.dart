import 'package:dietician_app/core/generated/asset.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar( 

      iconTheme: IconThemeData(color: AppColor.white),
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.primary, AppColor.primary.withValues(alpha:0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppColor.white,
            radius: 18,
            child: Lottie.asset(
              AppAssets.loginAnimation,
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
      centerTitle: true,
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          widget.title,
          style: AppTextStyles.heading3.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 




class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Animation<double> fadeAnimation;
  final String greeting;
  final DateTime currentDate;
  final VoidCallback onMenuPressed;
  final VoidCallback onNotificationsPressed;

  const AnimatedAppBar({
    super.key,
    required this.fadeAnimation,
    required this.greeting,
    required this.currentDate,
    required this.onMenuPressed,
    required this.onNotificationsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.primary, AppColor.primary.withValues(alpha:0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColor.white),
        onPressed: onMenuPressed,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: AppColor.white),
          onPressed: onNotificationsPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppColor.white,
            radius: 18,
            child: Lottie.asset(
              AppAssets.loginAnimation,
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
      centerTitle: false,
      title: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$greeting İbrahim 👋",
              style: AppTextStyles.heading3.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${currentDate.day}/${currentDate.month}/${currentDate.year}",
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}