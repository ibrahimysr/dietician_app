
import 'package:dietician_app/client/components/food_log/comparison_section.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/dietitian/components/meal/food_log_section.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:flutter/material.dart';

import 'package:dietician_app/client/models/food_log_model.dart';
import 'package:dietician_app/client/models/compare_diet_plan_model.dart';

import 'package:dietician_app/client/services/food_log/food_log_service.dart';
import 'package:dietician_app/client/core/utils/formatters.dart'; 
import 'package:dietician_app/client/components/food_log/macro_info.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';


class MealDetailScreen extends StatefulWidget {
  final ClientMeal meal;       
  final ClientDietPlan plan; 

  const MealDetailScreen({
    super.key,
    required this.meal,
    required this.plan, 
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final FoodLogService _foodLogService = FoodLogService();

  List<FoodLog> _mealLogs = [];
  bool _isLoadingLogs = true;
  String? _logErrorMessage;

  DietComparisonData? _comparisonData; 
  bool _isLoadingComparison = true;
  String? _comparisonErrorMessage;


  @override
  void initState() {
    super.initState();
    _fetchAllScreenData(); 
  }

  Future<void> _fetchAllScreenData() async {
    if (!mounted) return;
    await Future.wait([
      _fetchFoodLogs(),
      _fetchComparisonData(),
    ]);
  }

  Future<void> _fetchComparisonData() async {
    if (!mounted) return;
    setState(() {
      _isLoadingComparison = true;
      _comparisonErrorMessage = null;
    });

    try {
      final token = await AuthStorage.getToken(); 
      if (token == null) throw Exception("Oturum bulunamadı.");

      final targetDate = DateTime.parse(widget.plan.startDate.split('T')[0])
          .add(Duration(days: widget.meal.dayNumber - 1));

      final response = await _foodLogService.getDietComparison(
        token: token,
        clientId: widget.plan.clientId, 
        date: targetDate,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        _comparisonData = response.data;
      } else {
        _comparisonErrorMessage = response.message.isNotEmpty
            ? response.message
            : "Karşılaştırma verisi alınamadı.";
      }
    } catch (e) {
       if (!mounted) return;
      _comparisonErrorMessage = "Karşılaştırma verisi alınırken hata: ${e.toString()}";
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingComparison = false;
        });
      }
    }
  }


  Future<void> _fetchFoodLogs() async {
    if (!mounted) return;

    setState(() {
      _isLoadingLogs = true;
      _logErrorMessage = null;
    });

    try {
      final token = await AuthStorage.getToken(); 
      if (token == null) {
        throw Exception("Oturum bulunamadı.");
      }

      final targetDate = DateTime.parse(widget.plan.startDate.split('T')[0])
          .add(Duration(days: widget.meal.dayNumber - 1));

      final response = await _foodLogService.getFoodLogDate(
        token: token,
        id: widget.plan.clientId, 
        date: targetDate, 
      );

      if (!mounted) return;

      if (response.success) {
        _mealLogs = response.data
            .where((log) => log.mealType.toLowerCase() == widget.meal.mealType.toLowerCase())
            .toList();
        _mealLogs.sort((a, b) => DateTime.parse(b.loggedAt).compareTo(DateTime.parse(a.loggedAt)));
      } else {
        _logErrorMessage = response.message.isNotEmpty
            ? response.message
            : "Yemek kayıtları alınamadı.";
      }
    } catch (e) {
       if (!mounted) return;
      _logErrorMessage = "Yemek kayıtları getirilirken bir hata oluştu: ${e.toString()}";
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLogs = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    String mealTypeName;
     try {
       mealTypeName = getMealTypeName(widget.meal.mealType);
     } catch(e) {
       mealTypeName = widget.meal.mealType;
     }
    IconData mealTypeIcon;
     try {
       mealTypeIcon = getMealTypeIcon(widget.meal.mealType);
     } catch(e) {
       mealTypeIcon = Icons.restaurant; 
     }

    bool isLoading = _isLoadingLogs || _isLoadingComparison;

    return Scaffold(
      backgroundColor: AppColor.white, 
      appBar: CustomAppBar(title: mealTypeName),
      body: RefreshIndicator(
        onRefresh: _fetchAllScreenData, 
        color: AppColor.secondary,
        child: isLoading && _mealLogs.isEmpty && _comparisonData == null
            ? Center(child: CircularProgressIndicator(color: AppColor.secondary))
            : ListView(
                padding: context.paddingNormal,
                children: [
                  if (widget.meal.photoUrl != null && widget.meal.photoUrl!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: context.getDynamicHeight(2.5)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          widget.meal.photoUrl!,
                          height: context.getDynamicHeight(25),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: context.getDynamicHeight(25),
                              color: AppColor.greyLight.withOpacity(0.3),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: AppColor.secondary,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: context.getDynamicHeight(25),
                            color: AppColor.greyLight.withOpacity(0.3),
                            child: Center(
                              child: Icon(Icons.broken_image_outlined, color: AppColor.grey, size: 40),
                            ),
                          ),
                        ),
                      ),
                    ),

                  Card(
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: AppColor.white, 
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(mealTypeIcon, color: AppColor.secondary, size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  mealTypeName, 
                                  style: AppTextStyles.heading3.copyWith(color: AppColor.secondary),
                                ),
                              ),
                              Text(
                                "Gün ${widget.meal.dayNumber}", 
                                style: AppTextStyles.body1Regular.copyWith(color: AppColor.grey),
                              ),
                            ],
                          ),
                          Divider(height: 25, color: AppColor.greyLight.withOpacity(0.6)),
                          Text(
                            "Planlanan Açıklama:", 
                            style: AppTextStyles.body1Medium.copyWith(color: AppColor.black.withOpacity(0.8)),
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.meal.description.isNotEmpty
                                ? widget.meal.description
                                : "Açıklama belirtilmemiş.", 
                            style: AppTextStyles.body1Regular.copyWith(color: AppColor.black, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.getDynamicHeight(2)),

                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: AppColor.white, 
                    elevation: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Planlanan Besin Değerleri",
                            style: AppTextStyles.heading4.copyWith(color: AppColor.black),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround, 
                            children: [
                              MacroInfo(
                                label: "Kalori",
                                value: "${widget.meal.calories} kcal",
                                valueColor: AppColor.primary,
                              ),
                              MacroInfo(
                                label: "Protein",
                                value: "${widget.meal.protein} g",
                                valueColor: Colors.blue.shade700,
                              ),
                              MacroInfo(
                                label: "Yağ",
                                value: "${widget.meal.fat} g",
                                valueColor: Colors.orange.shade700,
                              ),
                              MacroInfo(
                                label: "Karbonhidrat",
                                value: "${widget.meal.carbs} g",
                                valueColor: Colors.purple.shade700,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.getDynamicHeight(2.5)),

                  FoodLogSection(
                    title: "Danışanın Girdiği Kayıtlar ($mealTypeName)", 
                    mealLogs: _mealLogs,
                    isLoadingLogs: _isLoadingLogs,
                    logErrorMessage: _logErrorMessage,
                    onRefresh: _fetchFoodLogs, 
                    onEdit: null,   
                    onDelete: null,
                    isReadOnly: true, 
                  ),

               ComparisonSection( isLoadingComparison: _isLoadingComparison,
                    comparisonErrorMessage: _comparisonErrorMessage,
                    comparisonData: _comparisonData,mealType:  widget.meal.mealType,),
                  SizedBox(height: context.getDynamicHeight(3)), 
                ],
              ),
      ),
      
    );
  }
}