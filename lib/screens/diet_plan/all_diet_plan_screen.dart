import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class AllDietPlansScreen extends StatelessWidget {
  final List<DietPlan> allPlans;

  const AllDietPlansScreen({super.key, required this.allPlans});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tüm Diyet Planlarım (${allPlans.length})"),
        backgroundColor: AppColor.primary,
      ),
      body: allPlans.isEmpty
          ? Center(child: Text("Gösterilecek diyet planı bulunamadı."))
          : ListView.builder(
              itemCount: allPlans.length,
              itemBuilder: (context, index) {
                final plan = allPlans[index];
              
                 return Card(
                   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                   elevation: 2,
                   child: ListTile(
                     leading: Icon(_getPlanStatusIcon(plan.status), color: _getPlanStatusColor(plan.status)), 
                     title: Text(plan.title, style: TextStyle(fontWeight: FontWeight.w500)),
                     subtitle: Text("Dyt. ${plan.dietitian.user?.name}\nBaşlangıç: ${_formatDate(plan.startDate)} - Bitiş: ${_formatDate(plan.endDate)}"),
                     isThreeLine: true,
                     trailing: Icon(Icons.chevron_right),
                     onTap: () {
                    
                     },
                   ),
                 );
              },
            ),
    );
  }

    IconData _getPlanStatusIcon(String status) {
         switch (status.toLowerCase()) {
          case 'active': return Icons.play_circle_outline;
          case 'paused': return Icons.pause_circle_outline;
          case 'completed': return Icons.check_circle_outline;
          default: return Icons.help_outline;
        }
    }

    Color _getPlanStatusColor(String status) {
        switch (status.toLowerCase()) {
          case 'active': return Colors.green;
          case 'paused': return Colors.orange;
          case 'completed': return AppColor.primary;
          default: return Colors.grey;
        }
    }

     String? _formatDate(String? dateString) {
       if (dateString == null || dateString.isEmpty) return 'N/A';
        try {
           if (dateString.contains('T')) {
               dateString = dateString.split('T')[0];
           }
           final dateTime = DateTime.parse(dateString);
           return "${dateTime.day}.${dateTime.month}.${dateTime.year}";
        } catch (e) {
          return dateString;
        }
     }
}