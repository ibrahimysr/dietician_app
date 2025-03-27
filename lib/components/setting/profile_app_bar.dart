import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/color.dart';
import '../../core/theme/textstyle.dart';
import '../../models/Client.dart';

class ProfileAppBar extends StatelessWidget {
  final ClientData clientData;

  const ProfileAppBar({super.key, required this.clientData});

  @override
  Widget build(BuildContext context) {
    String? profileImageUrl = clientData.user?.profilePhoto;
    String displayName = clientData.user?.name ?? "Kullanıcı";
    String displayEmail = clientData.user?.email ?? "";

    return SliverAppBar(
      expandedHeight: 280.0,
      floating: true,
      pinned: true,
      snap: false,
      backgroundColor: AppColor.primary,
      elevation: 2.0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColor.white),
      actions: [
        IconButton(
          icon: Icon(Icons.edit_outlined, color: AppColor.white),
          tooltip: "Profili Düzenle",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Profili Düzenle'ye Gidiliyor...")),
            );
          },
        ),
        SizedBox(width: context.lowValue),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.symmetric(
            horizontal: context.normalValue, vertical: context.lowValue),
        title: Text(
          displayName,
          style: AppTextStyles.heading4.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 2, color: Colors.black38)]),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.primary,
                AppColor.primary.withOpacity(0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: kToolbarHeight / 2),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: AppColor.white.withOpacity(0.9),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColor.greyLight,
                    backgroundImage:
                        (profileImageUrl != null && profileImageUrl.isNotEmpty)
                            ? CachedNetworkImageProvider(profileImageUrl)
                            : null,
                    child: (profileImageUrl == null || profileImageUrl.isEmpty)
                        ? Icon(
                            Icons.person_outline,
                            size: 60,
                            color: AppColor.primary.withOpacity(0.8),
                          )
                        : null,
                  ),
                ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                SizedBox(height: context.lowValue),
                Text(
                  displayName,
                  style: AppTextStyles.heading2.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 2, color: Colors.black38)]),
                ),
                SizedBox(height: context.lowValue * 0.5),
                if (displayEmail.isNotEmpty)
                  Text(
                    displayEmail,
                    style: AppTextStyles.body1Medium.copyWith(
                        color: AppColor.white.withOpacity(0.85),
                        shadows: [
                          Shadow(blurRadius: 1, color: Colors.black26)
                        ]),
                  ),
                SizedBox(height: context.normalValue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
