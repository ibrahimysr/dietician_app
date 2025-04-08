import 'package:collection/collection.dart';
import 'package:dietician_app/components/diet_plan/active_diet_plan.dart';
import 'package:dietician_app/components/food/home_food_preview_section.dart';
import 'package:dietician_app/components/food_log/home_daily_comparison_section.dart';
import 'package:dietician_app/components/meal/home_todays_meals_section.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/generated/asset.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:dietician_app/core/utils/parsing.dart';
import 'package:dietician_app/models/compare_diet_plan_model.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/models/food_model.dart';
import 'package:dietician_app/models/goal_model.dart';
import 'package:dietician_app/screens/goal/all_goal_screen.dart';
import 'package:dietician_app/services/diet_plan/diet_plan_service.dart';
import 'package:dietician_app/services/food/food_service.dart';
import 'package:dietician_app/services/food_log/food_log_service.dart';
import 'package:dietician_app/services/goal/goal_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final DietPlanService _dietPlanService = DietPlanService();
  final FoodService _foodService = FoodService();
  final FoodLogService _foodLogService = FoodLogService();
  final GoalService _goalService = GoalService();

  bool _isDietPlanLoading = true;
  String? _dietPlanErrorMessage;
  List<DietPlan> _allDietPlans = [];
  DietPlan? _activeDietPlan;

  bool _isFoodLoading = true;
  String? _foodErrorMessage;
  List<Food> _allFoods = [];

  bool _isLoadingComparison = true;
  String? _comparisonErrorMessage;
  DietComparisonData? _dailyComparisonData;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late DateTime _currentDate;
  late String _greeting;

  bool _isLoadingGoals = true;
  String? _goalErrorMessage;
  List<Goal> _goals = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _setGreetingMessage();

    _fetchAllData().then((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _setGreetingMessage() {
    _currentDate = DateTime.now();
    final hour = _currentDate.hour;

    if (hour < 12) {
      _greeting = "Günaydın";
    } else if (hour < 18) {
      _greeting = "İyi Günler";
    } else {
      _greeting = "İyi Akşamlar";
    }
  }

  Future<void> _fetchAllData() async {
    setState(() {
      _isDietPlanLoading = true;
      _isFoodLoading = true;
      _isLoadingComparison = true;
      _isLoadingGoals = true;
      _dietPlanErrorMessage = null;
      _foodErrorMessage = null;
      _comparisonErrorMessage = null;
      _goalErrorMessage = null;
    });

    await Future.wait([
      _fetchDietPlans(),
      _fetchFoods(),
      _fetchDailyComparison(),
      _fetchGoals(),
    ]);

    if (mounted) {}
  }

  Future<void> _fetchGoals() async {
    setState(() {
      _goalErrorMessage = null;
    });

    final token = await AuthStorage.getToken();
    if (token == null) {
      if (mounted)
        setState(() {
          _isLoadingGoals = false;
          _goalErrorMessage = "Oturum bulunamadı (Hedefler).";
        });
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      if (mounted)
        setState(() {
          _isLoadingGoals = false;
          _goalErrorMessage = "Kullanıcı ID bulunamadı (Hedefler).";
        });
      return;
    }

    try {
      final response =
          await _goalService.getGoals(token: token, clientId: clientId);
      if (!mounted) return;
      if (response.success) {
        _goals = response.data;
      } else {
        _goalErrorMessage = response.message;
      }
    } catch (e) {
      if (!mounted) return;
      _goalErrorMessage = "Hedefler alınırken hata oluştu: ${e.toString()}";
    } finally {
      if (mounted)
        setState(() {
          _isLoadingGoals = false;
        });
    }
  }

  Future<void> _fetchDietPlans() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      setState(() {
        _isDietPlanLoading = false;
        _dietPlanErrorMessage = "Oturum bulunamadı, lütfen giriş yapın.";
      });
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      setState(() {
        _isDietPlanLoading = false;
        _dietPlanErrorMessage = "Kullanıcı ID bulunamadı.";
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isDietPlanLoading = true;
      _dietPlanErrorMessage = null;
    });

    try {
      final response =
          await _dietPlanService.getDietPlan(id: clientId, token: token);

      if (!mounted) return;

      if (response.success) {
        _allDietPlans = response.data;
        _activeDietPlan = _allDietPlans
            .firstWhereOrNull((plan) => plan.status.toLowerCase() == 'active');
        setState(() {
          _isDietPlanLoading = false;
        });
      } else {
        setState(() {
          _dietPlanErrorMessage = response.message;
          _isDietPlanLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _dietPlanErrorMessage =
            "Diyet planları yüklenirken bir hata oluştu: ${e.toString()}";
        _isDietPlanLoading = false;
      });
    }
  }

  Future<void> _fetchFoods() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      setState(() {
        _isFoodLoading = false;
        _foodErrorMessage = "Oturum bulunamadı (besinler için).";
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isFoodLoading = true;
      _foodErrorMessage = null;
    });

    try {
      final response = await _foodService.getFood(token: token);
      if (!mounted) return;

      if (response.success) {
        setState(() {
          _allFoods = response.data;
          _isFoodLoading = false;
        });
      } else {
        setState(() {
          _foodErrorMessage = response.message;
          _isFoodLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _foodErrorMessage =
            "Besinler yüklenirken bir hata oluştu: ${e.toString()}";
        _isFoodLoading = false;
      });
    }
  }

  Future<void> _fetchDailyComparison() async {
    setState(() {
      _comparisonErrorMessage = null;
    });

    final token = await AuthStorage.getToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          _isLoadingComparison = false;
          _comparisonErrorMessage = "Oturum bulunamadı.";
        });
      }
      return;
    }
    final int? clientId = await AuthStorage.getId();
    if (clientId == null || clientId == 0) {
      if (mounted) {
        setState(() {
          _isLoadingComparison = false;
          _comparisonErrorMessage = "Kullanıcı ID bulunamadı.";
        });
      }
      return;
    }

    try {
      final today = DateTime.now();
      final response = await _foodLogService.getDietComparison(
        token: token,
        clientId: clientId,
        date: today,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        _dailyComparisonData = response.data;
      } else {
        _comparisonErrorMessage = response.message;
      }
    } catch (e) {
      if (!mounted) return;
      _comparisonErrorMessage = "Günlük özet alınamadı: ${e.toString()}";
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingComparison = false;
        });
      }
    }
  } 

  Future<void> _markGoalAsCompleted(int goalId) async {
   final token = await AuthStorage.getToken();
   if (token == null) {
      print("Tamamlama için token bulunamadı.");
      return;
   }
   try {
      print("Hedef $goalId tamamlandı olarak işaretleniyor...");
      await _goalService.updateGoal(
         token: token,
         goalId: goalId,
         updateData: {'status': 'completed'}
      );
      print("Hedef $goalId durumu güncellendi (veya API çağrısı yapıldı).");
   } catch (e) {
      print("Hedef tamamlandı olarak işaretlenirken hata: $e");
   }
} 


