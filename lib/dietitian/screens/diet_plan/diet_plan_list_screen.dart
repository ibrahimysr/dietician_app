
import 'dart:developer';

import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/dietitian/components/diet_plan/plan_card.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:dietician_app/dietitian/screens/diet_plan/add_diet_plan_screen.dart';
import 'package:dietician_app/dietitian/service/diet_plan/diet_plan_service.dart';
import 'package:flutter/material.dart';

import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/components/diet_plan/filter_chips.dart'; 
import 'package:dietician_app/client/components/diet_plan/empty_state.dart'; 
import 'package:dietician_app/client/core/theme/color.dart'; 

class ClientDietPlansScreen extends StatefulWidget {
  final int clientId; 

  const ClientDietPlansScreen({super.key, required this.clientId});

  @override
  State<ClientDietPlansScreen> createState() => _ClientDietPlansScreenState();
}

class _ClientDietPlansScreenState extends State<ClientDietPlansScreen> {
  final DietPlanService _dietPlanService = DietPlanService();

  bool _isLoading = true;
  String? _errorMessage;
  List<ClientDietPlan> _allPlans = [];
  List<ClientDietPlan> _filteredPlans = []; 
  String _filterStatus = 'all';
  @override
  void initState() {
    super.initState();
    _fetchPlans(); 
  }

  Future<void> _fetchPlans() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        throw Exception("Kimlik doğrulama anahtarı bulunamadı.");
      }

      final response = await _dietPlanService.getClientDietPlans(
        clientId: widget.clientId, 
        token: token,
      );

      if (!mounted) return;

      if (response.success) {
        setState(() {
          _allPlans = response.data;
          _filterPlans(_filterStatus); 
          _isLoading = false;
        });
      } else {
        throw Exception(response.message.isNotEmpty ? response.message : "Planlar yüklenemedi.");
      }
    } catch (e) {
      log("Planları çekerken hata: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Planlar yüklenirken bir sorun oluştu: ${e.toString()}";
          _isLoading = false;
        });
      }
    }
  }

  void _filterPlans(String status) {
    setState(() {
      _filterStatus = status;
      if (status == 'all') {
        _filteredPlans = List.from(_allPlans); 
      } else {
        _filteredPlans = _allPlans
            .where((plan) => plan.status.toLowerCase() == status.toLowerCase())
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: "Danışan Diyet Planları"), 
      body: RefreshIndicator(
        onRefresh: _fetchPlans,
        child: _buildBody()), 
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        onPressed: (){

          Navigator.push(context, MaterialPageRoute(builder: (context) => AddDietPlanScreen(clientId: widget.clientId,),));
         },child: Icon(Icons.add, color: Colors.white,),),
    ); 

    
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorWidget(_errorMessage!);
    }

    return Column(
      children: [
        FilterChips(
          filterStatus: _filterStatus,
          onFilterSelected: _filterPlans,
        ),
        Expanded(
          child: _filteredPlans.isEmpty
              ? EmptyState(filterStatus: _filterStatus) 
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 16, left: 16, right: 16),
                  itemCount: _filteredPlans.length,
                  itemBuilder: (context, index) {
                    return DietitianPlanCard(plan: _filteredPlans[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String message) {
     return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 60),
              const SizedBox(height: 15),
              Text(
                "Hata Oluştu",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                 icon: const Icon(Icons.refresh),
                 label: const Text("Tekrar Dene"),
                 onPressed: _fetchPlans, 
                 style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                 ),
              )
            ],
          ),
        ),
      );
  }
}