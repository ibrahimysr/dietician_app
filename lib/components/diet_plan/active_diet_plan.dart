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
            ElevatedButton(onPressed: onRetry, child: const Text("Tekrar Dene")),
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
              style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
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
                  style: AppTextStyles.body1Medium.copyWith(color: AppColor.primary),
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
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.grey,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.title,
                    style: AppTextStyles.body1Medium.copyWith(fontSize: 17),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                _buildStatusBadge(plan.status),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                 Icon(Icons.person_outline, size: 16, color: AppColor.black),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Diyetisyen: Dyt. ${plan.dietitian.user?.name}",
                    style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                 Icon(Icons.date_range_outlined,
                    size: 16, color: AppColor.black),
                const SizedBox(width: 6),
                Text(
                  "Tarihler: ${_formatDate(plan.startDate)} - ${_formatDate(plan.endDate)}",
                  style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (plan.notes.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Icon(Icons.notes_outlined,
                      size: 16, color: AppColor.black),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Not: ${plan.notes}",
                      style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    IconData icon;
    Color color;
    String text;

    switch (status.toLowerCase()) {
      case 'active':
        icon = Icons.play_circle_fill;
        color = Colors.green;
        text = "Aktif";
        break;
      case 'paused':
        icon = Icons.pause_circle_filled;
        color = Colors.orange;
        text = "Duraklatıldı";
        break;
      case 'completed':
        icon = Icons.check_circle;
        color = AppColor.primary;
        text = "Tamamlandı";
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
        text = status.isNotEmpty
            ? status[0].toUpperCase() + status.substring(1)
            : 'Bilinmiyor';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.body1Medium
                .copyWith(color: color, fontWeight: FontWeight.bold),
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
