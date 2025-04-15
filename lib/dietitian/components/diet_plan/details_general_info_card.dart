import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:dietician_app/dietitian/screens/diet_plan/add_diet_plan_screen.dart';
import 'package:dietician_app/dietitian/service/diet_plan/diet_plan_service.dart';
import 'package:flutter/material.dart';

import 'package:dietician_app/client/components/diet_plan/details_info_row.dart';
import 'package:dietician_app/client/components/diet_plan/details_status_badge.dart';

import 'package:dietician_app/client/core/theme/color.dart';

class DietitianDetailsGeneralInfoCard extends StatefulWidget {
  final ClientDietPlan plan;

  const DietitianDetailsGeneralInfoCard({super.key, required this.plan});

  @override
  State<DietitianDetailsGeneralInfoCard> createState() => _DietitianDetailsGeneralInfoCardState();
}

class _DietitianDetailsGeneralInfoCardState extends State<DietitianDetailsGeneralInfoCard> { 

    DietPlanService _dietPlanService = DietPlanService();
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Belirtilmemiş';
    try {
      final datePart =
          dateString.contains('T') ? dateString.split('T')[0] : dateString;
      final dateTime = DateTime.parse(datePart);
      return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.grey,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: DetailsStatusBadge(status: widget.plan.status),
                ),
                PopupMenuButton<String>( 

                  color: AppColor.primary,
                  iconColor: AppColor.black,
                  onSelected: (String result) async {
                  if (result == 'Edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddDietPlanScreen(
                            clientId: widget.plan.clientId,
                            dietPlan: widget.plan,
                          ),
                        ),
                      );
                    } else if (result == 'Delete') {
                      
                    final String? token =await AuthStorage.getToken();
                     var response = _dietPlanService.deleteDietPlan(token: token!,dietplanid: widget.plan.id);
                     print(response); 
                     Navigator.pop(context);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('✏️ Düzenle',style: TextStyle(color: Colors.white),),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('🗑️ Sil',style: TextStyle(color: Colors.white),),
                    ),
                   
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            DetailsInfoRow(
              icon: Icons.calendar_today_outlined,
              label: "Başlangıç Tarihi:",
              value: _formatDate(widget.plan.startDate),
            ),
            const SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.event_available_outlined,
              label: "Bitiş Tarihi:",
              value: _formatDate(widget.plan.endDate),
            ),
            const SizedBox(height: 10),
            DetailsInfoRow(
              icon: Icons.local_fire_department_outlined,
              label: "Günlük Kalori:",
              value: "${widget.plan.dailyCalories} kcal",
            ),
            if (widget.plan.notes.isNotEmpty) ...[
              Divider(
                  color: AppColor.greyLight.withValues(alpha: 0.5),
                  height: 25,
                  thickness: 1),
              DetailsInfoRow(
                icon: Icons.notes_outlined,
                label: "Notlar:",
                value: widget.plan.notes,
                isMultiline: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
