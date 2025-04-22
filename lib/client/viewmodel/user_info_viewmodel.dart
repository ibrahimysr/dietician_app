import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/screens/auth/login_screen.dart';
import 'package:dietician_app/client/services/auth/client_service.dart';
import 'package:flutter/material.dart';

class UserInfoViewModel extends ChangeNotifier {
  final ClientService _clientService = ClientService();

  String? _birthDate;
  String? _gender;
  double _height = 170;
  double _weight = 70;
  String? _activityLevel;
  String? _goal;
  String? _allergies;
  String? _preferences;
  String? _medicalConditions;

  bool _isLoading = false;
  String? _errorMessage;

  final int _steps = 9;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  String? get birthDate => _birthDate;
  String? get gender => _gender;
  double get height => _height;
  double get weight => _weight;
  String? get activityLevel => _activityLevel;
  String? get goal => _goal;
  String? get allergies => _allergies;
  String? get preferences => _preferences;
  String? get medicalConditions => _medicalConditions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get steps => _steps;
  PageController get pageController => _pageController;

  void setBirthDate(String? value) {
    _birthDate = value;
    notifyListeners();
  }

  void setGender(String? value) {
    _gender = value;
    notifyListeners();
  }

  void setHeight(double value) {
    _height = value;
    notifyListeners();
  }

  void setWeight(double value) {
    _weight = value;
    notifyListeners();
  }

  void setActivityLevel(String? value) {
    _activityLevel = value;
    notifyListeners();
  }

  void setGoal(String? value) {
    _goal = value;
    notifyListeners();
  }

  void setAllergies(String? value) {
    _allergies = value;
    notifyListeners();
  }

  void setPreferences(String? value) {
    _preferences = value;
    notifyListeners();
  }

  void setMedicalConditions(String? value) {
    _medicalConditions = value;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < _steps - 1) {
      _currentPage++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    } else {
      
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  Future<void> submitData(BuildContext context, int userId) async {
    setLoading(true);

    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        throw Exception("Token bulunamadı, lütfen tekrar giriş yapın.");
      }

      if (_birthDate == null ||
          _gender == null ||
          _activityLevel == null ||
          _goal == null ||
          _allergies == null ||
          _preferences == null ||
          _medicalConditions == null) {
        throw Exception("Lütfen tüm bilgileri doldurun.");
      }

      final response = await _clientService.addClient(
        userId: userId,
        dietitianId: null,
        birthDate: _birthDate!,
        gender: _gender!,
        height: _height,
        weight: _weight,
        activityLevel: _activityLevel!,
        goal: _goal!,
        allergies: _allergies!,
        preferences: _preferences!,
        medicalConditions: _medicalConditions!,
        token: token,
      );

      if (response.success) {
        final userId = response.data.userId;
        await AuthStorage.saveId(userId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );

        Navigator.pushReplacement(context, 
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bilgiler kaydedilemedi: $_errorMessage")),
      );
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}