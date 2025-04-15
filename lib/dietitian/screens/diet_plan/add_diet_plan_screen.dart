import 'package:dietician_app/client/components/shared/build_text_field.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/components/shared/date_time_picker.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/select_date.dart';
import 'package:dietician_app/dietitian/model/diet_plan_model.dart';
import 'package:dietician_app/dietitian/viewmodel/diet_plan_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../components/recipes/recipes_add/error_message.dart';

class AddDietPlanScreen extends StatelessWidget {
  final int clientId;
  final ClientDietPlan? dietPlan; 

  const AddDietPlanScreen({
    super.key,
    required this.clientId,
    this.dietPlan,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddDietPlanScreenViewModel(dietPlan: dietPlan),
      child: Consumer<AddDietPlanScreenViewModel>(
        builder: (context, viewModel, child) {
          return Form(
            key: viewModel.formKey,
            child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(
                title: viewModel.isEditMode
                    ? "Diyet Planını Düzenle"
                    : "Yeni Diyet Planı Oluştur",
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ErrorMessageDisplay(errorMessage: viewModel.errorMessage),
                      buildTextField(
                        controller: viewModel.titleController,
                        label: "Başlık",
                        validator: viewModel.validateRequired,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildDatePickerField(
                              context: context,
                              label: "Başlangıç Tarihi",
                              selectedDate: viewModel.selectedStartDate,
                              onTap: () async {
                                await DatePickerHelper.selectDate(
                                  context: context,
                                  selectedStartDate: viewModel.selectedStartDate,
                                  selectedFinishDate: viewModel.selectedFinishDate,
                                  isStartDate: true,
                                  primaryColor: AppColor.primary,
                                  onDateSelected: (start, finish) {
                                    viewModel.updateDates(start, finish);
                                  },
                                );
                              },
                              icon: Icons.event,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildDatePickerField(
                              context: context,
                              label: "Hedef Tarih",
                              selectedDate: viewModel.selectedFinishDate,
                              onTap: () async {
                                await DatePickerHelper.selectDate(
                                  context: context,
                                  selectedStartDate: viewModel.selectedStartDate,
                                  selectedFinishDate: viewModel.selectedFinishDate,
                                  isStartDate: false,
                                  primaryColor: AppColor.primary,
                                  onDateSelected: (start, finish) {
                                    viewModel.updateDates(start, finish);
                                  },
                                );
                              },
                              icon: Icons.event_available,
                            ),
                          ),
                        ],
                      ),
                      buildTextField(
                        controller: viewModel.caloriesController,
                        label: "Günlük Kalori",
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: viewModel.validateRequiredNumber,
                      ),
                      buildTextField(
                        controller: viewModel.notesController,
                        label: "Not",
                        maxLines: 3,
                        validator: viewModel.validateRequired,
                      ),
                      SwitchListTile(
                        title: Text(
                          "Diyet Planının Durumu",
                          style: AppTextStyles.body1Regular,
                        ),
                        subtitle: Text(
                          viewModel.isPublic
                              ? "Bu diyet planını direkt başlatır."
                              : "Bu diyet planını sonra başlatır.",
                          style: AppTextStyles.body2Regular
                              .copyWith(color: AppColor.secondary),
                        ),
                        value: viewModel.isPublic,
                        onChanged: (value) {
                          viewModel.setIsPublic(value);
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
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                                  final success =
                                      await viewModel.submitForm(clientId);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(viewModel.isEditMode
                                            ? "Diyet planı başarıyla güncellendi!"
                                            : "Diyet planı başarıyla eklendi!"),
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