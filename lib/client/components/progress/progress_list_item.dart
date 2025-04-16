import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressListItem extends StatelessWidget {
  final Progress progress;
  final bool isFirst;

  const ProgressListItem({super.key, required this.progress, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(progress.date ?? "");
    final formattedDate = DateFormat('dd MMMM yyyy', 'tr_TR').format(date);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isFirst ? AppColor.primary.withValues(alpha: 0.05) : AppColor.grey,
        border: Border.all(
          color: isFirst
              ? AppColor.primary.withValues(alpha: 0.3)
              : AppColor.greyLight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isFirst ? AppColor.primary.withValues(alpha: 0.1) : AppColor.greyLight,
                shape: BoxShape.circle,
              ),
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isFirst ? AppColor.primary : AppColor.black,
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: AppColor.black,
              ),
            ),
            if (isFirst)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Güncel",
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Expanded(
                child: _buildMeasurementChip(context, "Kilo", "${progress.weight} kg", AppColor.primary),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildMeasurementChip(context, "Bel", "${progress.waist} cm", AppColor.accent),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildMeasurementChip(context, "Kalça", "${progress.hip} cm", AppColor.secondary),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.chevron_right, color: AppColor.primary),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => ProgressDetailScreen(progress: progress),
            //   ),
            // );
          },
        ),
      ),
    );
  }

  Widget _buildMeasurementChip(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}