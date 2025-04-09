import 'package:dietician_app/components/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/screens/goal/add_edit_goal_screen.dart';
import 'package:dietician_app/models/goal_model.dart';
import 'package:dietician_app/services/goal/goal_service.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/formatters.dart';

class AllGoalsScreen extends StatefulWidget {
  final int dietitianId;
  const AllGoalsScreen({super.key, required this.dietitianId});

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
        _allGoals.sort((a, b) {
           int statusCompare = _goalStatusOrder(a.status).compareTo(_goalStatusOrder(b.status));
           if(statusCompare != 0) return statusCompare;
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

  int _goalStatusOrder(String status){
     switch(status.toLowerCase()){
        case 'in_progress': return 0;
        case 'pending': return 1; 
        case 'completed': return 2;
        case 'failed': return 3;
        case 'cancelled': return 4;
        default: return 5;
     }
  }

  Future<void> _handleDeleteGoal(int goalId, int index) async {
     final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Hedefi Sil", style: AppTextStyles.heading3),
          content: Text(
            "Bu hedefi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.",
            style: AppTextStyles.body1Regular,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("İptal", style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: AppColor.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Sil", style: AppTextStyles.body1Medium),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );
    
     if (confirmed != true) return;

     _showSnackBar('Hedef siliniyor...', isError: false);

     try {
        final token = await AuthStorage.getToken();
        if(token == null) throw Exception("Oturum yok");
        final response = await _goalService.deleteGoal(token: token, goalId: goalId);
        
        if (!mounted) return;
        if(response.success){
          _showSnackBar(response.message, isError: false, isSuccess: true);
          setState(() { _allGoals.removeAt(index); });
        } else {
          _showSnackBar(response.message, isError: true);
        }
     } catch (e) {
        if (!mounted) return;
        _showSnackBar('Hedef silinirken hata: $e', isError: true);
     }
  }

  void _showSnackBar(String message, {bool isError = false, bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.body1Medium.copyWith(color: AppColor.white)),
        backgroundColor: isError 
            ? Colors.red 
            : isSuccess 
                ? Colors.green 
                : AppColor.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
      )
    );
  }

  void _navigateToAddEditGoal({Goal? goal}) async {
     final result = await Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => AddEditGoalScreen(goal: goal, dietitianId: widget.dietitianId),
       ),
     );
     if (result == true && mounted) {
        _fetchGoals();
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: "Hedeflerim"),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditGoal(),
        backgroundColor: AppColor.secondary,
        elevation: 3,
        child: Icon(Icons.add, color: AppColor.white),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColor.primary,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              "Hedefler yükleniyor...",
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.primary),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              "Hata",
              style: AppTextStyles.heading3.copyWith(color: Colors.red),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                style: AppTextStyles.body1Regular,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchGoals,
              icon: Icon(Icons.refresh),
              label: Text("Yeniden Dene"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    if (_allGoals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, color: AppColor.greyLight, size: 64),
            SizedBox(height: 16),
            Text(
              "Henüz hiç hedef oluşturulmamış.",
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddEditGoal(),
              icon: Icon(Icons.add),
              label: Text("Yeni Hedef Ekle"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondary,
                foregroundColor: AppColor.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchGoals,
      color: AppColor.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _allGoals.length + 1, // +1 for header
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader();
            }
            final goal = _allGoals[index - 1];
            return _buildGoalCard(goal, index - 1);
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hedeflerinizi takip edin",
            style: AppTextStyles.heading2.copyWith(color: AppColor.black),
          ),
          SizedBox(height: 4),
          Text(
            "İlerlemenizi görmek ve hedeflerinize ulaşmak için düzenli takip yapın",
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }



  Widget _buildGoalCard(Goal goal, int index) {
    double progress = goal.calculatedProgress;
    Color statusColor = _getStatusColor(goal.status);
    String statusText = _getStatusText(goal.status);
    IconData categoryIcon = _getGoalCategoryIcon(goal.category);

    return Card(
      elevation: 0,
      color: AppColor.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToAddEditGoal(goal: goal),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.secondary.withValues(alpha:0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(categoryIcon, color: AppColor.secondary, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: AppTextStyles.heading4,
                        ),
                        if (goal.description != null && goal.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              goal.description!,
                              style: AppTextStyles.body2Regular.copyWith(
                                color: AppColor.black.withValues(alpha:0.7),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha:0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: AppTextStyles.body2Medium.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              if (goal.status.toLowerCase() == 'in_progress' && 
                  goal.targetValue != null && 
                  goal.targetValue! > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${goal.currentValue?.toStringAsFixed(0) ?? '0'} ${goal.unit ?? ''}",
                      style: AppTextStyles.body2Regular,
                    ),
                    Text(
                      "${goal.targetValue?.toStringAsFixed(0) ?? '-'} ${goal.unit ?? ''}",
                      style: AppTextStyles.body2Regular,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha:0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withValues(alpha:0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: AppTextStyles.body2Medium.copyWith(
                      color: statusColor,
                    ),
                  ),
                ),
              ],
              
              SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (goal.startDate != null)
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: AppColor.greyLight),
                            SizedBox(width: 4),
                            Text(
                              "Başlangıç: ${formatDate(goal.startDate!, format: 'dd MMM yy')}",
                              style: AppTextStyles.body2Regular.copyWith(color: AppColor.greyLight),
                            ),
                          ],
                        ),
                      if (goal.targetDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(Icons.flag, size: 14, color: AppColor.primary),
                              SizedBox(width: 4),
                              Text(
                                "Bitiş: ${formatDate(goal.targetDate!, format: 'dd MMM yy')}",
                                style: AppTextStyles.body2Regular.copyWith(color: AppColor.primary),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _navigateToAddEditGoal(goal: goal),
                        icon: Icon(Icons.edit_outlined, color: AppColor.secondary),
                        tooltip: "Düzenle",
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(8),
                        splashRadius: 24,
                      ),
                      IconButton(
                        onPressed: () => _handleDeleteGoal(goal.id, index),
                        icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                        tooltip: "Sil",
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(8),
                        splashRadius: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getGoalCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'weight': return Icons.monitor_weight_outlined;
      case 'habit': return Icons.trending_up;
      case 'nutrition': return Icons.restaurant;
      case 'measurement': return Icons.straighten;
      default: return Icons.flag;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress': return AppColor.primary;
      case 'pending': return Colors.orange.shade700;
      case 'completed': return Colors.green.shade600;
      case 'failed': return Colors.redAccent;
      case 'cancelled': return AppColor.greyLight;
      default: return AppColor.greyLight;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress': return "Devam Ediyor";
      case 'pending': return "Beklemede";
      case 'completed': return "Tamamlandı";
      case 'failed': return "Başarısız";
      case 'cancelled': return "İptal Edildi";
      default: return status;
    }
  }}