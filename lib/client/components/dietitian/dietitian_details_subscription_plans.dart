import 'package:dietician_app/client/components/dietitian/dietitian_details_plan_card.dart';
import 'package:dietician_app/client/components/dietitian/dietitian_details_section_title.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/subscription_plans_model.dart';
import 'package:flutter/material.dart';

class DietitianDetailsSubscriptionPlans extends StatelessWidget {
  final List<SubscriptionPlansModel> plans; 

    final VoidCallback onSelectPlan;


  const DietitianDetailsSubscriptionPlans({super.key, required this.plans, 
   required this.onSelectPlan,});

  @override
  Widget build(BuildContext context) { 
      if (plans.isEmpty) {
      return const SizedBox.shrink(); 
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DietitianDetailsSectionTitle(title: 'Abonelik Planları', color: AppColor.black),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plans.length,
            itemBuilder: (context, index) => DietitianDetailsPlanCard(plan: plans[index],    onSelectPlan: onSelectPlan),
          ),
        ],
      ),
    );
  }
}