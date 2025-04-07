import 'package:dietician_app/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/extension/context_extension.dart'; 
import 'package:collection/collection.dart';

class DietPlanDetailScreen extends StatelessWidget {
  final DietPlan plan;

  const DietPlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final groupedMeals = groupBy(plan.meals, (Meal meal) => meal.dayNumber);
    final sortedDays = groupedMeals.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(
          plan.title,
          style: AppTextStyles.heading3.copyWith(color: AppColor.white),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: IconThemeData(color: AppColor.white), 
        centerTitle: true, 
      ),
      body: ListView(
        padding: context.paddingNormal, 
        children: [
          _buildSectionHeader("Genel Bilgiler"),
          _buildGeneralInfoCard(context),
          SizedBox(height: context.getDynamicHeight(2.5)),

          _buildSectionHeader("Diyetisyen Bilgileri"),
          _buildDietitianCard(context),
          SizedBox(height: context.getDynamicHeight(2.5)),

          _buildSectionHeader("Öğünler"),
          if (plan.meals.isEmpty)
            _buildEmptyMealsCard()
          else
            ...sortedDays.map((dayNumber) {
              final mealsForDay = groupedMeals[dayNumber]!;
              mealsForDay.sort((a, b) => getMealTypeOrder(a.mealType).compareTo(getMealTypeOrder(b.mealType)));

              return _buildDayMealsCard(context, dayNumber, mealsForDay);
            }).expand((widget) => [widget, SizedBox(height: context.getDynamicHeight(1.5))]), 

           SizedBox(height: context.getDynamicHeight(2))
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0), 
      child: Text(
        title,
        style: AppTextStyles.heading3.copyWith(color: AppColor.black),
      ),
    );
  }

  Widget _buildGeneralInfoCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.white, 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Align(
               alignment: Alignment.centerRight,
               child: _buildStatusBadge(plan.status)
             ),
            SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: "Başlangıç Tarihi:",
              value: _formatDate(plan.startDate),
            ),
            SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.event_available_outlined,
              label: "Bitiş Tarihi:",
              value: _formatDate(plan.endDate),
            ),
            SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.local_fire_department_outlined,
              label: "Günlük Kalori:",
              value: "${plan.dailyCalories} kcal",
            ),
            SizedBox(height: 10),
             if (plan.notes.isNotEmpty) ...[ 
              Divider(color: AppColor.greyLight.withValues(alpha:0.5), height: 20),
              _buildInfoRow(
                icon: Icons.notes_outlined,
                label: "Notlar:",
                value: plan.notes,
                isMultiline: true, 
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDietitianCard(BuildContext context) {
    final user = plan.dietitian.user; 
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       color: AppColor.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             _buildInfoRow(
               icon: Icons.person_pin_outlined,
               label: "Adı:",
               value: "Dyt. ${user?.name ?? 'Belirtilmemiş'}", 
             ),
             SizedBox(height: 10),
             _buildInfoRow(
               icon: Icons.email_outlined,
               label: "E-posta:",
               value: user?.email ?? 'N/A',
             ),
             SizedBox(height: 10),
             _buildInfoRow(
               icon: Icons.phone_outlined,
               label: "Telefon:",
               value: user?.phone ?? 'N/A',
             ),
             SizedBox(height: 10),
              _buildInfoRow(
               icon: Icons.star_border_outlined,
               label: "Uzmanlık:",
               value: plan.dietitian.specialty.isNotEmpty ? plan.dietitian.specialty : 'Belirtilmemiş',
             ),
              SizedBox(height: 10),
               if (plan.dietitian.bio.isNotEmpty) ...[ 
                  Divider(color: AppColor.greyLight.withValues(alpha:0.5), height: 20),
                 _buildInfoRow(
                   icon: Icons.info_outline,
                   label: "Bio:",
                   value: plan.dietitian.bio,
                   isMultiline: true,
                 ),
               ]
           ],
        ),
      ),
    );
  }

    Widget _buildEmptyMealsCard() {
      return Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: AppColor.grey?.withValues(alpha:0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.no_food_outlined, color: AppColor.greyLight, size: 20),
                SizedBox(width: 10),
                Text(
                  "Bu plan için öğün bulunmamaktadır.",
                  style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
                ),
              ],
            ),
          ),
        );
    }

   Widget _buildDayMealsCard(BuildContext context, int dayNumber, List<Meal> meals) {
     return Card(
       elevation: 2.0,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       color: AppColor.white,
       clipBehavior: Clip.antiAlias, 
       child: ExpansionTile(
         title: Text("Gün $dayNumber", style: AppTextStyles.heading4.copyWith(color: AppColor.black)),
         initiallyExpanded: dayNumber == 1,
         backgroundColor: AppColor.grey?.withValues(alpha:0.1), 
         collapsedBackgroundColor: AppColor.white,
          shape: Border(), 
          collapsedShape: Border(), 
         childrenPadding: EdgeInsets.only(bottom: 10, left: 16, right: 16), 
         children: meals.map((meal) => _buildMealItem(context, meal)).toList(),
       ),
     );
   }

  Widget _buildMealItem(BuildContext context, Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            getMealTypeName(meal.mealType),
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.secondary, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            meal.description,
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
          ),
           SizedBox(height: 8),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               _buildMacroInfo("Kalori", "${meal.calories} kcal"),
               _buildMacroInfo("P", "${meal.protein}g"), 
               _buildMacroInfo("Y", "${meal.fat}g"),     
               _buildMacroInfo("K", "${meal.carbs}g"),     
             ],
           ),
       
          Divider(color: AppColor.grey?.withValues(alpha:0.3), height: 20), 
        ],
      ),
    );
  }

   Widget _buildMacroInfo(String label, String value) {
     return Column(
       children: [
          Text(label, style: AppTextStyles.body2Medium.copyWith(color: AppColor.greyLight)),
          SizedBox(height: 2),
          Text(value, style: AppTextStyles.body1Medium.copyWith(color: AppColor.black)),
       ],
     );
   }


  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppColor.secondary), 
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body2Regular.copyWith(color: AppColor.greyLight), 
              ),
              SizedBox(height: isMultiline ? 4 : 2),
              Text(
                value,
                style: AppTextStyles.body1Medium.copyWith(color: AppColor.black), 
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

   Widget _buildStatusBadge(String status) {
     IconData icon;
     Color color;
     Color textColor;
     String text;

     switch (status.toLowerCase()) {
       case 'active':
         icon = Icons.play_circle_fill;
         color = Colors.green;
         text = "Aktif";
         textColor = Colors.green.shade800;
         break;
       case 'paused':
         icon = Icons.pause_circle_filled;
         color = Colors.orange;
         text = "Duraklatıldı";
         textColor = Colors.orange.shade800;
         break;
       case 'completed':
         icon = Icons.check_circle;
         color = AppColor.secondary;
         text = "Tamamlandı";
         textColor = AppColor.secondary;
         break;
       default:
         icon = Icons.help_outline;
         color = Colors.grey.shade400;
         text = status.isNotEmpty
             ? status[0].toUpperCase() + status.substring(1)
             : 'Bilinmiyor';
         textColor = Colors.grey.shade700;
     }

     return Container(
       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
       decoration: BoxDecoration(
         color: color.withValues(alpha:0.15),
         borderRadius: BorderRadius.circular(20),
       ),
       child: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           Icon(icon, color: textColor, size: 16),
           const SizedBox(width: 6),
           Text(
             text,
             style: AppTextStyles.body1Medium 
                 .copyWith(color: textColor, fontWeight: FontWeight.w600),
           ),
         ],
       ),
     );
   }

   String _formatDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return 'Belirtilmemiş';
     try {
       final datePart = dateString.split('T')[0];
       final dateTime = DateTime.parse(datePart);
       return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
     } catch (e) {
       return dateString;
     }
   }

 

}