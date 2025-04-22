import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/screens/auth/user_information_screen.dart';
import 'package:dietician_app/client/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isButtonPressed = false;
  String? _errorMessage;

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get passwordController => _passwordController;
  bool get isLoading => _isLoading;
  bool get isButtonPressed => _isButtonPressed;
  String? get errorMessage => _errorMessage;

  Future<void> register(BuildContext context) async {
    setLoading(true);
    setButtonPressed(true);

    try {
      final response = await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (response.success) {
        await AuthStorage.saveToken(response.data.token);
        final userId = response.data.user.id;

        Navigator.pushReplacement(context, 
          MaterialPageRoute(
            builder: (context) => UserInfoScreen(userId:  userId,),
          ),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt başarısız: $_errorMessage")),
      );
    } finally {
      setLoading(false);
      setButtonPressed(false);
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setButtonPressed(bool value) {
    _isButtonPressed = value;
    notifyListeners();
  }

  void clearControllers() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}