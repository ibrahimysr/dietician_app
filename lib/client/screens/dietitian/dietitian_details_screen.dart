import 'package:dietician_app/client/viewmodel/dietitian_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dietician_app/client/components/dietitian/dietitian_details_about_section.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_contact_button.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_error_widget.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_header_section.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_stats_section.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_subscription_plans.dart';
import 'package:dietician_app/client/core/theme/color.dart';

class DietitianDetailScreen extends StatelessWidget {
  final int dietitianId;

  const DietitianDetailScreen({required this.dietitianId, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = DietitianDetailViewModel();
        viewModel.init(dietitianId);
        return viewModel;
      },
      child: const _DietitianDetailBody(),
    );
  }
}

class _DietitianDetailBody extends StatelessWidget {
  const _DietitianDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DietitianDetailViewModel>();

    return Scaffold(
      backgroundColor: AppColor.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: AppColor.white.withAlpha(180),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColor.primary, size: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.primary,
                strokeWidth: 3,
              ),
            );
          } else if (viewModel.errorMessage != null) {
            return DietitianDetailsErrorWidget(
              errorMessage: viewModel.errorMessage!,
              onRetry: () => viewModel.fetchDietitianDetails(),
            );
          } else if (viewModel.dietitianResponse != null &&
              viewModel.dietitianResponse!.success &&
              viewModel.dietitianResponse!.data != null) {
            final dietitian = viewModel.dietitianResponse!.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DietitianDetailsHeaderSection(dietitian: dietitian),
                  DietitianDetailsAboutSection(dietitian: dietitian),
                  DietitianDetailsStatsSection(dietitian: dietitian),
                  if (dietitian.subscriptionPlans.isNotEmpty)
                    DietitianDetailsSubscriptionPlans(
                      plans: dietitian.subscriptionPlans,
                      onSelectPlan: () async {
                        final error = await viewModel.selectDietitian();
                        if (error == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Diyetisyen başarıyla seçildi!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Hata: $error"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  DietitianDetailsContactButton(dietitian: dietitian),
                  const SizedBox(height: 30),
                ],
              ),
            );
          } else {
            return DietitianDetailsErrorWidget(
              errorMessage: "Bir şeyler ters gitti.",
              onRetry: () => viewModel.fetchDietitianDetails(),
            );
          }
        },
      ),
    );
  }
}
