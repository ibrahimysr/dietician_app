import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: isLoading
          ? Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 8),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : const Icon(Icons.cloud_upload_outlined, size: 20,color: Colors.white,),
      label: Text(isLoading ? 'Kaydediliyor...' : 'Tarifi Kaydet'),
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle:
            AppTextStyles.body1Medium.copyWith(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
    );
  }
}