import 'package:dietician_app/client/components/auth/login_textfield.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/generated/asset.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/screens/auth/user_information_screen.dart';
import 'package:dietician_app/client/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isButtonPressed = false;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _isButtonPressed = true;
    });

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

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserInfoScreen(userId: userId,)),
          );
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt başarısız: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isButtonPressed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: context.getDynamicHeight(5)),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Lottie.asset(
                    AppAssets.loginAnimation,
                    height: context.getDynamicHeight(20),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text("Hoş Geldiniz", style: AppTextStyles.heading1),
                ),
                SizedBox(height: context.getDynamicHeight(1)),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "Lütfen Bilgilerinizi Giriniz",
                    style: AppTextStyles.body1Regular.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(5)),
                SlideTransition(
                  position: _slideAnimation,
                  child: buildTextField(
                    hintText: "Ad Soyad",
                    icon: Icons.person,
                    controller: _nameController,
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                SlideTransition(
                  position: _slideAnimation,
                  child: buildTextField(
                    hintText: "E-posta",
                    icon: Icons.email,
                    controller: _emailController,
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                SlideTransition(
                  position: _slideAnimation,
                  child: buildTextField(
                    hintText: "Telefon Numarası",
                    icon: Icons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                SlideTransition(
                  position: _slideAnimation,
                  child: buildTextField(
                    hintText: "Şifre",
                    icon: Icons.lock,
                    obscureText: true,
                    controller: _passwordController,
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()..scale(_isButtonPressed ? 0.95 : 1.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? CircularProgressIndicator(color: AppColor.white)
                        : Text(
                            "Kayıt Ol",
                            style: AppTextStyles.buttonText.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Geri Dön",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(15)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}