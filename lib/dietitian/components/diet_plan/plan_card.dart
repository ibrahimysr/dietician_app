import 'package:dietician_app/dietitian/components/diet_plan/card_footer.dart';
import 'package:dietician_app/dietitian/components/diet_plan/header.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:dietician_app/dietitian/screens/diet_plan/diet_plan_detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:dietician_app/client/components/diet_plan/info_chip.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class DietitianPlanCard extends StatelessWidget {
  final ClientDietPlan plan;

  const DietitianPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    String? formatDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return 'Belirtilmemiş';
      try {
        if (dateString.contains('T')) {
          dateString = dateString.split('T')[0];
        }
        final dateTime = DateTime.parse(dateString);
        return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
      } catch (e) {
        print("Tarih formatlama hatası: $e");
        return dateString; 
      }
    }


    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.grey, 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha:0.05), 
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
       
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
         
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DietPlanDetailScreen(plan: plan),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            CardHeader(plan: plan),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Text(
                    plan.title.isNotEmpty ? plan.title : "İsimsiz Plan",
                    style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.w600), 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoChip( 
                        icon: Icons.calendar_today_outlined,
                        text: "${formatDate(plan.startDate)} - ${formatDate(plan.endDate)}",
                      ),
                      const SizedBox(height: 12),
                      InfoChip( 
                        icon: Icons.local_fire_department_outlined,
                        text: "${plan.dailyCalories} kcal/gün",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DietitianCardFooter(plan: plan),
          ],
        ),
      ),
    );
  }
}