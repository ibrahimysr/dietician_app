import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:dietician_app/models/food_log_model.dart';
import 'package:flutter/material.dart';

class FoodLogItem extends StatelessWidget {
  final FoodLog log;
  final int index;
  final Function(FoodLog, int) onEdit;
  final Function(int, int) onDelete;

  const FoodLogItem({
    super.key,
    required this.log,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String foodName = log.food?.name ?? log.foodDescription ?? "Bilinmeyen Yiyecek";
    String loggedAtFormatted = formatDateTime(log.loggedAt, format: 'dd MMMM, HH:mm');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (log.photoUrl != null && log.photoUrl!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                log.photoUrl!,
                width: 65,
                height: 65,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 65,
                  height: 65,
                  color: AppColor.grey?.withValues(alpha: 0.3),
                  child: Icon(Icons.fastfood_outlined, color: AppColor.secondary, size: 30),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 65,
                    height: 65,
                    color: AppColor.grey?.withValues(alpha: 0.3),
                    child: Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.secondary),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: AppColor.grey?.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.restaurant_menu, color: AppColor.secondary, size: 30),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foodName,
                style: AppTextStyles.body1Medium.copyWith(fontWeight: FontWeight.w600, color: AppColor.black),
              ),
              SizedBox(height: 5),
              Text(
                "${log.quantity} porsiyon",
                style: AppTextStyles.body2Regular.copyWith(color: AppColor.primary),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 10.0,
                runSpacing: 4.0,
                children: [
                  _buildMiniMacro("🔥 ${log.calories} kcal", AppColor.primary),
                  if (log.protein != null && log.protein!.isNotEmpty)
                    _buildMiniMacro("💪 ${log.protein}g Prot.", Colors.blue.shade700),
                  if (log.fat != null && log.fat!.isNotEmpty)
                    _buildMiniMacro("🥑 ${log.fat}g Yağ", Colors.orange.shade700),
                  if (log.carbs != null && log.carbs!.isNotEmpty)
                    _buildMiniMacro("🍞 ${log.carbs}g Karb.", Colors.purple.shade700),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Kaydedildi: $loggedAtFormatted",
                style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight),
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.edit_outlined, size: 18, color: AppColor.secondary),
                tooltip: 'Düzenle',
                onPressed: () => onEdit(log, index),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 28,
              width: 28,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                tooltip: 'Sil',
                onPressed: () => onDelete(log.id, index),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniMacro(String text, Color color) {
    return Text(
      text,
      style: AppTextStyles.body2Medium.copyWith(color: color, fontWeight: FontWeight.w500),
    );
  }
}