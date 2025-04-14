import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/dietitian/model/dietitian_model.dart';
import 'package:dietician_app/dietitian/service/dietitian/dietitian_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DietitianSettingScreen extends StatefulWidget {
  const DietitianSettingScreen({super.key});

  @override
  State<DietitianSettingScreen> createState() => _DietitianSettingScreenState();
}

class _DietitianSettingScreenState extends State<DietitianSettingScreen> {
  DietitianData? _dietitianData;
  bool _isLoading = true;
  String? _errorMessage;

  final DietitiansService _dietitiansService = DietitiansService();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await AuthStorage.getToken();
      final userId = await AuthStorage.getId();

      if (token == null || userId == null) {
        throw Exception(
            "Oturum bilgileri bulunamadı. Lütfen tekrar giriş yapın.");
      }

      final response = await _dietitiansService.getDietitinInformation(
        id: userId,
        token: token,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        setState(() {
          _dietitianData = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message.isNotEmpty
              ? response.message
              : "Profil bilgileri alınamadı.";
          _isLoading = false;
        });
      }
    } catch (e) {
      log("Profil verisi alınırken hata: $e");
      if (!mounted) return;
      setState(() {
        _errorMessage = "Bir hata oluştu: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Profilim"),
      backgroundColor: AppColor.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 60),
              const SizedBox(height: 15),
              Text(
                "Hata Oluştu",
                style: AppTextStyles.body1Medium
                    .copyWith(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body1Regular,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Tekrar Dene"),
                onPressed: _fetchProfileData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      );
    }

    if (_dietitianData == null) {
      return const Center(child: Text("Profil verisi bulunamadı."));
    }

    return RefreshIndicator(
      onRefresh: _fetchProfileData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(context, _dietitianData!.user),
            _buildInfoCard(context, _dietitianData!),
            const SizedBox(height: 16),
            if (_dietitianData!.bio.isNotEmpty) ...[
              _buildBioCard(context, _dietitianData!),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, DietitianUser? user) {
    final String? photoUrl = user?.profilePhoto;
    final String name = user?.name ?? 'İsim Bilgisi Yok';
    final String email = user?.email ?? 'E-posta Bilgisi Yok';

    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: AppColor.greyLight,
          backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
              ? CachedNetworkImageProvider(photoUrl)
              : null,
          child: (photoUrl == null || photoUrl.isEmpty)
              ? Icon(Icons.person_outline, size: 60, color: AppColor.grey)
              : null,
        ),
        const SizedBox(height: 16),
        Text(name,
            style:
                AppTextStyles.body1Medium.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(email,
            style: AppTextStyles.body2Regular.copyWith(color: AppColor.grey),
            textAlign: TextAlign.center),
        if (user?.phone != null && user!.phone!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_outlined, size: 16, color: AppColor.grey),
              const SizedBox(width: 4),
              Text(user.phone!,
                  style: AppTextStyles.body2Regular
                      .copyWith(color: AppColor.grey)),
            ],
          ),
        ]
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, DietitianData data) {
    return Card(
      color: AppColor.grey,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(
              icon: Icons.star_border_purple500_outlined,
              label: "Uzmanlık Alanı",
              value:
                  data.specialty.isNotEmpty ? data.specialty : "Belirtilmemiş",
            ),
            const Divider(height: 20),
            _buildInfoRow(
              icon: Icons.work_history_outlined,
              label: "Deneyim",
              value: "${data.experienceYears} Yıl",
            ),
            const Divider(height: 20),
            _buildInfoRow(
              icon: Icons.hourglass_bottom_outlined,
              label: "Saatlik Ücret",
              value: data.hourlyRate > 0
                  ? "${NumberFormat.currency(locale: 'tr_TR', symbol: '₺').format(data.hourlyRate)} / Saat"
                  : "Belirtilmemiş",
            ),
            const Divider(height: 20),
            _buildInfoRow(
              icon: data.isActive
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              label: "Hesap Durumu",
              value: data.isActive ? "Aktif" : "Pasif",
              valueColor:
                  data.isActive ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioCard(BuildContext context, DietitianData data) {
    return Card(
      elevation: 2,
      color: AppColor.grey,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 22, color: AppColor.secondary),
                const SizedBox(width: 12),
                Text("Hakkında",
                    style: AppTextStyles.body1Medium
                        .copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            Text(
              data.bio,
              style: AppTextStyles.body1Regular
                  .copyWith(height: 1.5, color: AppColor.secondary),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildInfoRow(
      {required IconData icon,
      required String label,
      required String value,
      Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColor.secondary),
        const SizedBox(width: 16),
        Text("$label:",
            style: AppTextStyles.body1Regular
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body1Regular
                .copyWith(color: valueColor ?? AppColor.secondary),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  
}
