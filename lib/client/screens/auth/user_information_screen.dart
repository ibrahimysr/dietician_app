import 'package:dietician_app/client/components/user_information/activity_level_page.dart';
import 'package:dietician_app/client/components/user_information/allergy_page.dart';
import 'package:dietician_app/client/components/user_information/birthdate_page.dart';
import 'package:dietician_app/client/components/user_information/gender_page.dart';
import 'package:dietician_app/client/components/user_information/goal_page.dart';
import 'package:dietician_app/client/components/user_information/height_page.dart';
import 'package:dietician_app/client/components/user_information/preference_page.dart';
import 'package:dietician_app/client/components/user_information/weight_page.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/viewmodel/user_info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoScreen extends StatefulWidget {
  final int userId;

  const UserInfoScreen({super.key, required this.userId});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserInfoViewModel(),
      child: Consumer<UserInfoViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.white,
              elevation: 0,
              title: Text("Bilgilerinizi Girin", style: AppTextStyles.heading2),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: context.paddingLow,
                  child: LinearProgressIndicator(
                    value: (viewModel.currentPage + 1) / viewModel.steps,
                    backgroundColor: AppColor.greyLight,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                    minHeight: 8,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: viewModel.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildBirthDatePage(viewModel),
                      _buildGenderPage(viewModel),
                      _buildHeightPage(viewModel),
                      _buildWeightPage(viewModel),
                      _buildActivityLevelPage(viewModel),
                      _buildGoalPage(viewModel),
                      _buildAllergiesPage(viewModel),
                      _buildPreferencesPage(viewModel),
                      _buildMedicalConditionsPage(viewModel),
                    ],
                  ),
                ),
                Padding(
                  padding: context.paddingLow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (viewModel.currentPage > 0)
                        ElevatedButton(
                          onPressed: viewModel.isLoading ? null : viewModel.previousPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Geri",
                            style: AppTextStyles.body1Medium.copyWith(color: AppColor.black),
                          ),
                        )
                      else
                        const SizedBox(),
                      ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () {
                                if (viewModel.currentPage == viewModel.steps - 1) {
                                  viewModel.submitData(context, widget.userId);
                                } else {
                                  viewModel.nextPage();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: viewModel.isLoading
                            ? CircularProgressIndicator(color: AppColor.white)
                            : Text(
                                viewModel.currentPage == viewModel.steps - 1 ? "Kaydet" : "İleri",
                                style: AppTextStyles.body1Medium.copyWith(color: AppColor.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBirthDatePage(UserInfoViewModel viewModel) {
    return BirthDatePicker(
      initialDate: viewModel.birthDate,
      onDateSelected: viewModel.setBirthDate,
    );
  }

  Widget _buildGenderPage(UserInfoViewModel viewModel) {
    return GenderPicker(
      gender: viewModel.gender,
      onGenderSelected: viewModel.setGender,
    );
  }

  Widget _buildHeightPage(UserInfoViewModel viewModel) {
    return HeightPicker(
      height: viewModel.height,
      onHeightSelected: viewModel.setHeight,
    );
  }

  Widget _buildWeightPage(UserInfoViewModel viewModel) {
    return WeightPicker(
      weight: viewModel.weight,
      onWeightSelected: viewModel.setWeight,
    );
  }

  Widget _buildActivityLevelPage(UserInfoViewModel viewModel) {
    return ActivityLevelSelector(
      activityLevel: viewModel.activityLevel,
      onActivityLevelSelected: viewModel.setActivityLevel,
    );
  }

  Widget _buildGoalPage(UserInfoViewModel viewModel) {
    return GoalSelector(
      goal: viewModel.goal,
      onGoalSelected: viewModel.setGoal,
    );
  }

  Widget _buildAllergiesPage(UserInfoViewModel viewModel) {
    return AllergySelector(
      allergies: viewModel.allergies,
      onAllergiesChanged: viewModel.setAllergies,
    );
  }

  Widget _buildPreferencesPage(UserInfoViewModel viewModel) {
    return PreferenceSelector(
      preferences: viewModel.preferences,
      onPreferenceSelected: viewModel.setPreferences,
    );
  }

  Widget _buildMedicalConditionsPage(UserInfoViewModel viewModel) {
    return Padding(
      padding: context.paddingLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sağlık Sorununuz Var mı?", style: AppTextStyles.heading2),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Örn: Diyabet",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColor.secondary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColor.secondary,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColor.secondary,
                  width: 2,
                ),
              ),
            ),
            onChanged: viewModel.setMedicalConditions,
          ),
        ],
      ),
    );
  }
}