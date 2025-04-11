
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:dietician_app/client/models/food_log_model.dart';
import 'package:dietician_app/client/core/utils/formatters.dart'; 
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class FoodLogItem extends StatelessWidget {
  final FoodLog log;
  final int index;
  final Function(FoodLog, int)? onEdit;
  final Function(int, int)? onDelete;
  final bool isReadOnly;

  const FoodLogItem({
    super.key,
    required this.log,
    required this.index,
    this.onEdit, 
    this.onDelete,
    this.isReadOnly = false, 
  });

  Widget _buildMiniMacro(String text, Color color) {
    return Text(
      text,
      style: AppTextStyles.body1Medium.copyWith(color: color, fontWeight: FontWeight.w500), 
    );
  }

  @override
  Widget build(BuildContext context) {
    String? foodName = log.food?.name ?? log.foodDescription;
    if (foodName!.isEmpty) {
      foodName = "Açıklama Girilmemiş"; 
    }

    String loggedAtFormatted = "Bilinmeyen Zaman";
    try {
      loggedAtFormatted = formatDateTime(log.loggedAt, format: 'dd MMMM yyyy, HH:mm');
    } catch (e) {
      try {
        loggedAtFormatted = DateFormat('dd.MM.yy HH:mm', 'tr_TR').format(DateTime.parse(log.loggedAt));
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (log.photoUrl != null && log.photoUrl!.isNotEmpty)
                  ? Image.network( 
                      log.photoUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) => progress == null
                          ? child
                          : Container(
                              width: 60, height: 60, color: AppColor.greyLight.withOpacity(0.3),
                              child:  Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.secondary))),
                            ),
                      errorBuilder: (context, error, stack) => Container(
                            width: 60, height: 60, color: AppColor.greyLight.withOpacity(0.3),
                            child:  Icon(Icons.no_photography_outlined, color: AppColor.grey, size: 30), 
                          ),
                    )
                  : Container( 
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColor.greyLight.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.restaurant_menu_outlined, color: AppColor.secondary.withOpacity(0.8), size: 30),
                    ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodName,
                  style: AppTextStyles.body1Medium.copyWith(color: AppColor.black), 
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${log.quantity} porsiyon • ${log.calories} kcal", 
                  style: AppTextStyles.body2Regular.copyWith(color: AppColor.primary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10.0, 
                  runSpacing: 4.0,  
                  children: [
                    if (log.protein != null && log.protein!.isNotEmpty)
                      _buildMiniMacro("💪 ${log.protein}g P", Colors.blue.shade700),
                    if (log.fat != null && log.fat!.isNotEmpty)
                      _buildMiniMacro("🥑 ${log.fat}g Y", Colors.orange.shade700),
                    if (log.carbs != null && log.carbs!.isNotEmpty)
                      _buildMiniMacro("🍞 ${log.carbs}g K", Colors.purple.shade700),
                  ],
                ),
                 const SizedBox(height: 8),
                 Row(
                   children: [
                     Icon(Icons.access_time_filled_rounded, size: 14, color: AppColor.black.withOpacity(0.7)),
                     const SizedBox(width: 4),
                     Text(
                       loggedAtFormatted,
                       style: AppTextStyles.body1Medium.copyWith(color: AppColor.black.withOpacity(0.9)), 
                     ),
                   ],
                 ),
              ],
            ),
          ),

          if (!isReadOnly && (onEdit != null || onDelete != null))
            Padding(
              padding: const EdgeInsets.only(left: 8.0), 
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  if (onEdit != null)
                    SizedBox(
                      height: 32, 
                      width: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.edit_outlined, size: 18, color: AppColor.secondary),
                        tooltip: 'Kaydı Düzenle',
                        onPressed: () => onEdit!(log, index),
                         splashRadius: 18, 
                         constraints: const BoxConstraints(),
                      ),
                    ),
                  if (onDelete != null)
                    SizedBox(
                      height: 32, 
                      width: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent), 
                        tooltip: 'Kaydı Sil',
                        onPressed: () => onDelete!(log.id, index), 
                         splashRadius: 18,
                         constraints: const BoxConstraints(),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}