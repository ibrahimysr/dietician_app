import 'package:dietician_app/components/auth/login_textfield.dart';
import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isButtonPressed = false;

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
                SizedBox(height: context.getDynamicHeight(12)),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child:  Icon(
                    Icons.favorite,
                    size: 80,
                    color: AppColor.primary,
                  ),
                ),
                 SizedBox(height: context.getDynamicHeight(2)),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    "Hoş Geldiniz",
                    style: AppTextStyles.heading1
                  ),
                ),
                 SizedBox(height: context.getDynamicHeight(1)),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child:  Text(
                    "Sizi Gördüğümüze Sevindik",
                    style: AppTextStyles.body1Regular.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
                 SizedBox(height: context.getDynamicHeight(5)),
                SlideTransition(
                  position: _slideAnimation,
                  child: buildTextField(
                    hintText: "E-posta",
                    icon: Icons.email,
                  ),
                ),
                 SizedBox(height: context.getDynamicHeight(2)),
                SlideTransition(
                  position: _slideAnimation,
                  child: buildTextField(
                    hintText: "Şifre",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                ),
                 SizedBox(height: context.getDynamicHeight(1)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child:  Text(
                      "Şifremi Unuttum",
                      style: TextStyle(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: context.getDynamicHeight(2)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()
                    ..scale(_isButtonPressed ? 0.95 : 1.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      setState(() {
                        _isButtonPressed = true;
                      });
                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() {
                          _isButtonPressed = false;
                        });
                      });
                    },
                    child:  Text(
                      "Giriş Yap",
                      style: AppTextStyles.buttonText.copyWith( 
                        color: AppColor.white,
                      ),
                  ),
                ),),
                 SizedBox(height: context.getDynamicHeight(2)),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "Hesabınız Yok mu? ",
                        style:AppTextStyles.body1Regular.copyWith(
                      color: Colors.grey,
                    ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child:  Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
