import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/screens/main/main_screen.dart';
import 'package:dietician_app/client/services/auth/auth_service.dart';
import 'package:dietician_app/client/services/auth/client_service.dart';
import 'package:dietician_app/dietitian/screens/main/main_screen.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ClientService _clientService = ClientService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isButtonPressed = false;
  String? _errorMessage;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get isLoading => _isLoading;
  bool get isButtonPressed => _isButtonPressed;
  String? get errorMessage => _errorMessage;

  Future<void> login(BuildContext context) async {
    setLoading(true);
    setButtonPressed(true);

    try {
      final response = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.success) {
        final userId = response.data.user.id;
        final userRole = response.data.user.role;

        await AuthStorage.saveToken(response.data.token);

        if (userRole == 'dietitian') {
          Navigator.pushReplacement(context, 
            MaterialPageRoute(
              builder: (context) => const DietitianMainScreen(),
            ),
          );
        } else {
          await _clientService.getUserClient(
              userId: userId, token: response.data.token);
        Navigator.pushReplacement(context, 
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş başarısız: $_errorMessage")),
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
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}