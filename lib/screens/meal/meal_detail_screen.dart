import 'package:dietician_app/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/extension/context_extension.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    String mealTypeName = getMealTypeName(meal.mealType);

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.secondary,
        title: Text(
          mealTypeName,
          style: AppTextStyles.heading3.copyWith(color: AppColor.white),
        ),
        iconTheme: IconThemeData(color: AppColor.white),
        centerTitle: true,
      ),
      body: ListView(
        padding: context.paddingNormal,
        children: [
          if (meal.photoUrl != null && meal.photoUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                meal.photoUrl!,
                height: context.getDynamicHeight(25),
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: context.getDynamicHeight(25),
                    color: AppColor.grey,
                    child: Center(
                        child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColor.secondary,
                    )),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: context.getDynamicHeight(25),
                  color: AppColor.grey,
                  child: Center(
                      child: Icon(Icons.broken_image_outlined,
                          color: AppColor.greyLight, size: 40)),
                ),
              ),
            ),
          if (meal.photoUrl != null && meal.photoUrl!.isNotEmpty)
            SizedBox(height: context.getDynamicHeight(2.5)),
          Card(
            elevation: 2.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: AppColor.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(getMealTypeIcon(meal.mealType),
                          color: AppColor.secondary, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          mealTypeName,
                          style: AppTextStyles.heading3
                              .copyWith(color: AppColor.secondary),
                        ),
                      ),
                      Text(
                        "Gün ${meal.dayNumber}",
                        style: AppTextStyles.body1Regular
                            .copyWith(color: AppColor.greyLight),
                      ),
                    ],
                  ),
                  Divider(height: 25, color: AppColor.grey?.withOpacity(0.5)),
                  Text(
                    "Açıklama:",
                    style: AppTextStyles.body1Medium
                        .copyWith(color: AppColor.black.withOpacity(0.7)),
                  ),
                  SizedBox(height: 6),
                  Text(
                    meal.description,
                    style: AppTextStyles.body1Regular
                        .copyWith(color: AppColor.black, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.getDynamicHeight(2)),
          Card(
            elevation: 2.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: AppColor.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Besin Değerleri",
                    style:
                        AppTextStyles.heading4.copyWith(color: AppColor.black),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroInfo(
                          "Kalori", "${meal.calories} kcal", AppColor.primary),
                      _buildMacroInfo(
                          "Protein", "${meal.protein} g", Colors.blue.shade700),
                      _buildMacroInfo(
                          "Yağ", "${meal.fat} g", Colors.orange.shade700),
                      _buildMacroInfo("Karbonhidrat", "${meal.carbs} g",
                          Colors.purple.shade700),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMacroInfo(String label, String value, Color valueColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.body2Medium.copyWith(color: AppColor.greyLight),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.heading4
              .copyWith(color: valueColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
