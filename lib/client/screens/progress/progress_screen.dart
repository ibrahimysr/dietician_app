import 'package:dietician_app/client/components/progress/empty_progress.dart';
import 'package:dietician_app/client/components/progress/error.dart';
import 'package:dietician_app/client/components/progress/progress_content.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/screens/progress/add_progress_screen.dart';
import 'package:dietician_app/client/viewmodel/progress_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          title: Text(
            'İlerleme Takibi',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.white),
          ),
          actions: [ 
            IconButton(
              icon: Icon(Icons.add, color: AppColor.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddProgressScreen()),
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
              return ErrorView(
                  message: viewmodel.isProgressErrorMessage ?? "Bir hata oluştu");
            }

            if (viewmodel.allProgress.isEmpty) {
              return const EmptyProgressView();
            }

            return RefreshIndicator(
              onRefresh: viewmodel.fetchAllData,
              child: ProgressContentView(progressList: viewmodel.allProgress),
            );
          },
        ),
      ),
    );
  }
}