double calculateProgressManually({required double currentValue, double? targetValue, double? initialValue}) {
     if (targetValue == null) return 0.0;
     if (targetValue == (initialValue ?? currentValue) ) return (currentValue == targetValue) ? 1.0 : 0.0; 

     bool targetReached = false;
     if(targetValue < (initialValue ?? currentValue)) { 
        targetReached = currentValue <= targetValue;
     } else { 
        targetReached = currentValue >= targetValue;
     }
     return targetReached ? 1.0 : 0.0; 
}

  @override
  Widget build(BuildContext context) {
    List<String> errorMessages = [
      if (_dietPlanErrorMessage != null) "Diyet Planı: $_dietPlanErrorMessage",
      if (_foodErrorMessage != null) "Besinler: $_foodErrorMessage",
      if (_comparisonErrorMessage != null) "Özet: $_comparisonErrorMessage",
      if (_goalErrorMessage != null) "Hedefler: $_goalErrorMessage",
    ];
    String? combinedErrorMessage =
        errorMessages.isNotEmpty ? errorMessages.join('\n') : null;

    bool isInitialLoading = _isDietPlanLoading &&
        _isFoodLoading &&
        _isLoadingComparison &&
        _isLoadingGoals &&
        _allDietPlans.isEmpty &&
        _allFoods.isEmpty &&
        _dailyComparisonData == null &&
        _goals.isEmpty;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: _buildAnimatedAppBar(),
      body: Padding(
        padding: context.paddingNormal,
        child: RefreshIndicator(
          onRefresh: _fetchAllData,
          color: AppColor.primary,
          child: isInitialLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColor.primary))
              : combinedErrorMessage != null &&
                      _allDietPlans.isEmpty &&
                      _allFoods.isEmpty &&
                      _dailyComparisonData == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Veriler yüklenirken hata oluştu:\n$combinedErrorMessage'),
                          ElevatedButton(
                            onPressed: _fetchAllData,
                            child: Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        SizedBox(height: context.getDynamicHeight(2)),
                        _buildSearchBar(),
                        SizedBox(height: context.getDynamicHeight(3)),
                        ActiveDietPlanSection(
                          isLoading: _isDietPlanLoading,
                          errorMessage: _dietPlanErrorMessage,
                          allDietPlans: _allDietPlans,
                          activeDietPlan: _activeDietPlan,
                          onRetry: _fetchDietPlans,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                        TodaysMealsSection(
                          activeDietPlan: _activeDietPlan,
                          isLoading: _isDietPlanLoading,
                          errorMessage: _dietPlanErrorMessage,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                        DailyComparisonSection(
                          isLoadingComparison: _isLoadingComparison,
                          comparisonErrorMessage: _comparisonErrorMessage,
                          dailyComparisonData: _dailyComparisonData,
                          onRetry: _fetchDailyComparison,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                        _buildGoalsSection(),
                        SizedBox(height: context.getDynamicHeight(3)),
                        FoodPreviewSection(
                          isLoading: _isFoodLoading,
                          errorMessage: _foodErrorMessage,
                          allFoods: _allFoods,
                        ),
                        SizedBox(height: context.getDynamicHeight(3)),
                      ],
                    ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.primary, AppColor.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColor.white),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: AppColor.white),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppColor.white,
            radius: 18,
            child: Lottie.asset(
              AppAssets.loginAnimation,
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
      centerTitle: false,
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$_greeting İbrahim 👋",
              style: AppTextStyles.heading3.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${_currentDate.day}/${_currentDate.month}/${_currentDate.year}",
              style: AppTextStyles.body1Medium.copyWith(color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
    final activeGoals = _goals
        .where((g) => g.status.toLowerCase() == 'in_progress')
        .take(3)
        .toList();
    final hasMoreGoals = _goals.length > 0 ||
        _goals.any((g) => g.status.toLowerCase() != 'in_progress');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Aktif Hedefler", style: AppTextStyles.heading4),
            if (hasMoreGoals)
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AllGoalsScreen()))
                      .then((_) => _fetchGoals());
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact),
                child: Text("Tümünü Gör",
                    style: AppTextStyles.body1Medium
                        .copyWith(color: AppColor.primary)),
              ),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(1.5)),
        if (_isLoadingGoals)
          Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                      color: AppColor.primary.withOpacity(0.7))))
        else if (_goalErrorMessage != null)
          Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Hedefler yüklenemedi.",
                      style: TextStyle(color: Colors.redAccent))))
        else if (_goals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
            decoration: BoxDecoration(
                color: AppColor.grey?.withAlpha(50), 
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppColor.grey!.withAlpha(100), width: 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag_outlined, color: AppColor.greyLight, size: 20),
                SizedBox(width: 10),
                Text(
                  "Şu anda aktif bir hedefiniz bulunmuyor.",
                  style: AppTextStyles.body1Regular
                      .copyWith(color: AppColor.greyLight),
                ),
              ],
            ),
          )
        else if (activeGoals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColor.grey?.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Şu anda devam eden bir hedefiniz yok.\nTüm hedeflerinizi görmek için 'Tümünü Gör'e dokunun.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Regular
                  .copyWith(color: AppColor.greyLight),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: activeGoals.length,
            itemBuilder: (context, index) {
              return _buildHomeScreenGoalItem(activeGoals[index]);
            },
          )
      ],
    );
  }

  Widget _buildHomeScreenGoalItem(Goal goal) {
    double progress = goal.calculatedProgress;
    Color progressColor =
        Color.lerp(Colors.orange, AppColor.primary, progress) ??
            AppColor.primary;
    String currentValueStr = goal.currentValue?.toStringAsFixed(0) ?? '-';
    String targetValueStr = goal.targetValue?.toStringAsFixed(0) ?? '-';
    String unitStr = goal.unit ?? '';

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: context.getDynamicHeight(1.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.flag_outlined, color: progressColor, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(goal.title,
                      style: AppTextStyles.body1Medium
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
                IconButton(
                  icon: Icon(Icons.edit_note,
                      color: AppColor.secondary, size: 24),
                  tooltip: "İlerlemeyi Güncelle",
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () =>
                      _showUpdateProgressDialog(goal), 
                )
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$currentValueStr / $targetValueStr $unitStr",
                  style: AppTextStyles.body1Regular
                      .copyWith(color: AppColor.black.withValues(alpha: 0.8)),
                ),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%", 
                  style: AppTextStyles.body1Medium.copyWith(
                      color: progressColor, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: progressColor.withOpacity(0.2),
              ),
            ),
            if (targetValueStr.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(targetValueStr,
                        style: AppTextStyles.body1Medium
                            .copyWith(color: AppColor.greyLight))),
              ),
          ],
        ),
      ),
    );
  }

  void _showUpdateProgressDialog(Goal goal) {
   showDialog<double>(
      context: context,
      builder: (dialogContext) {
         return _UpdateGoalProgressDialog(
            goal: goal,
            onSave: (newValue) async { 
               Navigator.pop(dialogContext); 

                showDialog(context: context, barrierDismissible: false, builder: (ctx)=> Center(child: CircularProgressIndicator()));

               final token = await AuthStorage.getToken();
               if(token == null) {
                   Navigator.pop(context); 
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Oturum bulunamadı"), backgroundColor: Colors.red));
                   return;
               }

               GoalResponse updateResponse;
               try {
                  updateResponse = await _goalService.updateGoal(
                     token: token,
                     goalId: goal.id,
                     updateData: {'current_value': newValue}
                  );
                  Navigator.pop(context); 
                  if (!mounted) return;

                  if(updateResponse.success){
                      Goal? updatedGoal = updateResponse.data;
                      bool shouldMarkCompleted = false;
                      if (updatedGoal != null && updatedGoal.calculatedProgress >= 1.0 && updatedGoal.status.toLowerCase() == 'in_progress') {
                          shouldMarkCompleted = true;
                      } else if (updatedGoal == null) { 
                           double tempProgress = goal.targetValue != null && goal.targetValue != 0
                                                ? (newValue / goal.targetValue!).clamp(0.0, 1.0) 
                                                : (newValue >= (goal.targetValue ?? 0) ? 1.0 : 0.0); 
                           if (tempProgress >= 1.0 && goal.status.toLowerCase() == 'in_progress') {
                               shouldMarkCompleted = true;
                           }
                      }

                      if (shouldMarkCompleted) {
                         await _markGoalAsCompleted(goal.id);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("İlerleme güncellendi."), backgroundColor: Colors.green));
                       await _fetchGoals(); 

                  } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(updateResponse.message), backgroundColor: Colors.red));
                  }
               } catch(e){
                    Navigator.pop(context);
                     if (!mounted) return;
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Güncelleme hatası: $e"), backgroundColor: Colors.red));
               }
            },
         ); 
      },
   );
  
}
}

