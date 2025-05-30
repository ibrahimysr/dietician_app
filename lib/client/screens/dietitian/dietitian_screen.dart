import 'dart:developer';
import 'package:dietician_app/client/components/dietitian/dietitian_list_card.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_list_empty_state.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_list_error_widget.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/dietitian_model.dart';
import 'package:dietician_app/client/screens/dietitian/dietitian_details_screen.dart';
import 'package:dietician_app/client/services/dietian/dietitians_servici.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DietitianListScreen extends StatefulWidget {
  const DietitianListScreen({super.key});

  @override
  State<DietitianListScreen> createState() => _DietitianListScreenState();
}

class _DietitianListScreenState extends State<DietitianListScreen> with TickerProviderStateMixin {
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
          content: Text(
            "Diyetisyen detayı açılamadı.",
            style: AppTextStyles.body2Regular.copyWith(color: AppColor.white),
          ),
          backgroundColor: AppColor.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar:CustomAppBar(title: "Diyetisyenleri Keşfet"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.white, AppColor.grey.withValues(alpha: 0.3)],
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
              return DietitianListErrorWidget(
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
                            child: DietitianListCard(
                              dietitian: dietitian,
                              onTap: () => _navigateToDetail(dietitian.id),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (response.success && response.data.isEmpty) {
                return DietitianListEmptyState(
                  message: response.message.isNotEmpty
                      ? response.message
                      : 'Uygun diyetisyen bulunamadı.',
                );
              } else {
                return DietitianListErrorWidget(
                  errorMessage: response.message.isNotEmpty
                      ? response.message
                      : "Diyetisyen listesi alınamadı.",
                  onRetry: () => setState(() {
                    _dietitiansFuture = _fetchDietitiansList();
                  }),
                );
              }
            }
            return DietitianListErrorWidget(
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
}
