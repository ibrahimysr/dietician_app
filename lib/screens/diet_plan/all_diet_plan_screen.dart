import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/screens/diet_plan/diet_plan_details_screen.dart';
import 'package:flutter/material.dart';

class AllDietPlansScreen extends StatefulWidget {
  final List<DietPlan> allPlans;

  const AllDietPlansScreen({super.key, required this.allPlans});

  @override
  State<AllDietPlansScreen> createState() => _AllDietPlansScreenState();
}

class _AllDietPlansScreenState extends State<AllDietPlansScreen> {
  String _filterStatus = 'all';
  late List<DietPlan> _filteredPlans;

  @override
  void initState() {
    super.initState();
    _filteredPlans = widget.allPlans;
  }

  void _filterPlans(String status) {
    setState(() {
      _filterStatus = status;
      if (status == 'all') {
        _filteredPlans = widget.allPlans;
      } else {
        _filteredPlans = widget.allPlans
            .where((plan) => plan.status.toLowerCase() == status.toLowerCase())
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        title: Text(
          "Diyet Planlarım",
          style: AppTextStyles.heading3.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "${widget.allPlans.length} Plan",
                  style: AppTextStyles.body2Medium.copyWith(color: AppColor.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _filteredPlans.isEmpty
                ? _buildEmptyState()
                : _buildPlansList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('all', 'Tümü'),
            SizedBox(width: 8),
            _buildFilterChip('active', 'Aktif'),
            SizedBox(width: 8),
            _buildFilterChip('paused', 'Duraklatıldı'),
            SizedBox(width: 8),
            _buildFilterChip('completed', 'Tamamlandı'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String status, String label) {
    final isSelected = _filterStatus == status;
    
    return InkWell(
      onTap: () => _filterPlans(status),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : AppColor.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.greyLight,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2Medium.copyWith(
            color: isSelected ? AppColor.white : AppColor.black,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppColor.greyLight,
          ),
          SizedBox(height: 16),
          Text(
            "Gösterilecek diyet planı bulunamadı",
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight),
          ),
          SizedBox(height: 8),
          Text(
            _filterStatus != 'all'
                ? "Filtre kriterlerinizi değiştirmeyi deneyin"
                : "Yeni bir diyet planı için diyetisyeninizle iletişime geçin",
            style: AppTextStyles.body2Regular.copyWith(color: AppColor.greyLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 12, bottom: 16),
      itemCount: _filteredPlans.length,
      itemBuilder: (context, index) {
        final plan = _filteredPlans[index];
        return _buildPlanCard(plan, context);
      },
    );
  }

  Widget _buildPlanCard(DietPlan plan, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DietPlanDetailScreen(plan: plan),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(plan),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: AppTextStyles.heading4,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColor.greyLight),
                      SizedBox(width: 4),
                      Text(
                        "Dyt. ${plan.dietitian.user?.name ?? 'N/A'}",
                        style: AppTextStyles.body2Regular.copyWith(
                          color: AppColor.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.calendar_today,
                        "${_formatDate(plan.startDate)} - ${_formatDate(plan.endDate)}",
                      ),
                      SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.local_fire_department,
                        "${plan.dailyCalories} kcal",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildCardFooter(plan),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(DietPlan plan) {
    Color statusColor = _getStatusColor(plan.status);
    String statusText = _getStatusText(plan.status);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getPlanStatusIcon(plan.status),
            size: 16,
            color: statusColor,
          ),
          SizedBox(width: 6),
          Text(
            statusText,
            style: AppTextStyles.body2Medium.copyWith(
              color: statusColor,
            ),
          ),
          Spacer(),
          Text(
            _calculateDuration(plan.startDate, plan.endDate),
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColor.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFooter(DietPlan plan) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Text(
            "${plan.meals.length} öğün",
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColor.black.withOpacity(0.6),
            ),
          ),
          Spacer(),
          Text(
            "Detaylar",
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColor.primary,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColor.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColor.black.withOpacity(0.6),
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColor.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlanStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.play_circle_outline;
      case 'paused':
        return Icons.pause_circle_outline;
      case 'completed':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'completed':
        return AppColor.primary;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Aktif';
      case 'paused':
        return 'Duraklatıldı';
      case 'completed':
        return 'Tamamlandı';
      default:
        return 'Bilinmeyen';
    }
  }

  String? _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      if (dateString.contains('T')) {
        dateString = dateString.split('T')[0];
      }
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day}.${dateTime.month}.${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }

  String _calculateDuration(String? startDate, String? endDate) {
    if (startDate == null || endDate == null || startDate.isEmpty || endDate.isEmpty) {
      return '';
    }

    try {
      DateTime start = DateTime.parse(startDate.split('T')[0]);
      DateTime end = DateTime.parse(endDate.split('T')[0]);
      
      int days = end.difference(start).inDays + 1;
      int weeks = (days / 7).floor();
      
      if (weeks > 0) {
        return "$weeks hafta";
      } else {
        return "$days gün";
      }
    } catch (e) {
      return '';
    }
  }
}