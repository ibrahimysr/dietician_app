import 'dart:developer';
import 'dart:io';

import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/services/api/api_client.dart';
import 'package:dietician_app/dietitian/service/recipes/recipes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController(); 
  final _instructionsController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();
  final _tagsController = TextEditingController();

  bool _isPublic = true; 
  XFile? _selectedImage;
  bool _isLoading = false; 
  String? _errorMessage; 

  final ImagePicker _picker = ImagePicker();
  final DietitiansRecipeService _recipeService = DietitiansRecipeService(); 

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, 
      );
      if (pickedFile != null && mounted) {
        setState(() {
          _selectedImage = pickedFile;
          _errorMessage = null; 
        });
      }
    } catch (e) {
      log("Resim seçme hatası: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Resim seçilemedi: ${e.toString()}";
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_isLoading) return;

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      String? token;
      int? userId;
      try {
        token = await AuthStorage.getToken();
        userId = await AuthStorage.getId();

        if (token == null || userId == null) {
          throw Exception("Kimlik bilgileri alınamadı.");
        }
      } catch (e) {
        log("AuthStorage Hata: $e");
        if (mounted) {
          setState(() {
            _errorMessage = "Oturum bilgileri alınamadı. Lütfen tekrar giriş yapın.";
            _isLoading = false;
          });
        }
        return; 
      }

      List<String> ingredientsList = _ingredientsController.text
          .split(',')
          .map((e) => e.trim()) 
          .where((e) => e.isNotEmpty) 
          .toList();

      Map<String, dynamic> recipeData = {
        'user_id': userId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'ingredients': ingredientsList, 
        'instructions': _instructionsController.text,
        'prep_time': int.tryParse(_prepTimeController.text) ?? 0,
        'cook_time': int.tryParse(_cookTimeController.text) ?? 0,
        'servings': int.tryParse(_servingsController.text) ?? 1,
        'calories': int.tryParse(_caloriesController.text) ?? 0,
        'protein': double.tryParse(_proteinController.text.replaceAll(',', '.')) ?? 0.0,
        'fat': double.tryParse(_fatController.text.replaceAll(',', '.')) ?? 0.0,
        'carbs': double.tryParse(_carbsController.text.replaceAll(',', '.')) ?? 0.0,
        'tags': _tagsController.text.trim(),
        'is_public': _isPublic, 
      };


      try {
        final response = await _recipeService.addRecipe(
          token: token,
          recipeData: recipeData,
          photo: _selectedImage,
        );

        if (mounted) {
          if (response['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response['message'] ?? 'Tarif başarıyla eklendi!'),
                backgroundColor: Colors.green.shade700,
              ),
            );
            Navigator.pop(context, true); 
          } else {
             String errorMsg = response['message'] ?? 'Tarif eklenemedi.';
             if (response['data'] is Map) {
                try {
                  Map<String, dynamic> errors = Map<String, dynamic>.from(response['data']);
                  errorMsg += '\n';
                  errors.forEach((key, value) {
                     if (value is List) {
                       errorMsg += '${_translateFieldName(key)}: ${value.join(', ')}\n';
                     }
                  });
                } catch (e) {
                   log("Validation error parse hatası: $e");
                   errorMsg += "\nDetaylar: ${response['data']}";
                }
             }
             setState(() {
                _errorMessage = errorMsg.trim();
             });
          }
        }
      } on ApiException catch (e) {
        log("Tarif ekleme API Hatası (ApiException): $e");
        if (mounted) {
          String errorMsg = "Bir hata oluştu (${e.statusCode}): ${e.message}";
           if (e.errors is Map) {
              try {
                Map<String, dynamic> errors = Map<String, dynamic>.from(e.errors);
                errorMsg += '\n';
                errors.forEach((key, value) {
                  if (value is List) {
                    errorMsg += '${_translateFieldName(key)}: ${value.join(', ')}\n';
                  }
                });
              } catch (parseErr) {
                log("Validation error parse hatası (ApiException): $parseErr");
                errorMsg += "\nDetaylar: ${e.errors}";
              }
           } else if (e.errors != null) {
             errorMsg += "\nDetaylar: ${e.errors}";
           }
           setState(() {
             _errorMessage = errorMsg.trim();
           });
        }
      } catch (e) {
        log("Tarif ekleme Genel Hata: $e");
        if (mounted) {
          setState(() {
            _errorMessage = "Beklenmedik bir hata oluştu: ${e.toString()}";
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _errorMessage = "Lütfen tüm zorunlu alanları (*) doğru şekilde doldurun.";
        });
      }
    }
  }

   String _translateFieldName(String field) {
    switch(field) {
      case 'title': return 'Başlık';
      case 'description': return 'Açıklama';
      case 'ingredients': return 'Malzemeler';
      case 'instructions': return 'Talimatlar';
      case 'prep_time': return 'Hazırlık Süresi';
      case 'cook_time': return 'Pişirme Süresi';
      case 'servings': return 'Porsiyon';
      case 'calories': return 'Kalori';
      case 'protein': return 'Protein';
      case 'fat': return 'Yağ';
      case 'carbs': return 'Karbonhidrat';
      case 'is_public': return 'Herkese Açık';
      case 'photo': return 'Fotoğraf';
      case 'user_id': return 'Kullanıcı';
      default: return field;
    }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Tarif Ekle"),
        backgroundColor: AppColor.white, 
        foregroundColor: AppColor.black,
        elevation: 1,
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200)
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade800, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              _buildImagePickerSection(),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _titleController,
                label: "Başlık *",
                validator: _validateRequired,
              ),
              _buildTextField(
                controller: _descriptionController,
                label: "Açıklama *",
                maxLines: 3,
                validator: _validateRequired,
              ),
              _buildTextField(
                controller: _ingredientsController,
                label: "Malzemeler (Virgülle Ayırın) *",
                hint: "örn: 1 su bardağı yulaf, 1 adet muz, 1 yk bal",
                maxLines: 3,
                validator: _validateRequired,
              ),
              _buildTextField(
                controller: _instructionsController,
                label: "Hazırlanış Talimatları *",
                maxLines: 5,
                validator: _validateRequired,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _prepTimeController,
                      label: "Hazırlık Süresi (dk) *",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validateRequiredNumber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _cookTimeController,
                      label: "Pişirme Süresi (dk) *",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validateRequiredNumber,
                    ),
                  ),
                ],
              ),

              Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _servingsController,
                      label: "Porsiyon Sayısı *",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validateRequiredNumber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _caloriesController,
                      label: "Kalori (kcal) *",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validateRequiredNumber,
                    ),
                  ),
                ],
              ),

              Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Expanded(
                     child: _buildTextField(
                       controller: _proteinController,
                       label: "Protein (g) *",
                       keyboardType: const TextInputType.numberWithOptions(decimal: true),
                       inputFormatters: [_decimalInputFormatter()],
                       validator: _validateRequiredDecimal,
                     ),
                   ),
                   const SizedBox(width: 12),
                   Expanded(
                     child: _buildTextField(
                       controller: _fatController,
                       label: "Yağ (g) *",
                       keyboardType: const TextInputType.numberWithOptions(decimal: true),
                       inputFormatters: [_decimalInputFormatter()],
                       validator: _validateRequiredDecimal,
                     ),
                   ),
                   const SizedBox(width: 12),
                   Expanded(
                     child: _buildTextField(
                       controller: _carbsController,
                       label: "Karbonhidrat (g) *",
                       keyboardType: const TextInputType.numberWithOptions(decimal: true),
                       inputFormatters: [_decimalInputFormatter()],
                       validator: _validateRequiredDecimal,
                     ),
                   ),
                 ],
              ),

              // Etiketler
              _buildTextField(
                controller: _tagsController,
                label: "Etiketler (Virgülle Ayırın)",
                hint: "örn: vegan, glutensiz, atıştırmalık",
              ),

              SwitchListTile(
                title: Text("Herkese Açık Tarif", style: AppTextStyles.body1Regular),
                subtitle: Text(
                  _isPublic ? "Bu tarif herkes tarafından görülebilir." : "Bu tarif sadece size özeldir.",
                  style: AppTextStyles.body2Regular.copyWith(color: AppColor.grey),
                ),
                value: _isPublic,
                onChanged: (bool value) {
                  setState(() {
                    _isPublic = value;
                  });
                },
                activeColor: AppColor.primary, 
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 25),

              ElevatedButton.icon(
                icon: _isLoading
                    ? Container( 
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Icon(Icons.cloud_upload_outlined, size: 20),
                label: Text(_isLoading ? 'Kaydediliyor...' : 'Tarifi Kaydet'),
                onPressed: _submitForm, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: AppTextStyles.body1Medium.copyWith(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColor.greyLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColor.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          alignLabelWithHint: maxLines > 1, 
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        style: AppTextStyles.body1Regular,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tarif Fotoğrafı", style: AppTextStyles.body1Medium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColor.greyLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
                image: _selectedImage != null
                    ? DecorationImage(
                        image: FileImage(File(_selectedImage!.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _selectedImage == null
                  ? Center(child: Icon(Icons.image_outlined, color: AppColor.grey, size: 40))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text("Galeriden Seç"),
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.secondary, 
                      foregroundColor: AppColor.white,
                      textStyle: AppTextStyles.body2Medium,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  if (_selectedImage != null) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade700),
                        label: Text("Resmi Kaldır", style: AppTextStyles.body2Medium.copyWith(color: Colors.red.shade700)),
                        onPressed: () {
                          setState(() => _selectedImage = null);
                        },
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 5)),
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


  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan zorunludur.';
    }
    return null;
  }

  String? _validateRequiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan zorunludur.';
    }
    if (int.tryParse(value) == null) {
      return 'Geçerli bir sayı giriniz.';
    }
     if (int.parse(value) < 0) {
      return 'Değer 0 veya daha büyük olmalı.';
    }
    return null;
  }

  String? _validateRequiredDecimal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan zorunludur.';
    }
    if (double.tryParse(value.replaceAll(',', '.')) == null) {
      return 'Geçerli bir sayı giriniz (örn: 10.5).';
    }
     if (double.parse(value.replaceAll(',', '.')) < 0) {
      return 'Değer 0 veya daha büyük olmalı.';
    }
    return null;
  }

 TextInputFormatter _decimalInputFormatter() {
  return FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,])?\d{0,2}')); 
 }
}