import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightChartCard extends StatelessWidget {
  final List<Progress> progressList;

  const WeightChartCard({super.key, required this.progressList});

  @override
  Widget build(BuildContext context) {
    final chartData = progressList.take(7).toList().reversed.toList();

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
              "Kilo Takibi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: chartData.isEmpty
                  ? Center(
                      child: Text(
                        "Grafik için yeterli veri yok",
                        style: TextStyle(color: AppColor.black.withValues(alpha: 0.6)),
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: AppColor.black.withValues(alpha: 0.6),
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                                  final date = DateTime.parse(chartData[value.toInt()].date ?? "");
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      DateFormat('dd/MM').format(date),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColor.black.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 30,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColor.black.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            left: BorderSide(
                              color: AppColor.black.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              chartData.length,
                              (index) => FlSpot(
                                index.toDouble(),
                                double.tryParse(chartData[index].weight ?? "0") ?? 0,
                              ),
                            ),
                            isCurved: true,
                            color: AppColor.primary,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 5,
                                  color: AppColor.primary,
                                  strokeWidth: 2,
                                  strokeColor: AppColor.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColor.primary.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}