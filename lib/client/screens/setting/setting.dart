import 'dart:developer';
import 'package:dietician_app/client/components/setting/profile_app_bar.dart';
import 'package:dietician_app/client/components/setting/profile_error_widget.dart';
import 'package:dietician_app/client/components/setting/profile_info_card.dart';
import 'package:dietician_app/client/components/setting/profile_info_tile.dart';
import 'package:dietician_app/client/components/setting/loading_indicator.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/theme/color.dart';
import '../../core/utils/auth_storage.dart';
import '../../models/client_model.dart';
import '../../services/auth/client_service.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ClientResponse> _clientFuture;
  final ClientService _clientService = ClientService();

  @override
  void initState() {
    super.initState();
    _clientFuture = _fetchClientData();
  }

  Future<ClientResponse> _fetchClientData() async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        throw Exception("Oturum bulunamadı, lütfen giriş yapın.");
      }
      final int? clientId = await AuthStorage.getId();
      if (clientId == null || clientId == 0) {
        throw Exception("Kullanıcı ID bulunamadı.");
      }

      return await _clientService.getClient(userId: clientId, token: token);
    } catch (e) {
      log("Error: $e");
      throw Exception("Profil bilgileri yüklenirken bir hata oluştu: ${e.toString().replaceFirst("Exception: ", "")}");
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "Belirtilmemiş";
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy', 'tr_TR').format(date);
    } catch (e) {
      return dateString; 
    }
  }

  String _displayValue(String? value) {
    return (value == null || value.isEmpty) ? "Belirtilmemiş" : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white, 
      body: FutureBuilder<ClientResponse>(
        future: _clientFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          } else if (snapshot.hasError) {
            return MyErrorWidget(
              errorMessage: snapshot.error.toString(),
              onRetry: () => setState(() {
                _clientFuture = _fetchClientData();
              }),
            );
          } else if (snapshot.hasData && snapshot.data?.data != null) {
            final clientData = snapshot.data!.data;
            return _buildProfileContent(context, clientData);
          }
          return MyErrorWidget(
            errorMessage: "Profil bilgileri alınamadı.",
            onRetry: () => setState(() {
              _clientFuture = _fetchClientData();
            }),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ClientData clientData) {
    final cardDelay = 100.ms;

    return CustomScrollView(
      slivers: [
        ProfileAppBar(clientData: clientData),
        SliverPadding(
          padding: EdgeInsets.all(context.lowValue), 
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                ProfileInfoCard(
                  title: "Kişisel Bilgiler",
                  icon: FontAwesomeIcons.solidUser,
                  delay: cardDelay * 1,
                  children: [
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.venusMars,
                      label: "Cinsiyet",
                      value: _displayValue(clientData.gender),
                    ),
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.solidCalendarDays,
                      label: "Doğum Tarihi",
                      value: _formatDate(clientData.birthDate),
                    ),
                  ],
                ),
                ProfileInfoCard(
                  title: "Fiziksel Durum",
                  icon: FontAwesomeIcons.rulerVertical,
                  delay: cardDelay * 2,
                  children: [
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.arrowsUpDown,
                      label: "Boy",
                      value: "${_displayValue(clientData.height)} cm",
                    ),
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.weightScale,
                      label: "Kilo",
                      value: "${_displayValue(clientData.weight)} kg",
                    ),
                  ],
                ),
                ProfileInfoCard(
                  title: "Yaşam Tarzı & Hedefler",
                  icon: FontAwesomeIcons.personRunning,
                  delay: cardDelay * 3,
                  children: [
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.bolt,
                      label: "Aktiflik Seviyesi",
                      value: _displayValue(clientData.activityLevel),
                    ),
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.bullseye,
                      label: "Hedef",
                      value: _displayValue(clientData.goal),
                    ),
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.utensils,
                      label: "Beslenme Tercihi",
                      value: _displayValue(clientData.preferences),
                    ),
                  ],
                ),
                ProfileInfoCard(
                  title: "Sağlık Bilgileri",
                  icon: FontAwesomeIcons.notesMedical,
                  delay: cardDelay * 4,
                  children: [
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.breadSlice, 
                      label: "Alerji",
                      value: _displayValue(clientData.allergies),
                    ),
                    ProfileInfoTile(
                      icon: FontAwesomeIcons.heartPulse, 
                      label: "Hastalık",
                      value: _displayValue(clientData.medicalConditions),
                    ),
                  ],
                ),
                //ProfileActionCard(delay: cardDelay * 5),
                SizedBox(height: context.normalValue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}