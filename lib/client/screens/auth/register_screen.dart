import 'package:dietician_app/client/components/auth/login_textfield.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/generated/asset.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/viewmodel/register_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) {
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
                          controller: viewModel.nameController,
                        ),
                      ),
                      SizedBox(height: context.getDynamicHeight(2)),
                      SlideTransition(
                        position: _slideAnimation,
                        child: buildTextField(
                          hintText: "E-posta",
                          icon: Icons.email,
                          controller: viewModel.emailController,
                        ),
                      ),
                      SizedBox(height: context.getDynamicHeight(2)),
                      SlideTransition(
                        position: _slideAnimation,
                        child: buildTextField(
                          hintText: "Telefon Numarası",
                          icon: Icons.phone,
                          controller: viewModel.phoneController,
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
                          controller: viewModel.passwordController,
                        ),
                      ),
                      SizedBox(height: context.getDynamicHeight(2)),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        transform: Matrix4.identity()
                          ..scale(viewModel.isButtonPressed ? 0.95 : 1.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          onPressed: viewModel.isLoading
                              ? null
                              : () => viewModel.register(context),
                          child: viewModel.isLoading
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
        },
      ),
    );
  }
}