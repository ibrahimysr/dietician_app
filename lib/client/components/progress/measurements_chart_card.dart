import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:flutter/material.dart';

class MeasurementsChartCard extends StatelessWidget {
  final List<Progress> progressList;

  const MeasurementsChartCard({super.key, required this.progressList});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: AppColor.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vücut Ölçüleri",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 20),
            if (progressList.isNotEmpty) ...[
              _buildMeasurementItem(
                context,
                "Bel Çevresi",
                progressList.first.waist ?? "-",
                Icons.straighten,
                AppColor.primary,
              ),
              Divider(color: AppColor.greyLight),
              _buildMeasurementItem(
                context,
                "Kalça Çevresi",
                progressList.first.hip ?? "-",
                Icons.straighten,
                AppColor.accent,
              ),
              Divider(color: AppColor.greyLight),
              _buildMeasurementItem(
                context,
                "Kol Çevresi",
                progressList.first.arm ?? "-",
                Icons.fitness_center,
                AppColor.primary,
              ),
              Divider(color: AppColor.greyLight),
              _buildMeasurementItem(
                context,
                "Göğüs Çevresi",
                progressList.first.chest ?? "-",
                Icons.straighten,
                AppColor.secondary,
              ),
              Divider(color: AppColor.greyLight),
              _buildMeasurementItem(
                context,
                "Vücut Yağ Oranı",
                progressList.first.bodyFatPercentage != null
                    ? "${progressList.first.bodyFatPercentage}%"
                    : "-",
                Icons.percent,
                AppColor.accent,
              ),
            ] else
              Center(
                child: Text(
                  "Henüz ölçüm kaydı bulunmuyor",
                  style: TextStyle(color: AppColor.black.withValues(alpha: 0.6)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementItem(
      BuildContext context, String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.black,
            ),
          ),
          const Spacer(),
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