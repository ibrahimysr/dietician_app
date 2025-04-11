import 'package:dietician_app/client/core/theme/color.dart';
import 'package:flutter/material.dart';

Widget buildTextField({
  required String hintText,
  required IconData icon,
  bool obscureText = false,
  TextEditingController? controller, 
  TextInputType? keyboardType,
  String? Function(String?)? validator, 
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColor.grey, 
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha:0.2), 
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(
        color: AppColor.greyLight, 
        width: 1,
      ),
    ),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500), 
        border: InputBorder.none,
        prefixIcon: Icon(icon, color: AppColor.primary),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primary, width: 2),
        ),
      ),
      style: const TextStyle(fontSize: 16), 
    ),
  );
}