Widget _buildSearchBar() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: AppColor.grey),
    child: TextFormField(
      decoration: InputDecoration(
        hintText: "Diyet planı ara...",
        prefixIcon: Icon(Icons.search, color: AppColor.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      ),
      onChanged: (value) {},
    ),
  );
}



class _UpdateGoalProgressDialog extends StatefulWidget {
  final Goal goal;
  final Function(double newValue) onSave;

  const _UpdateGoalProgressDialog({
    required this.goal,
    required this.onSave,
  });

  @override
  State<_UpdateGoalProgressDialog> createState() => _UpdateGoalProgressDialogState();
}

class _UpdateGoalProgressDialogState extends State<_UpdateGoalProgressDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.goal.currentValue?.toStringAsFixed(
        (widget.goal.unit?.toLowerCase() == 'adım' || (widget.goal.currentValue ?? 0) % 1 == 0) ? 0 : 1 
      ) ?? ''
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newValue = parseDouble(_valueController.text); 
      if (newValue != null) {
        widget.onSave(newValue); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("İlerlemeyi Güncelle"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.goal.title, style: AppTextStyles.body1Medium, textAlign: TextAlign.center),
              SizedBox(height: 15),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: "Mevcut Değer (${widget.goal.unit ?? ''})",
                  border: OutlineInputBorder(), 
                ),
                keyboardType: TextInputType.numberWithOptions(
                   decimal: !(widget.goal.unit?.toLowerCase() == 'adım')
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Değer gerekli.';
                  final val = parseDouble(value);
                  if (val == null) return 'Geçerli bir sayı girin.';
                  if (val < 0) return 'Değer negatif olamaz.';
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: Text("İptal"),
        ),
        ElevatedButton(
          onPressed: _submit, 
          child: Text("Kaydet"),
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary, foregroundColor: Colors.white),
        )
      ],
    );
  }
}