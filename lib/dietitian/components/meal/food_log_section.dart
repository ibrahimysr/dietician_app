
import 'package:dietician_app/client/components/food_log/food_log_item.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/models/food_log_model.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class FoodLogSection extends StatelessWidget {
  final String title; 
  final List<FoodLog> mealLogs;
  final bool isLoadingLogs;
  final String? logErrorMessage;
  final VoidCallback? onRefresh; 
  final Function(FoodLog, int)? onEdit;
  final Function(int, int)? onDelete;
  final bool isReadOnly;
  const FoodLogSection({
    super.key,
    this.title = "Kaydedilenler (Danışanın Girdikleri)",
    required this.mealLogs,
    required this.isLoadingLogs,
    required this.logErrorMessage,
    this.onRefresh, 
    this.onEdit,    
    this.onDelete,  
    this.isReadOnly = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.grey, 
      margin: EdgeInsets.zero, 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading4.copyWith(color: AppColor.black),
                ),
                if (onRefresh != null)
                  IconButton(
                    icon: Icon(Icons.refresh, color: AppColor.secondary, size: 22),
                    onPressed: onRefresh,
                    tooltip: 'Kayıtları Yenile',
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            _buildLogContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogContent(BuildContext context) {
    if (isLoadingLogs) {
      return  Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
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
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
              const SizedBox(height: 10),
              Text(
                'Kayıtlar yüklenemedi:\n$logErrorMessage', 
                textAlign: TextAlign.center,
                style: AppTextStyles.body1Regular.copyWith(color: Colors.redAccent),
              ),
              if (onRefresh != null) ...[
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Tekrar Dene'),
                  onPressed: onRefresh,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColor.white,
                    backgroundColor: AppColor.secondary,
                  ),
                ),
              ]
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
              Icon(Icons.playlist_add, color: AppColor.greyLight, size: 35),
              const SizedBox(height: 10),
              Text(
                "Danışan bu öğün için henüz\nbir kayıt girmemiş.", 
                style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: mealLogs.length,
      itemBuilder: (context, index) {
        return FoodLogItem(
          log: mealLogs[index],
          index: index,
          onEdit: isReadOnly ? null : onEdit, 
          onDelete: isReadOnly ? null : onDelete, 
          isReadOnly: isReadOnly, 
        );
      },
      separatorBuilder: (context, index) => Divider( 
        color: AppColor.greyLight.withValues(alpha:0.4), 
        height: 25, 
        thickness: 1, 
      ),
    );
  }
}