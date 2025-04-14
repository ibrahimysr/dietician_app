import 'dart:developer';

import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/components/shared/date_time_picker.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/core/utils/parsing.dart';
import 'package:dietician_app/dietitian/service/diet_plan/diet_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/recipes/recipes_add/error_message.dart';

class AddDietPlanScreen extends StatefulWidget {
  const AddDietPlanScreen({super.key});

  @override
  State<AddDietPlanScreen> createState() => _AddDietPlanScreenState();
}

class _AddDietPlanScreenState extends State<AddDietPlanScreen> {
  final DietPlanService _dietPlanService = DietPlanService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedFinishDate;

  bool isPublic = false;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submitForm() async {
    if (_isLoading) return;

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final clientId;
      final token;

      try {
        clientId = 2;
        token = AuthStorage.getToken();
        if (token == null || clientId == null) {
          throw Exception("Kimlik bilgileri alınamadı.");
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage =
                "Oturum bilgileri alınamadı. Lütfen tekrar giriş yapın.";
            _isLoading = false;
          });
        }
        return;
      }

      Map<String, dynamic> dietPlanData = {
        "client_id": 2,
        "title": titleController.text,
        "start_date": selectedStartDate,
        "end_date": selectedFinishDate,
        "daily_calories": int.tryParse(
              caloriesController.text,
            ) ??
            0,
        "notes": notesController.text,
        "status": isPublic,
        "is_ongoing": false
      };

      try {
        final response = await _dietPlanService.addDietPlan(
            token: token, data: dietPlanData);

        if (mounted) {
          if (response?["succes"] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(response?['message'] ?? 'Tarif başarıyla eklendi!'),
                backgroundColor: Colors.green.shade700,
              ),
            );
          }
        }
      } catch (e) {
        log("Veriler Kayıt Edilirken Bir Hata Oluştu:$e");
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    caloriesController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initial =
        (isStartDate ? selectedStartDate : selectedFinishDate) ??
            DateTime.now();
    final DateTime first = DateTime(2020);
    final DateTime last = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          selectedStartDate = picked;
          if (selectedFinishDate != null &&
              selectedFinishDate!.isBefore(picked)) {
            selectedFinishDate = picked;
          }
        } else {
          selectedFinishDate = picked;
          if (selectedStartDate != null && selectedStartDate!.isAfter(picked)) {
            selectedStartDate = picked;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: CustomAppBar(title: "Yeni Diyet Planı Oluştur"),
        body: Padding( 
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [ 
                ErrorMessageDisplay(errorMessage: _errorMessage),
                _buildTextField(
                    controller: titleController,
                    label: "Başlık",
                    validator: validateRequired),
                Row(
                  children: [
                    Expanded(
                      child: buildDatePickerField(
                        context: context,
                        label: "Başlangıç Tarihi",
                        selectedDate: selectedStartDate,
                        onTap: () => selectDate(context, true),
                        icon: Icons.event,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: buildDatePickerField(
                        context: context,
                        label: "Hedef Tarih",
                        selectedDate: selectedFinishDate,
                        onTap: () => selectDate(context, false),
                        icon: Icons.event_available,
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  controller: caloriesController,
                  label: "Günlük Kalori",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: validateRequiredNumber,
                ),
                _buildTextField(
                    controller: notesController,
                    label: "Not",
                    maxLines: 3,
                    validator: validateRequired),
                SwitchListTile(
                  title: Text("Diyet Planının Durumu",
                      style: AppTextStyles.body1Regular),
                  subtitle: Text(
                    isPublic
                        ? "Bu diyet planını direkt başlatır."
                        : "Bu diyet planını sonra başlatır.",
                    style: AppTextStyles.body2Regular
                        .copyWith(color: AppColor.secondary),
                  ),
                  value: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value;
                    });
                  },
                  activeColor: AppColor.primary,
                  contentPadding: EdgeInsets.zero,
                ),
                SizedBox(
                  width: double.infinity,
                  height: context.getDynamicHeight(6),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () { 
            
                        _isLoading ? null : _submitForm();
                      },
                      child: Text(
                        _isLoading ? "Kaydediliyor " : "Kaydet",
                        style: AppTextStyles.body1Medium,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: AppColor.grey,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColor.greyLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColor.primary, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            alignLabelWithHint: maxLines > 1,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          style: AppTextStyles.body1Regular,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          textInputAction:
              maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
        ),
      ),
    );
  }
}
