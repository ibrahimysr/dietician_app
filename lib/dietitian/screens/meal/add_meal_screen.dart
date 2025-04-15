import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/parsing.dart';
import 'package:dietician_app/dietitian/components/recipes/recipes_add/error_message.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:dietician_app/dietitian/viewmodel/add_meal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../client/components/shared/build_text_field.dart';

class AddMealScreen extends StatelessWidget {
  final int dietPlanId;
  final ClientMeal? meal;
  const AddMealScreen({super.key, this.meal, required this.dietPlanId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddMealScreenViewModel(meal: meal, dietPlanId: dietPlanId),
      child: Consumer<AddMealScreenViewModel>(
        builder: (context, viewModel, child) {
          return Form(
            key: viewModel.formKey,
            child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(
                title: viewModel.isEditMode
                    ? "Öğün Planını Düzenle"
                    : "Yeni Öğün Planı Oluştur",
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ErrorMessageDisplay(errorMessage: viewModel.errorMessage),
                      DropdownButtonFormField<String>(
                        value: viewModel.selectedMealType,
                        decoration: InputDecoration(
                          labelText: "Öğün Türü",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 16.0,
                          ),
                        ),
                        items: viewModel.mealTypeOptions.map((String mealType) {
                          return DropdownMenuItem<String>(
                            value: mealType,
                            child: Text(mealType),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          viewModel.setMealType(newValue);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Lütfen bir öğün türü seçin";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        controller: viewModel.description,
                        label: "Açıklama",
                        validator: validateRequired,
                      ),
                      buildTextField(
                        controller: viewModel.dayNumber,
                        label: "Gün",
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: validateRequiredNumber,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: viewModel.calories,
                              label: "Kalori",
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: validateRequiredNumber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildTextField(
                              controller: viewModel.protein,
                              label: "Protein",
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: validateRequiredNumber,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: viewModel.fat,
                              label: "Yağ",
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: validateRequiredNumber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildTextField(
                              controller: viewModel.carbs,
                              label: "Karbonhidrat",
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: validateRequiredNumber,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: context.getDynamicHeight(6),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                                  final success = await viewModel.submitForm();
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(viewModel.isEditMode
                                            ? "Öğün planı başarıyla güncellendi!"
                                            : "Öğün planı başarıyla eklendi!"),
                                        backgroundColor: Colors.green.shade700,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                          child: Text(
                            viewModel.isLoading
                                ? viewModel.isEditMode
                                    ? "Güncelleniyor..."
                                    : "Kaydediliyor..."
                                : viewModel.isEditMode
                                    ? "Güncelle"
                                    : "Kaydet",
                            style: AppTextStyles.body1Medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}