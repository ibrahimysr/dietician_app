import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/food_log_model.dart';
import 'package:flutter/material.dart';
import 'food_log_item.dart';

class FoodLogSection extends StatelessWidget {
  final List<FoodLog> mealLogs;
  final bool isLoadingLogs;
  final String? logErrorMessage;
  final VoidCallback onRefresh;
  final Function(FoodLog, int) onEdit;
  final Function(int, int) onDelete;

  const FoodLogSection({
    super.key,
    required this.mealLogs,
    required this.isLoadingLogs,
    required this.logErrorMessage,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kaydedilenler (Yedikleriniz)",
                  style: AppTextStyles.heading4.copyWith(color: AppColor.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            _buildLogContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogContent(BuildContext context) {
    if (isLoadingLogs) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: CircularProgressIndicator(color: AppColor.secondary),
        ),
      );
    }

    if (logErrorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent, size: 30),
              SizedBox(height: 10),
              Text(
                'Hata: $logErrorMessage',
                textAlign: TextAlign.center,
                style: AppTextStyles.body1Regular.copyWith(color: Colors.redAccent),
              ),
              SizedBox(height: 15),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh, size: 18),
                label: Text('Tekrar Dene'),
                onPressed: onRefresh,
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColor.white,
                  backgroundColor: AppColor.secondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (mealLogs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.no_food_outlined, color: AppColor.greyLight, size: 35),
              SizedBox(height: 10),
              Text(
                "Bu öğün için henüz bir kayıt\neklenmemiş.",
                style: AppTextStyles.body1Regular.copyWith(color: AppColor.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: mealLogs.length,
      itemBuilder: (context, index) {
        return FoodLogItem(
          log: mealLogs[index],
          index: index,
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: AppColor.grey?.withValues(alpha: 0.3),
        height: 25,
        thickness: 1,
      ),
    );
  }
}