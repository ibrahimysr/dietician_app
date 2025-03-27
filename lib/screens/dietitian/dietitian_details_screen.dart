import 'dart:developer';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/subscription_plans_model.dart';
import 'package:flutter/material.dart';


import 'package:dietician_app/components/setting/profile_error_widget.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/models/dietitian_model.dart';
import 'package:dietician_app/services/dietian/dietitians_servici.dart';

class DietitianDetailScreen extends StatefulWidget {
  final int dietitianId;

  const DietitianDetailScreen({required this.dietitianId, super.key});

  @override
  State<DietitianDetailScreen> createState() => _DietitianDetailScreenState();
}

class _DietitianDetailScreenState extends State<DietitianDetailScreen> {
  late Future<SingleDietitianResponse> _detailFuture;
  final DietitiansService _dietitianService = DietitiansService();

  @override
  void initState() {
    super.initState();
    _detailFuture = _fetchDietitianDetails();
  }

  Future<SingleDietitianResponse> _fetchDietitianDetails() async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Oturum bulunamadı, lütfen giriş yapın.");
      }
      if (widget.dietitianId <= 0) {
         throw Exception("Geçersiz Diyetisyen ID'si.");
      }
      return await _dietitianService.getDietitian(id: widget.dietitianId, token: token);
    } catch (e) {
      log("Error fetching dietitian details (ID: ${widget.dietitianId}): $e");
      throw Exception("Diyetisyen detayları yüklenirken bir hata oluştu.");
    }
  }

 String _displayValue(String? value, {String defaultValue = "Belirtilmemiş"}) {
    return (value == null || value.isEmpty) ? defaultValue : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: AppColor.white.withOpacity(0.7),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.primary, size: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<SingleDietitianResponse>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primary, strokeWidth: 3),
            );
          }
          else if (snapshot.hasError) {
            return MyErrorWidget(
              errorMessage: snapshot.error.toString().replaceFirst("Exception: ", ""),
              onRetry: () => setState(() {
                _detailFuture = _fetchDietitianDetails();
              }),
            );
          }
          else if (snapshot.hasData) {
            final response = snapshot.data!;
             if (response.success && response.data != null) {
                final dietitian = response.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(dietitian),
                      _buildAboutSection(dietitian),
                      _buildStatsSection(dietitian),
                       if (dietitian.subscriptionPlans.isNotEmpty)
                         _buildSubscriptionPlansSection(dietitian.subscriptionPlans),
                      _buildContactButton(dietitian),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
             } else {
                 return MyErrorWidget(
                   errorMessage: response.message.isNotEmpty ? response.message : "Diyetisyen detayı alınamadı.",
                   onRetry: () => setState(() {
                      _detailFuture = _fetchDietitianDetails();
                   }),
                 );
             }
          }
          return MyErrorWidget(
             errorMessage: "Bir şeyler ters gitti.",
             onRetry: () => setState(() {
                _detailFuture = _fetchDietitianDetails();
             }),
          );
        },
      ),
    );
  }


  Widget _buildHeaderSection(Dietitian dietitian) {
    String displayName = _displayValue(dietitian.user?.name, defaultValue: "İsim Yok");
    String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    String? profilePhotoUrl = dietitian.user?.profilePhoto;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
        left: 20,
        right: 20,
        bottom: 20 
      ),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
           BoxShadow(
             color: AppColor.primary.withOpacity(0.2), 
             blurRadius: 20,
             offset: const Offset(0, 8),
           )
        ]
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
                  style: AppTextStyles.body1Medium.copyWith(color: AppColor.white.withOpacity(0.9)), 
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

  Widget _buildAboutSection(Dietitian dietitian) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Hakkında', AppColor.black),
          const SizedBox(height: 12),
          Text(
            _displayValue(dietitian.bio, defaultValue: "Diyetisyen hakkında bilgi bulunmamaktadır."),
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.black.withOpacity(0.75), height: 1.55),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Dietitian dietitian) {
     return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
            color: AppColor.grey?.withOpacity(0.8), 
            borderRadius: BorderRadius.circular(16)
        ),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
           _buildStatItem(
              icon: Icons.workspace_premium_outlined, 
              label: "Deneyim",
              value: "${dietitian.experienceYears} Yıl",
              iconColor: AppColor.secondary,
           ),
           _buildStatItem(
              icon: Icons.price_change_outlined, 
              label: "Ücret",
              value: "${_displayValue(dietitian.hourlyRate, defaultValue: '??')} TL/Saat",
              iconColor: AppColor.primary,
           ),
         ],
       ),
     );
  }

   Widget _buildStatItem({required IconData icon, required String label, required String value, required Color iconColor}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.body1Medium.copyWith(color: AppColor.black)),
          const SizedBox(height: 3),
          Text(label, style: AppTextStyles.body2Regular.copyWith(color: AppColor.black.withOpacity(0.65))),
        ],
      );
   }

  Widget _buildSubscriptionPlansSection(List<SubscriptionPlansModel> plans) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,        children: [
          _buildSectionTitle('Abonelik Planları ', AppColor.black), 
          ListView.builder(
             shrinkWrap: true,
            padding:EdgeInsets.zero,
             physics: const NeverScrollableScrollPhysics(),
             itemCount: plans.length,
             itemBuilder: (context, index) => _buildPlanCard(plans[index]),
           )
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlansModel plan ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: AppColor.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Expanded( 
                  child: Text(
                    _displayValue(plan.name, defaultValue: "İsimsiz Plan"),
                    style: AppTextStyles.heading4.copyWith(color: AppColor.secondary),
                  ),
                ),
                const SizedBox(width: 10), 
                 Text(
                  "${_displayValue(plan.price, defaultValue: '??')} TL",
                  style: AppTextStyles.heading4.copyWith(color: AppColor.primary),
                ),
              ],
            ),
            const SizedBox(height: 6),
             Text(
              "${plan.duration} Günlük Plan",
              style: AppTextStyles.body2Regular.copyWith(color: AppColor.greyLight),
            ),
            const SizedBox(height: 12),
             Text(
              _displayValue(plan.description, defaultValue: "Açıklama yok."),
              style: AppTextStyles.body2Regular.copyWith(color: AppColor.black.withOpacity(0.7)),
            ),
            if (plan.features.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                 spacing: 8.0,
                 runSpacing: 6.0, 
                 children: plan.features.map((feature) => Chip(
                    avatar: Icon(Icons.check, size: 16, color: AppColor.secondary.withOpacity(0.8)), 
                    label: Text(feature, style: AppTextStyles.body2Regular.copyWith(color: AppColor.black.withOpacity(0.85))), 
                    backgroundColor: AppColor.secondary.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), 
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(horizontal: 0.0, vertical: -2),
                 )).toList(),
              )
            ]
          ],
        ),
      ),
    );
  }


  Widget _buildContactButton(Dietitian dietitian) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0), 
        child: ElevatedButton.icon(
            icon: Icon(Icons.outgoing_mail, color: AppColor.white), 
            label: Text('İletişime Geç', style: AppTextStyles.buttonText.copyWith(color: AppColor.white)),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
                elevation: 4, 
                shadowColor: AppColor.secondary.withOpacity(0.4)
            ),
            onPressed: () {
               log("İletişime Geç butonuna tıklandı: ${dietitian.user?.name}");
            },
        ),
      );
   }



  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(color: color),
    );
  }

}