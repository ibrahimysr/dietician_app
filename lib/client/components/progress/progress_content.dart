import 'package:dietician_app/client/components/progress/measurements_chart_card.dart';
import 'package:dietician_app/client/components/progress/progress_list_item.dart';
import 'package:dietician_app/client/components/progress/progress_summary_card.dart';
import 'package:dietician_app/client/components/progress/weight_chart_card.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:flutter/material.dart';

class ProgressContentView extends StatelessWidget {
  final List<Progress> progressList;

  const ProgressContentView({super.key, required this.progressList});

  @override
  Widget build(BuildContext context) {
    final sortedProgress = List<Progress>.from(progressList)
      ..sort((a, b) => DateTime.parse(b.date ?? "").compareTo(DateTime.parse(a.date ?? "")));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ProgressSummaryCard(progressList: sortedProgress),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: WeightChartCard(progressList: sortedProgress),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MeasurementsChartCard(progressList: sortedProgress),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Tüm Kayıtlar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final progress = sortedProgress[index];
              return ProgressListItem(progress: progress, isFirst: index == 0);
            },
            childCount: sortedProgress.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }
}