import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/subscription_plans_model.dart';
import 'package:flutter/material.dart';

class DietitianDetailsPlanCard extends StatelessWidget {
  final SubscriptionPlansModel plan;

  const DietitianDetailsPlanCard({super.key, required this.plan});

  String _displayValue(String? value, {String defaultValue = "Belirtilmemiş"}) {
    return (value == null || value.isEmpty) ? defaultValue : value;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColor.grey,
      shadowColor: AppColor.black.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _displayValue(plan.name, defaultValue: "İsimsiz Plan"),
                    style: AppTextStyles.heading4.copyWith(color: AppColor.secondary),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${_displayValue(plan.price, defaultValue: '??')} TL",
                  style: AppTextStyles.heading4.copyWith(color: AppColor.primary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "${plan.duration} Günlük Plan",
              style: AppTextStyles.body2Regular.copyWith(color: AppColor.black),
            ),
            const SizedBox(height: 12),
            Text(
              _displayValue(plan.description, defaultValue: "Açıklama yok."),
              style: AppTextStyles.body2Regular.copyWith(color: AppColor.black.withValues(alpha: 0.7)),
            ),
            if (plan.features.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8.0,
                runSpacing: 6.0,
                children: plan.features
                    .map(
                      (feature) => Chip(
                        avatar: Icon(
                          Icons.check,
                          size: 16,
                          color: AppColor.secondary.withValues(alpha: 0.8),
                        ),
                        label: Text(
                          feature,
                          style: AppTextStyles.body2Regular.copyWith(
                            color: AppColor.black.withValues(alpha: 0.85),
                          ),
                        ),
                        backgroundColor: AppColor.secondary.withValues(alpha: 0.1),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: 0.0, vertical: -2),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}