import 'dart:io';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSection extends StatelessWidget {
  final XFile? selectedImage;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const ImagePickerSection({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tarif Fotoğrafı",
            style: AppTextStyles.body1Medium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColor.grey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
                image: selectedImage != null
                    ? DecorationImage(
                        image: FileImage(File(selectedImage!.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: selectedImage == null
                  ? Center(
                      child: Icon(Icons.image_outlined,
                          color: AppColor.black, size: 40))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    icon:  Icon(Icons.photo_library_outlined, size: 18,color: AppColor.grey,),
                    label: const Text("Galeriden Seç"),
                    onPressed: onPickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: AppColor.white,
                      textStyle: AppTextStyles.body2Medium,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  if (selectedImage != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: Icon(Icons.delete_outline,
                          size: 18, color: Colors.red.shade700),
                      label: Text("Resmi Kaldır",
                          style: AppTextStyles.body2Medium
                              .copyWith(color: Colors.red.shade700)),
                      onPressed: onRemoveImage,
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 5)),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}