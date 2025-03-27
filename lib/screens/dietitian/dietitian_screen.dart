import 'dart:developer';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:dietician_app/components/setting/profile_error_widget.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/models/dietitian_model.dart';
import 'package:dietician_app/services/dietian/dietitians_servici.dart';
import 'package:dietician_app/screens/dietitian/dietitian_details_screen.dart';

class DietitianListScreen extends StatefulWidget {
  const DietitianListScreen({super.key});

  @override
  State<DietitianListScreen> createState() => _DietitianListScreenState();
}

class _DietitianListScreenState extends State<DietitianListScreen> {
  late Future<DietitianResponse> _dietitiansFuture;
  final DietitiansService _dietitianService = DietitiansService();

  @override
  void initState() {
    super.initState();
    _dietitiansFuture = _fetchDietitiansList();
  }

  Future<DietitianResponse> _fetchDietitiansList() async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Oturum bulunamadı, lütfen giriş yapın.");
      }
      return await _dietitianService.getDietitiansList(token: token);
    } catch (e) {
      log("Error in _fetchDietitiansList: $e");
      throw Exception(
          "Diyetisyenler yüklenirken bir sorun oluştu. Lütfen tekrar deneyin.");
    }
  }

  void _navigateToDetail(int dietitianId) {
    if (dietitianId > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DietitianDetailScreen(dietitianId: dietitianId),
        ),
      );
    } else {
      log("Geçersiz dietitianId: $dietitianId");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Diyetisyen detayı açılamadı.",
              style:
                  AppTextStyles.body2Regular.copyWith(color: AppColor.white)),
          backgroundColor: AppColor.primary,
        ),
      );
    }
  }

  String _displayValue(String? value, {String defaultValue = "Belirtilmemiş"}) {
    return (value == null || value.isEmpty) ? defaultValue : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diyetisyenleri Keşfet',
          style: AppTextStyles.heading3.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 3,
        shadowColor: AppColor.primary.withOpacity(0.3),
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.white, AppColor.grey!.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<DietitianResponse>(
          future: _dietitiansFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.primary,
                  strokeWidth: 3,
                ),
              );
            } else if (snapshot.hasError) {
              return MyErrorWidget(
                errorMessage:
                    snapshot.error.toString().replaceFirst("Exception: ", ""),
                onRetry: () => setState(() {
                  _dietitiansFuture = _fetchDietitiansList();
                }),
              );
            } else if (snapshot.hasData) {
              final response = snapshot.data!;
              if (response.success && response.data.isNotEmpty) {
                final dietitiansList = response.data;

                return AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: dietitiansList.length,
                    itemBuilder: (context, index) {
                      final dietitian = dietitiansList[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 450),
                        child: SlideAnimation(
                          verticalOffset: 60.0,
                          child: FadeInAnimation(
                            child: _buildEnhancedDietitianCard(dietitian),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (response.success && response.data.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 60, color: AppColor.greyLight),
                    const SizedBox(height: 16),
                    Text(
                      response.message.isNotEmpty
                          ? response.message
                          : 'Uygun diyetisyen bulunamadı.',
                      style: AppTextStyles.body1Regular
                          .copyWith(color: AppColor.greyLight),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ));
              } else {
                return MyErrorWidget(
                  errorMessage: response.message.isNotEmpty
                      ? response.message
                      : "Diyetisyen listesi alınamadı.",
                  onRetry: () => setState(() {
                    _dietitiansFuture = _fetchDietitiansList();
                  }),
                );
              }
            }
            return MyErrorWidget(
              errorMessage: "Bir şeyler ters gitti. Lütfen tekrar deneyin.",
              onRetry: () => setState(() {
                _dietitiansFuture = _fetchDietitiansList();
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedDietitianCard(Dietitian dietitian) {
    String displayName =
        _displayValue(dietitian.user?.name, defaultValue: "İsim Yok");
    String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    String? profilePhotoUrl = dietitian.user?.profilePhoto;

    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      elevation: 5,
      shadowColor: AppColor.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetail(dietitian.id),
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
                    backgroundColor: AppColor.secondary.withOpacity(0.1),
                    backgroundImage:
                        (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
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
                            style: AppTextStyles.heading3
                                .copyWith(color: AppColor.secondary),
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
                          style: AppTextStyles.heading4
                              .copyWith(color: AppColor.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _displayValue(dietitian.specialty),
                          style: AppTextStyles.body2Medium
                              .copyWith(color: AppColor.secondary),
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
              color: AppColor.grey?.withOpacity(0.8),
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    icon: Icons.star_border_rounded,
                    text: "${dietitian.experienceYears} Yıl Deneyim",
                    iconColor: Colors.orangeAccent,
                    textColor: AppColor.black.withOpacity(0.7),
                  ),
                  _buildInfoChip(
                    icon: Icons.payments_outlined,
                    text:
                        "${_displayValue(dietitian.hourlyRate, defaultValue: '??')} TL/Saat",
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

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color iconColor,
    required Color textColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: isBold
              ? AppTextStyles.body2Medium.copyWith(color: textColor)
              : AppTextStyles.body2Regular.copyWith(color: textColor),
        ),
      ],
    );
  }
}
