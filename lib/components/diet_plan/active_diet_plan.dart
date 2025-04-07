import 'package:dietician_app/screens/diet_plan/diet_plan_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/screens/diet_plan/all_diet_plan_screen.dart';
import 'package:dietician_app/core/extension/context_extension.dart';

class ActiveDietPlanSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<DietPlan> allDietPlans;
  final DietPlan? activeDietPlan;
  final Future<void> Function() onRetry;

  const ActiveDietPlanSection({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.allDietPlans,
    required this.activeDietPlan,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hata: $errorMessage",
                style: AppTextStyles.body1Medium.copyWith(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: onRetry, child: const Text("Tekrar Dene")),
          ],
        ),
      );
    }

    if (allDietPlans.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColor.grey, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            "Henüz size atanmış bir diyet planı bulunmuyor.",
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              activeDietPlan != null ? "Aktif Diyet Planın" : "Diyet Planların",
              style:
                  AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
            ),
            if (allDietPlans.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AllDietPlansScreen(allPlans: allDietPlans),
                    ),
                  );
                },
                child: Text(
                  "Tümünü Gör (${allDietPlans.length})",
                  style: AppTextStyles.body1Medium
                      .copyWith(color: AppColor.primary),
                ),
              ),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(1.5)),
        if (activeDietPlan != null)
          _buildDietPlanCard(context, activeDietPlan!)
        else
          _noActivePlanCard(),
      ],
    );
  }

  Widget _buildDietPlanCard(BuildContext context, DietPlan plan) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DietPlanDetailScreen(plan: plan),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColor
            .grey, 
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      plan.title,
                      style: AppTextStyles.heading4.copyWith(
                          color: AppColor.black), 
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildStatusBadge(plan
                      .status),
                ],
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.person_outline,
                text:
                    "Diyetisyen: Dyt. ${plan.dietitian.user?.name ?? 'Belirtilmemiş'}",
              ),
              const SizedBox(height: 6),
              _buildInfoRow(
                icon: Icons.date_range_outlined,
                text:
                    "Tarihler: ${_formatDate(plan.startDate)} - ${_formatDate(plan.endDate)}",
              ),
              const SizedBox(height: 10),
              if (plan.notes.isNotEmpty)
                _buildInfoRow(
                  icon: Icons.notes_outlined,
                  text: "Not: ${plan.notes}",
                  maxLines: 3, 
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon, required String text, int maxLines = 1}) {
    return Row(
      crossAxisAlignment:
          maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon,
            size: 16,
            color:
                AppColor.black.withValues(alpha:0.7)),
        const SizedBox(width: 8), 
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body2Regular.copyWith(
                color: AppColor.black.withValues(alpha:0.9)), 
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    IconData icon;
    Color color;
    Color textColor;
    String text;

    switch (status.toLowerCase()) {
      case 'active':
        icon = Icons.play_circle_fill;
        color = Colors.green;
        text = "Aktif";
        textColor = Colors.green.shade800; 
        break;
      case 'paused':
        icon = Icons.pause_circle_filled;
        color = Colors.orange;
        text = "Duraklatıldı";
        textColor = Colors.orange.shade800;
        break;
      case 'completed':
        icon = Icons.check_circle;
        color = AppColor.secondary; 
        text = "Tamamlandı";
        textColor = AppColor.secondary;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey.shade400;
        text = status.isNotEmpty
            ? status[0].toUpperCase() + status.substring(1)
            : 'Bilinmiyor';
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14), 
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.body2Medium 
                .copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600), 
          ),
        ],
      ),
    );
  }

  Widget _noActivePlanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: AppColor.black, size: 30),
          const SizedBox(height: 10),
          Text(
            "Şu anda takip ettiğiniz aktif bir diyet planı bulunmuyor.",
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "'Tümünü Gör' diyerek geçmiş veya duraklatılmış planlarınıza bakabilirsiniz.",
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String? _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Belirtilmemiş';
    try {
      if (dateString.contains('T')) {
        dateString = dateString.split('T')[0];
      }
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }
}
