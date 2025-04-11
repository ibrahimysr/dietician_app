import 'dart:developer';
import 'package:dietician_app/client/components/dietitian/dietitian_details_about_section.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_contact_button.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_error_widget.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_header_section.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_stats_section.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_subscription_plans.dart';

import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/dietitian_model.dart';
import 'package:dietician_app/client/services/auth/client_service.dart';
import 'package:dietician_app/client/services/dietian/dietitians_servici.dart';
import 'package:flutter/material.dart';

class DietitianDetailScreen extends StatefulWidget {
  final int dietitianId;

  const DietitianDetailScreen({required this.dietitianId, super.key});

  @override
  State<DietitianDetailScreen> createState() => _DietitianDetailScreenState();
}

class _DietitianDetailScreenState extends State<DietitianDetailScreen> {
  late Future<SingleDietitianResponse> _detailFuture;
  final DietitiansService _dietitianService = DietitiansService(); 

   final ClientService _clientService = ClientService();
  bool _isUpdatingDietitian = false;

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
      return await _dietitianService.getDietitian(
          id: widget.dietitianId, token: token);
    } catch (e) {
      log("Error fetching dietitian details (ID: ${widget.dietitianId}): $e");
      throw Exception("Diyetisyen detayları yüklenirken bir hata oluştu.");
    }
  } 

 Future<void> _handleSelectDietitian() async {
    if (_isUpdatingDietitian) return;

    setState(() {
      _isUpdatingDietitian = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diyetisyen seçiliyor...'), duration: Duration(seconds: 3)), 
    );

    try {
      final token = await AuthStorage.getToken();
      final clientId = await AuthStorage.getClientId(); 

      if (token == null || token.isEmpty) {
        throw Exception("Oturumunuz bulunamadı. Lütfen tekrar giriş yapın.");
      }
      if (clientId == null) {
        throw Exception("Kullanıcı kimliği bulunamadı. Lütfen tekrar giriş yapın.");
      }

      
     
      final Map<String, dynamic> updateData = {
        "dietitian_id": widget.dietitianId, 
      };

    
      final updateResponse = await _clientService.updateDietitian(
        token: token,
        clientId: clientId,
        updateData: updateData,
      );

      if (updateResponse.success) {
        log("Danışan diyetisyeni başarıyla güncellendi!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Diyetisyen başarıyla seçildi!"),
            backgroundColor: Colors.green,
          ),
        );
       
      } else {
        log('Güncelleme başarısız: ${updateResponse.message}');
        throw Exception(updateResponse.message.isNotEmpty
            ? updateResponse.message 
            : "Diyetisyen ataması güncellenemedi.");
      }
    } catch (e) {
      log("Diyetisyen seçme hatası: $e");
      String errorMessage = "Bilinmeyen bir hata oluştu.";
       if (e is Exception) {
         errorMessage = e.toString().replaceFirst("Exception: ", "");
         if (errorMessage.contains("Danışan bilgileri alınamadı")) {
         } else if (errorMessage.contains("No query results for model")) {
           errorMessage = "İşlem sırasında bir sorun oluştu. Lütfen tekrar deneyin veya destek ile iletişime geçin.";
         } else if (errorMessage.contains("Danışan kaydı ID'si alınamadı")) {
             errorMessage = "Danışan kaydınızda bir sorun var gibi görünüyor. Lütfen destek ile iletişime geçin.";
         } else if (errorMessage.contains("Oturumunuz bulunamadı") || errorMessage.contains("Kullanıcı kimliği bulunamadı")) {
         }
         else {
            errorMessage = "İşlem sırasında bir hata oluştu. Lütfen tekrar deneyin.";
         }
       }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: $errorMessage"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
         setState(() {
           _isUpdatingDietitian = false;
         });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: AppColor.white.withValues(alpha: 0.7),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColor.primary, size: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<SingleDietitianResponse>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: AppColor.primary, strokeWidth: 3),
            );
          } else if (snapshot.hasError) {
            return DietitianDetailsErrorWidget(
              errorMessage:
                  snapshot.error.toString().replaceFirst("Exception: ", ""),
              onRetry: () => setState(() {
                _detailFuture = _fetchDietitianDetails();
              }),
            );
          } else if (snapshot.hasData) {
            final response = snapshot.data!;
            if (response.success && response.data != null) {
              final dietitian = response.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DietitianDetailsHeaderSection(dietitian: dietitian),
                    DietitianDetailsAboutSection(dietitian: dietitian),
                    DietitianDetailsStatsSection(dietitian: dietitian),
                    if (dietitian.subscriptionPlans.isNotEmpty)
                      DietitianDetailsSubscriptionPlans(
                          plans: dietitian.subscriptionPlans, 
                          
                          onSelectPlan:  _handleSelectDietitian,),
                    DietitianDetailsContactButton(dietitian: dietitian),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            } else {
              return DietitianDetailsErrorWidget(
                errorMessage: response.message.isNotEmpty
                    ? response.message
                    : "Diyetisyen detayı alınamadı.",
                onRetry: () => setState(() {
                  _detailFuture = _fetchDietitianDetails();
                }),
              );
            }
          }
          return DietitianDetailsErrorWidget(
            errorMessage: "Bir şeyler ters gitti.",
            onRetry: () => setState(() {
              _detailFuture = _fetchDietitianDetails();
            }),
          );
        },
      ),
    );
  }
}
