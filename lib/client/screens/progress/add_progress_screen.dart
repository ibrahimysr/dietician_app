import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/parsing.dart';
import 'package:dietician_app/client/models/progress_model.dart';
import 'package:dietician_app/client/viewmodel/add_progress_viewmodel.dart';
import 'package:dietician_app/dietitian/components/recipes/recipes_add/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../client/components/shared/build_text_field.dart';

class AddProgressScreen extends StatelessWidget {
  final Progress? progress;
  const AddProgressScreen({super.key, this.progress, });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddProgressViewmodel(progress: progress,),
      child: Consumer<AddProgressViewmodel>(
        builder: (context, viewModel, child) {
          return Form(
            key: viewModel.formKey,
            child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(
                title: viewModel.isEditMode
                    ? "İlerlemeyi Düzenle"
                    : "Yeni İlerleme Oluştur",
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ErrorMessageDisplay(errorMessage: viewModel.errorMessage),
                    buildTextField(
                        controller: viewModel.date,
                        label: "Tarih",
                        validator: validateRequired,
                      ),
                      buildTextField(
                        controller: viewModel.notes,
                        label: "Not",
                        validator: validateRequired,
                      ),
                     
                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: viewModel.weight,
                              label: "Kilo",
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: validateRequiredNumber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildTextField(
                              controller: viewModel.waist,
                              label: "Bel Çevresi",
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
                              controller: viewModel.arm,
                              label: "Kol",
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: validateRequiredNumber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildTextField(
                              controller: viewModel.chest,
                              label: "Göğüs",
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
                              controller: viewModel.hip,
                              label: "Kalça",
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: validateRequiredNumber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildTextField(
                              controller: viewModel.bodyFatPercentage,
                              label: "Yağ Oranı",
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
                                  if (success!) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(viewModel.isEditMode
                                            ? "İlerleme başarıyla güncellendi!"
                                            : "İlerleme başarıyla eklendi!"),
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