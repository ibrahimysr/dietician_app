import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:flutter/material.dart';

class ProgressSummaryCard extends StatelessWidget {
  final List<Progress> progressList;

  const ProgressSummaryCard({super.key, required this.progressList});

  @override
  Widget build(BuildContext context) {
    double? initialWeight, currentWeight, weightDifference;
    if (progressList.isNotEmpty) {
      currentWeight = double.tryParse(progressList.first.weight ?? "0");
      initialWeight = double.tryParse(progressList.last.weight ?? "0");
      if (initialWeight != null && currentWeight != null) {
        weightDifference = currentWeight - initialWeight;
      }
    }

    return Card(
      elevation: 3,
      color: AppColor.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "İlerleme Özeti",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${progressList.length} Kayıt",
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildSummaryItem(
                  context,
                  "Başlangıç",
                  initialWeight != null ? "$initialWeight kg" : "-",
                  Icons.calendar_today,
                  AppColor.primary,
                ),
                _buildSummaryItem(
                  context,
                  "Güncel",
                  currentWeight != null ? "$currentWeight kg" : "-",
                  Icons.done_all,
                  AppColor.secondary,
                ),
                _buildSummaryItem(
                  context,
                  "Fark",
                  weightDifference != null
                      ? "${weightDifference > 0 ? "+" : ""}${weightDifference.toStringAsFixed(1)} kg"
                      : "-",
                  Icons.trending_up,
                  weightDifference != null && weightDifference < 0 ? AppColor.primary : AppColor.accent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.black.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
        ],
      ),
    );
  }
}