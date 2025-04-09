import 'package:dietician_app/components/food_log/comparison_section.dart';
import 'package:dietician_app/components/food_log/edit_log_dialog.dart';
import 'package:dietician_app/components/food_log/food_log_section.dart';
import 'package:dietician_app/components/food_log/macro_info.dart';
import 'package:dietician_app/components/shared/custom_app_bar.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:dietician_app/models/compare_diet_plan_model.dart';
import 'package:dietician_app/models/diet_plan_model.dart';
import 'package:dietician_app/models/food_log_model.dart';
import 'package:dietician_app/services/food_log/food_log_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;
  final DateTime dietPlanStartDate;

  const MealDetailScreen({
    super.key,
    required this.meal,
    required this.dietPlanStartDate,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final FoodLogService _foodLogService = FoodLogService();
  List<FoodLog> _mealLogs = [];
  bool _isLoadingLogs = true;
  String? _logErrorMessage;
  int? _clientId;

  final _formKey = GlobalKey<FormState>();
  String? _newLogFoodDescription;
  double? _newLogQuantity;
  int? _newLogCalories;
  double? _newLogProtein;
  double? _newLogFat;
  double? _newLogCarbs;
  DateTime _newLogLoggedAt = DateTime.now();

  DietComparisonData? _comparisonData;
  bool _isLoadingComparison = true;
  String? _comparisonErrorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllScreenData();
  }

  Future<void> _fetchAllScreenData() async {
    await _fetchClientId();
    if (_clientId != null && mounted) {
      await Future.wait([
        _fetchFoodLogs(),
        _fetchComparisonData(),
      ]);
    } else if (mounted) {
      setState(() {
        _isLoadingLogs = false;
        _isLoadingComparison = false;
        _logErrorMessage = "Kullanıcı kimliği alınamadı.";
        _comparisonErrorMessage = "Kullanıcı kimliği alınamadı.";
      });
    }
  }

  Future<void> _fetchComparisonData() async {
    if (_clientId == null || !mounted) return;
    setState(() {
      _isLoadingComparison = true;
      _comparisonErrorMessage = null;
    });

    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bulunamadı.");

      final targetDate = widget.dietPlanStartDate.add(Duration(days: widget.meal.dayNumber - 1));

      final response = await _foodLogService.getDietComparison(
        token: token,
        clientId: _clientId!,
        date: targetDate,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        _comparisonData = response.data;
      } else {
        _comparisonErrorMessage = response.message;
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

  Future<void> _fetchClientId() async {
    final id = await AuthStorage.getId();
    if (!mounted) return;
    setState(() {
      _clientId = id;
    });
  }

  Future<void> _fetchFoodLogs() async {
    if (_clientId == null || !mounted) return;

    setState(() {
      _isLoadingLogs = true;
      _logErrorMessage = null;
    });

    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        if (!mounted) return;
        setState(() {
          _logErrorMessage = "Oturum bulunamadı.";
          _isLoadingLogs = false;
        });
        return;
      }

      final targetDate = widget.dietPlanStartDate.add(Duration(days: widget.meal.dayNumber - 1));
      DateFormat('yyyy-MM-dd').format(targetDate);

      final response = await _foodLogService.getFoodLogDate(
        token: token,
        id: _clientId!,
        date: targetDate,
      );

      if (!mounted) return;

      if (response.success) {
        _mealLogs = response.data
            .where((log) => log.mealType.toLowerCase() == widget.meal.mealType.toLowerCase())
            .toList();
        _mealLogs.sort((a, b) => DateTime.parse(b.loggedAt).compareTo(DateTime.parse(a.loggedAt)));
      } else {
        _logErrorMessage = response.message;
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

  Future<void> _handleAddFoodLog() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_clientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hata: Kullanıcı kimliği bulunamadı.'),
          backgroundColor: Colors.red));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(color: AppColor.primary)),
    );

    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        Navigator.pop(context);
        throw Exception("Oturum bulunamadı.");
      }

      final targetDate = widget.dietPlanStartDate.add(Duration(days: widget.meal.dayNumber - 1));

      final response = await _foodLogService.addFoodLog(
        token: token,
        clientId: _clientId!,
        date: targetDate,
        mealType: widget.meal.mealType,
        foodDescription: _newLogFoodDescription,
        quantity: _newLogQuantity!,
        calories: _newLogCalories!,
        protein: _newLogProtein,
        fat: _newLogFat,
        carbs: _newLogCarbs,
        loggedAt: _newLogLoggedAt,
      );

      Navigator.pop(context);
      if (!mounted) return;

      if (response.success && response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message), backgroundColor: Colors.green),
        );
        setState(() {
          _mealLogs.insert(0, response.data!);
        });
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt eklenirken bir hata oluştu: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showAddLogDialog() {
    _formKey.currentState?.reset();
    _newLogFoodDescription = null;
    _newLogQuantity = null;
    _newLogCalories = null;
    _newLogProtein = null;
    _newLogFat = null;
    _newLogCarbs = null;
    _newLogLoggedAt = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (stfContext, stfSetState) {
            return AlertDialog(
              title: Text("Yeni Kayıt (${getMealTypeName(widget.meal.mealType)})"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Yemek Açıklaması *'),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) => (value == null || value.trim().isEmpty) ? 'Açıklama gerekli.' : null,
                        onSaved: (value) => _newLogFoodDescription = value?.trim(),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Miktar *', suffixText: 'porsiyon'),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Miktar gerekli.';
                          final qty = double.tryParse(value);
                          if (qty == null || qty <= 0) return 'Geçerli pozitif miktar girin.';
                          return null;
                        },
                        onSaved: (value) => _newLogQuantity = double.tryParse(value!),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Kalori (kcal) *'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Kalori gerekli.';
                          final cal = int.tryParse(value);
                          if (cal == null || cal < 0) return 'Geçerli kalori girin.';
                          return null;
                        },
                        onSaved: (value) => _newLogCalories = int.tryParse(value!),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Prot (g)', suffixText: 'g'),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              validator: (value) => (value != null && value.isNotEmpty && (double.tryParse(value) == null || double.parse(value) < 0)) ? 'Geçersiz' : null,
                              onSaved: (value) => _newLogProtein = (value != null && value.isNotEmpty) ? double.tryParse(value) : null,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Yağ (g)', suffixText: 'g'),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              validator: (value) => (value != null && value.isNotEmpty && (double.tryParse(value) == null || double.parse(value) < 0)) ? 'Geçersiz' : null,
                              onSaved: (value) => _newLogFat = (value != null && value.isNotEmpty) ? double.tryParse(value) : null,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Karb (g)', suffixText: 'g'),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              validator: (value) => (value != null && value.isNotEmpty && (double.tryParse(value) == null || double.parse(value) < 0)) ? 'Geçersiz' : null,
                              onSaved: (value) => _newLogCarbs = (value != null && value.isNotEmpty) ? double.tryParse(value) : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Yenme Zamanı:"),
                        subtitle: Text(DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(_newLogLoggedAt)),
                        trailing: Icon(Icons.edit_calendar, color: AppColor.secondary),
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _newLogLoggedAt,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(Duration(days: 1)),
                            locale: const Locale('tr', 'TR'),
                          );
                          if (selectedDate != null) {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_newLogLoggedAt),
                            );
                            if (selectedTime != null) {
                              stfSetState(() {
                                _newLogLoggedAt = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('İptal', style: TextStyle(color: AppColor.grey)),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary, foregroundColor: AppColor.white),
                  onPressed: _handleAddFoodLog,
                  child: Text('Kaydet'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleDeleteFoodLog(int logId, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Kaydı Sil"),
          content: Text("Bu yemek kaydını silmek istediğinizden emin misiniz? Bu işlem geri alınamaz."),
          actions: <Widget>[
            TextButton(
              child: Text("İptal", style: TextStyle(color: AppColor.greyLight)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text("Sil", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kayıt siliniyor...'), duration: Duration(seconds: 1)));

    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bulunamadı.");

      final response = await _foodLogService.deleteFoodLog(token: token, logId: logId);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message), backgroundColor: Colors.green),
        );
        setState(() {
          _mealLogs.removeAt(index);
        });
        await _fetchComparisonData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt silinirken bir hata oluştu: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _handleUpdateFoodLog({
    required int logId,
    required int index,
    required Map<String, dynamic> updatedData,
    required BuildContext dialogContext,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(child: CircularProgressIndicator(color: AppColor.primary)),
    );

    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        Navigator.pop(context);
        throw Exception("Oturum bulunamadı.");
      }

      final response = await _foodLogService.updateFoodLog(
        token: token,
        logId: logId,
        updateData: updatedData,
      );

      Navigator.pop(context);
      if (!mounted) return;

      if (response.success && response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message), backgroundColor: Colors.green),
        );
        Navigator.pop(dialogContext);
        setState(() {
          _mealLogs[index] = response.data!;
          _mealLogs.sort((a, b) => DateTime.parse(b.loggedAt).compareTo(DateTime.parse(a.loggedAt)));
        });
        await _fetchComparisonData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt güncellenirken bir hata oluştu: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showEditLogDialog(FoodLog logToEdit, int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return EditLogDialog(
          logToEdit: logToEdit,
          onUpdate: (updatedData) {
            _handleUpdateFoodLog(
              logId: logToEdit.id,
              index: index,
              updatedData: updatedData,
              dialogContext: dialogContext,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String mealTypeName = getMealTypeName(widget.meal.mealType);
    bool isLoading = _isLoadingLogs || _isLoadingComparison;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar:CustomAppBar(title: mealTypeName),
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
                              color: AppColor.grey?.withValues(alpha: 0.5),
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
                            color: AppColor.grey?.withValues(alpha: 0.5),
                            child: Center(
                              child: Icon(Icons.broken_image_outlined, color: AppColor.greyLight, size: 40),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: AppColor.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(getMealTypeIcon(widget.meal.mealType), color: AppColor.secondary, size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  mealTypeName,
                                  style: AppTextStyles.heading3.copyWith(color: AppColor.secondary),
                                ),
                              ),
                              Text(
                                "Gün ${widget.meal.dayNumber}",
                                style: AppTextStyles.body1Regular.copyWith(color: AppColor.secondary),
                              ),
                            ],
                          ),
                          Divider(height: 25, color: AppColor.grey?.withValues(alpha: 0.5)),
                          Text(
                            "Açıklama (Planlanan):",
                            style: AppTextStyles.body1Medium.copyWith(color: AppColor.black.withValues(alpha: 0.7)),
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.meal.description,
                            style: AppTextStyles.body1Regular.copyWith(color: AppColor.black, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.getDynamicHeight(2)),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: AppColor.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Besin Değerleri (Planlanan)",
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
                    mealLogs: _mealLogs,
                    isLoadingLogs: _isLoadingLogs,
                    logErrorMessage: _logErrorMessage,
                    onRefresh: _fetchFoodLogs,
                    onEdit: _showEditLogDialog,
                    onDelete: _handleDeleteFoodLog,
                  ),
                  ComparisonSection(
                    isLoadingComparison: _isLoadingComparison,
                    comparisonErrorMessage: _comparisonErrorMessage,
                    comparisonData: _comparisonData,
                    mealType: widget.meal.mealType,
                  ),
                  SizedBox(height: context.getDynamicHeight(3)),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddLogDialog,
        label: Text("Yeni Kayıt Ekle"),
        icon: Icon(Icons.add),
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        tooltip: 'Bu öğün için yediklerinizi kaydedin',
      ),
    );
  }


}