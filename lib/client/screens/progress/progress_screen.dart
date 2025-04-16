import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:dietician_app/client/screens/progress/add_progress_screen.dart';
import 'package:dietician_app/client/viewmodel/progress_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';



class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressViewmodel(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          title: Text('İlerleme Takibi', 
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: AppColor.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) =>  AddProgressScreen()),
                );
              },
            ),
          ],
          elevation: 0,
        ),
        body: Consumer<ProgressViewmodel>(
          builder: (context, viewmodel, child) {
            if (viewmodel.isProgressLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              );
            }
            
            if (viewmodel.isProgressErrorMessage != null) {
              return ErrorView(message: viewmodel.isProgressErrorMessage ?? "Bir hata oluştu");
            }
            
            if (viewmodel.allProgress.isEmpty) {
              return const EmptyProgressView();
            }
            
            return RefreshIndicator( 
              onRefresh: viewmodel.fetchAllData,
              child: ProgressContentView(progressList: viewmodel.allProgress));
          },
        ),
      ),
    );
  }
}

class EmptyProgressView extends StatelessWidget {
  const EmptyProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_data.png',
            height: 150,
            width: 150,
          ),
          const SizedBox(height: 20),
          Text(
            "Henüz ilerleme kaydı bulunmuyor",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "İlerlemenizi takip etmek için yeni bir kayıt ekleyin",
            style: TextStyle(
              fontSize: 14,
              color: AppColor.black.withValues(alpha:0.6),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (_) => const AddProgressScreen()),
              // );
            },
            icon: Icon(Icons.add, color: AppColor.white),
            label: Text("İlerleme Ekle", style: TextStyle(color: AppColor.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  
  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppColor.accent,
          ),
          const SizedBox(height: 16),
          Text(
            "Hata Oluştu",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.black.withValues(alpha:0.6)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
             
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
            ),
            child: Text("Tekrar Dene", style: TextStyle(color: AppColor.white)),
          ),
        ],
      ),
    );
  }
}

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
                    color: AppColor.primary.withValues(alpha:0.1),
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
              color: color.withValues(alpha:0.1),
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
              color: AppColor.black.withValues(alpha:0.6),
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
                  ? Center(child: Text("Grafik için yeterli veri yok", style: TextStyle(color: AppColor.black.withValues(alpha:0.6))))
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
                                    color: AppColor.black.withValues(alpha:0.6),
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
                                      style: TextStyle(fontSize: 10, color: AppColor.black.withValues(alpha:0.6)),
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
                              color: AppColor.black.withValues(alpha:0.2),
                              width: 1,
                            ),
                            left: BorderSide(
                              color: AppColor.black.withValues(alpha:0.2),
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
                              color: AppColor.primary.withValues(alpha:0.1),
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
                AppColor.primary
              ),
              Divider(color: AppColor.greyLight),
              _buildMeasurementItem(
                context, 
                "Kalça Çevresi", 
                progressList.first.hip ?? "-", 
                Icons.straighten, 
                AppColor.accent
              ),
              Divider(color: AppColor.greyLight),
              _buildMeasurementItem(
                context, 
                "Kol Çevresi", 
                progressList.first.arm ?? "-", 
                Icons.fitness_center, 
                AppColor.primary
              ),
              Divider(color: AppColor.greyLight),
              _buildMeasurementItem(
                context, 
                "Göğüs Çevresi", 
                progressList.first.chest ?? "-", 
                Icons.straighten, 
                AppColor.secondary
              ),
              Divider(color: AppColor.greyLight),
              _buildMeasurementItem(
                context, 
                "Vücut Yağ Oranı", 
                progressList.first.bodyFatPercentage != null ? "${progressList.first.bodyFatPercentage}%" : "-", 
                Icons.percent, 
                AppColor.accent
              ),
            ] else
              Center(child: Text("Henüz ölçüm kaydı bulunmuyor", style: TextStyle(color: AppColor.black.withValues(alpha:0.6)))),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementItem(BuildContext context, String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.1),
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
        color: isFirst ? AppColor.primary.withValues(alpha:0.05) : AppColor.grey,
        border: Border.all(
          color: isFirst 
            ? AppColor.primary.withValues(alpha:0.3) 
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
                color: isFirst ? AppColor.primary.withValues(alpha:0.1) : AppColor.greyLight,
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
              Expanded(child: _buildMeasurementChip(context, "Kilo", "${progress.weight} kg", AppColor.primary)),
              const SizedBox(width: 6),
              Expanded(child: _buildMeasurementChip(context, "Bel", "${progress.waist} cm", AppColor.accent)),
              const SizedBox(width: 6),
              Expanded(child: _buildMeasurementChip(context, "Kalça", "${progress.hip} cm", AppColor.secondary)),
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
        color: color.withValues(alpha:0.1),
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

