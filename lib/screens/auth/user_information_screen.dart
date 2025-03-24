import 'package:dietician_app/components/user_information/activity_level_page.dart';
import 'package:dietician_app/components/user_information/allergy_page.dart';
import 'package:dietician_app/components/user_information/birthdate_page.dart';
import 'package:dietician_app/components/user_information/gender_page.dart';
import 'package:dietician_app/components/user_information/goal_page.dart';
import 'package:dietician_app/components/user_information/height_page.dart';
import 'package:dietician_app/components/user_information/preference_page.dart';
import 'package:dietician_app/components/user_information/weight_page.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/screens/auth/login_screen.dart';
import 'package:dietician_app/services/auth/client_service.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  final int userId; 

  const UserInfoScreen({super.key, required this.userId});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? birthDate;
  String? gender;
  double height = 170;
  double weight = 70;
  String? activityLevel;
  String? goal;
  String? allergies;
  String? preferences;
  String? medicalConditions;

  final _steps = 9;
  bool _isLoading = false;

  final _clientService = ClientService();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _steps - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitData();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        throw Exception("Token bulunamadı, lütfen tekrar giriş yapın.");
      }

      if (birthDate == null ||
          gender == null ||
          activityLevel == null ||
          goal == null ||
          allergies == null ||
          preferences == null ||
          medicalConditions == null) {
        throw Exception("Lütfen tüm bilgileri doldurun.");
      }

      final response = await _clientService.addClient(
        userId: widget.userId, 
        dietitianId: null,
        birthDate: birthDate!,
        gender: gender!,
        height: height,
        weight: weight,
        activityLevel: activityLevel!,
        goal: goal!,
        allergies: allergies!,
        preferences: preferences!,
        medicalConditions: medicalConditions!,
        token: token,
      );

      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
         
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bilgiler kaydedilemedi: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              value: (_currentPage + 1) / _steps,
              backgroundColor: AppColor.greyLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
              minHeight: 8,
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBirthDatePage(),
                _buildGenderPage(),
                _buildHeightPage(),
                _buildWeightPage(),
                _buildActivityLevelPage(),
                _buildGoalPage(),
                _buildAllergiesPage(),
                _buildPreferencesPage(),
                _buildMedicalConditionsPage(),
              ],
            ),
          ),
          Padding(
            padding: context.paddingLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _previousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Geri",
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColor.black),
                    ),
                  )
                else
                  const SizedBox(),
                ElevatedButton(
                  onPressed: _isLoading ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ?  CircularProgressIndicator(color: AppColor.white)
                      : Text(
                          _currentPage == _steps - 1 ? "Kaydet" : "İleri",
                          style: AppTextStyles.body1Medium
                              .copyWith(color: AppColor.white),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDatePage() {
    return BirthDatePicker(
      initialDate: birthDate,
      onDateSelected: (selectedDate) {
        setState(() {
          birthDate = selectedDate;
        });
      },
    );
  }

  Widget _buildGenderPage() {
    return GenderPicker(
      gender: gender,
      onGenderSelected: (selectedGender) {
        setState(() {
          gender = selectedGender;
        });
      },
    );
  }

  Widget _buildHeightPage() {
    return HeightPicker(
      height: height,
      onHeightSelected: (selectedHeight) {
        setState(() {
          height = selectedHeight;
        });
      },
    );
  }

  Widget _buildWeightPage() {
    return WeightPicker(
      weight: weight,
      onWeightSelected: (selectedWeight) {
        setState(() {
          weight = selectedWeight;
        });
      },
    );
  }

  Widget _buildActivityLevelPage() {
    return ActivityLevelSelector(
      activityLevel: activityLevel,
      onActivityLevelSelected: (selectedLevel) {
        setState(() {
          activityLevel = selectedLevel;
        });
      },
    );
  }

  Widget _buildGoalPage() {
    return GoalSelector(
      goal: goal,
      onGoalSelected: (selectedGoal) {
        setState(() {
          goal = selectedGoal;
        });
      },
    );
  }

  Widget _buildAllergiesPage() {
    return AllergySelector(
      allergies: allergies,
      onAllergiesChanged: (allergy) {
        setState(() {
          allergies = allergy;
        });
      },
    );
  }

  Widget _buildPreferencesPage() {
    return PreferenceSelector(
      preferences: preferences,
      onPreferenceSelected: (selectedPreference) {
        setState(() {
          preferences = selectedPreference;
        });
      },
    );
  }

  Widget _buildMedicalConditionsPage() {
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
            onChanged: (value) => medicalConditions = value,
          ),
        ],
      ),
    );
  }
}