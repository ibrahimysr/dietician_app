// screens/goal/all_goals_screen.dart (Yeni dosya)

import 'package:dietician_app/screens/goal/add_edit_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/models/goal_model.dart';
import 'package:dietician_app/services/goal/goal_service.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:intl/intl.dart'; // Tarih formatlama
// import 'package:dietician_app/screens/goal/add_edit_goal_screen.dart'; // Henüz oluşturmadık ama gerekecek

class AllGoalsScreen extends StatefulWidget {
  const AllGoalsScreen({super.key});

  @override
  State<AllGoalsScreen> createState() => _AllGoalsScreenState();
}

class _AllGoalsScreenState extends State<AllGoalsScreen> {
  final GoalService _goalService = GoalService();
  List<Goal> _allGoals = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _clientId;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchClientId();
    if (_clientId != null) {
      await _fetchGoals();
    }
  }

   Future<void> _fetchClientId() async {
     final id = await AuthStorage.getId();
     if (!mounted) return;
     setState(() { _clientId = id; });
     if (id == null) {
       _errorMessage = "Kullanıcı kimliği alınamadı.";
       _isLoading = false;
     }
   }

  Future<void> _fetchGoals() async {
    if (_clientId == null || !mounted) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bulunamadı.");

      final response = await _goalService.getGoals(token: token, clientId: _clientId!);

      if (!mounted) return;
      if (response.success) {
        _allGoals = response.data;
        // Hedefleri durum veya tarihe göre sıralayabiliriz
        _allGoals.sort((a, b) {
           int statusCompare = _goalStatusOrder(a.status).compareTo(_goalStatusOrder(b.status));
           if(statusCompare != 0) return statusCompare;
           // Aynı statüdeyse hedef tarihe göre (varsa, en yakın olan üste)
           return (a.targetDate ?? DateTime(9999)).compareTo(b.targetDate ?? DateTime(9999));
        });
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      if (!mounted) return;
      _errorMessage = "Hedefler yüklenirken hata: ${e.toString()}";
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  // Sıralama için yardımcı
  int _goalStatusOrder(String status){
     switch(status.toLowerCase()){
        case 'in_progress': return 0;
        case 'pending': return 1; // veya 'not_started'
        case 'completed': return 2;
        case 'failed': return 3;
        case 'cancelled': return 4;
        default: return 5;
     }
  }


  // --- Silme İşlemi ---
  Future<void> _handleDeleteGoal(int goalId, int index) async {
     final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Kaydı Sil"),
          content: Text("Bu yemek kaydını silmek istediğinizden emin misiniz? Bu işlem geri alınamaz."),
          actions: <Widget>[
            TextButton(
              child: Text("İptal", style: TextStyle(color: AppColor.greyLight)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text("Sil", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );
     if (confirmed != true) return;

     // Yükleniyor...
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hedef siliniyor...')));

     try {
        final token = await AuthStorage.getToken();
        if(token == null) throw Exception("Oturum yok");
        final response = await _goalService.deleteGoal(token: token, goalId: goalId);
         if (!mounted) return;
         if(response.success){
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.green));
             setState(() { _allGoals.removeAt(index); });
         } else {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.red));
         }
     } catch (e) {
         if (!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hedef silinirken hata: $e'), backgroundColor: Colors.red));
     }
  }

  // --- Yeni Hedef Ekleme/Düzenleme Ekranına Gitme ---
  void _navigateToAddEditGoal({Goal? goal}) async {
     final result = await Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => AddEditGoalScreen(goal: goal), // Bu ekranı oluşturmamız lazım
       ),
     );
     // Eğer ekleme/düzenleme başarılıysa listeyi yenile
     if (result == true && mounted) {
        _fetchGoals();
     }
     
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text("Tüm Hedefler", style: AppTextStyles.heading3),
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            tooltip: "Yeni Hedef Ekle",
            onPressed: () => _navigateToAddEditGoal(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchGoals,
        color: AppColor.primary,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: AppColor.primary))
            : _errorMessage != null
                ? Center(child: Text("Hata: $_errorMessage"))
                : _allGoals.isEmpty
                    ? Center(
                        child: Text(
                          "Henüz hiç hedef oluşturulmamış.",
                          style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
                        ),
                      )
                    : ListView.builder(
                        padding: context.paddingNormal,
                        itemCount: _allGoals.length,
                        itemBuilder: (context, index) {
                          final goal = _allGoals[index];
                          // Ana ekrandakine benzer bir kart kullanalım ama daha fazla detay ve aksiyon içerebilir
                          return _buildDetailedGoalItem(goal, index);
                        },
                      ),
      ),
    );
  }

  // Tüm hedefler ekranı için daha detaylı kart
  Widget _buildDetailedGoalItem(Goal goal, int index) {
    double progress = goal.calculatedProgress;
    Color progressColor = _getStatusColor(goal.status); // Status'e göre renk
    String statusText = _getStatusText(goal.status);

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: context.getDynamicHeight(1.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell( // Tıklanınca düzenlemeye gitsin
        onTap: () => _navigateToAddEditGoal(goal: goal),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_getGoalCategoryIcon(goal.category), color: AppColor.secondary, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                     child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                          Text(goal.title, style: AppTextStyles.heading4.copyWith(fontSize: 17)),
                           if(goal.description != null && goal.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(goal.description!, style: AppTextStyles.body2Regular.copyWith(color: AppColor.greyLight)),
                              ),
                       ],
                     ),
                   ),
                   // Durum ve Silme Butonu
                   Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                          Container(
                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                             decoration: BoxDecoration(
                                color: progressColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                             ),
                             child: Text(statusText, style: AppTextStyles.body1Medium.copyWith(color: progressColor, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 5),
                          IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              tooltip: "Hedefi Sil",
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () => _handleDeleteGoal(goal.id, index),
                          )
                      ],
                   )
                ],
              ),
              SizedBox(height: 12),
              // İlerleme (Sadece in_progress ise göster)
              if(goal.status.toLowerCase() == 'in_progress' && goal.targetValue != null && goal.targetValue! > 0) ...[
                  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                        Text(
                          "${goal.currentValue?.toStringAsFixed(0) ?? '-'} / ${goal.targetValue?.toStringAsFixed(0) ?? '-'} ${goal.unit ?? ''}",
                          style: AppTextStyles.body1Regular,
                        ),
                        Text("${(progress * 100).toStringAsFixed(0)}%", style: AppTextStyles.body1Medium.copyWith(color: progressColor)),
                     ],
                  ),
                  SizedBox(height: 6),
                  ClipRRect(
                     borderRadius: BorderRadius.circular(5),
                     child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                        backgroundColor: progressColor.withOpacity(0.2),
                     ),
                  ),
              ],
              SizedBox(height: 8),
               // Tarihler
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     if(goal.startDate != null) Text("Başl: ${formatDate(goal.startDate!, format: 'dd MMM yy')}", style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight)),
                     if(goal.targetDate != null) Text("Hedef: ${formatDate(goal.targetDate!, format: 'dd MMM yy')}", style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight)),
                  ],
               )
            ],
          ),
        ),
      ),
    );
  }

  // Helper metotlar (Kategori ikonu, durum rengi, durum metni)
   IconData _getGoalCategoryIcon(String category) {
     // API'den gelen category değerlerine göre ikon döndür
     switch (category.toLowerCase()) {
       case 'weight': return Icons.monitor_weight_outlined;
       case 'habit': return Icons.directions_run; // Veya steps vs.
       case 'nutrition': return Icons.restaurant_menu;
       case 'measurement': return Icons.straighten; // Bel çevresi vs.
       default: return Icons.flag_outlined;
     }
   }

   Color _getStatusColor(String status) {
      switch(status.toLowerCase()){
        case 'in_progress': return AppColor.primary;
        case 'pending': return Colors.orange.shade700;
        case 'completed': return Colors.green.shade600;
        case 'failed': return Colors.redAccent;
        case 'cancelled': return AppColor.greyLight!;
        default: return AppColor.greyLight!;
     }
   }

    String _getStatusText(String status) {
      switch(status.toLowerCase()){
        case 'in_progress': return "Devam Ediyor";
        case 'pending': return "Beklemede";
        case 'completed': return "Tamamlandı";
        case 'failed': return "Başarısız";
        case 'cancelled': return "İptal Edildi";
        default: return status; // Bilinmeyen durumu olduğu gibi göster
     }
   }

}