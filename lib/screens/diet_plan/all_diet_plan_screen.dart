import 'package:dietician_app/components/diet_plan/empty_state.dart';
import 'package:dietician_app/components/diet_plan/filter_chips.dart';
import 'package:dietician_app/components/diet_plan/plan_card.dart';

import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:flutter/material.dart';

class AllDietPlansScreen extends StatefulWidget {
  final List<DietPlan> allPlans;

  const AllDietPlansScreen({super.key, required this.allPlans});

  @override
  State<AllDietPlansScreen> createState() => _AllDietPlansScreenState();
}

class _AllDietPlansScreenState extends State<AllDietPlansScreen> {
  String _filterStatus = 'all';
  late List<DietPlan> _filteredPlans;

  @override
  void initState() {
    super.initState();
    _filteredPlans = widget.allPlans;
  }

  void _filterPlans(String status) {
    setState(() {
      _filterStatus = status;
      if (status == 'all') {
        _filteredPlans = widget.allPlans;
      } else {
        _filteredPlans = widget.allPlans
            .where((plan) => plan.status.toLowerCase() == status.toLowerCase())
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        title: Text(
          "Diyet Planlarım",
          style: AppTextStyles.heading3.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "${widget.allPlans.length} Plan",
                  style:
                      AppTextStyles.body2Medium.copyWith(color: AppColor.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FilterChips(
            filterStatus: _filterStatus,
            onFilterSelected: _filterPlans,
          ),
          Expanded(
            child: _filteredPlans.isEmpty
                ? EmptyState(filterStatus: _filterStatus)
                : ListView.builder(
                    padding: EdgeInsets.only(top: 12, bottom: 16),
                    itemCount: _filteredPlans.length,
                    itemBuilder: (context, index) {
                      return PlanCard(plan: _filteredPlans[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
