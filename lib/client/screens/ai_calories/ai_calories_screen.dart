import 'dart:io';
import 'package:dietician_app/client/components/ai_calories/results_section.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/services/gemini/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FoodPhotoScreen extends StatefulWidget {
  const FoodPhotoScreen({super.key});

  @override
  State<FoodPhotoScreen> createState() => _FoodPhotoScreenState();
}

class _FoodPhotoScreenState extends State<FoodPhotoScreen> {
  final GeminiService _geminiService = GeminiService();
  File? _image;
  Map<String, dynamic>? _foodDetails;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _foodDetails = null;
        _errorMessage = null;
      });
      _analyzeImage();
    } else {
      setState(() {
        _errorMessage = 'Fotoğraf seçilmedi. Lütfen tekrar deneyin.';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final details = await _geminiService.estimateCaloriesFromPhoto(_image!);
      setState(() {
        _foodDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains('JSON')
            ? 'Yiyecek analizi başarısız: Geçersiz yanıt formatı.'
            : 'Yiyecek analizi başarısız: $e';
        _isLoading = false;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Fotoğraf Kaynağı', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Fotoğrafı nasıl eklemek istersiniz?'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            icon:  Icon(Icons.camera_alt, color: AppColor.primary),
            label:  Text('Kamera', style: TextStyle(color:AppColor.primary)),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            icon:  Icon(Icons.photo_library, color:AppColor.primary),
            label:  Text('Galeri', style: TextStyle(color:AppColor.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
     appBar: CustomAppBar(title: "Kalori Hesapla"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 24),
              if (_isLoading) _buildLoadingSection(),
              if (_errorMessage != null) _buildErrorSection(),
              if (_foodDetails != null && !_isLoading) buildResultsSection(_foodDetails),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yiyecek Fotoğrafı',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Besin değerlerini hesaplamak için bir yiyecek fotoğrafı yükleyin',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),
        if (_image == null)
          GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(
                    Icons.add_a_photo,
                    size: 64,
                    color: AppColor.primary,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Fotoğraf Ekle',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:  AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.file(
                  _image!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: FloatingActionButton.small(
                    onPressed: _showImageSourceDialog,
                    backgroundColor: Colors.white,
                    child:  Icon(Icons.edit, color:AppColor.primary),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: Column(
        children:  [
          CircularProgressIndicator(color:AppColor.primary),
          SizedBox(height: 16),
          Text(
            'Yiyecek analiz ediliyor...',
            style: AppTextStyles.body1Medium.copyWith(
              fontSize: 14,
           
            )
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[100]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children:  [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Hata',
                style: AppTextStyles.body1Medium.copyWith(
              fontSize: 14,
              color: Colors.red[800],
            )
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style:AppTextStyles.body1Medium.copyWith(
              fontSize: 14,
              color: Colors.red[800],
            )
          ),
        ],
      ),
    );
  }
}