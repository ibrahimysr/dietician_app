import 'dart:developer';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/core/utils/parsing.dart';
import 'package:dietician_app/client/services/api/api_client.dart';
import 'package:dietician_app/dietitian/components/recipes/recipes_add/error_message.dart';
import 'package:dietician_app/dietitian/components/recipes/recipes_add/image_picker_section.dart';
import 'package:dietician_app/dietitian/components/recipes/recipes_add/recie_form_fields.dart';
import 'package:dietician_app/dietitian/components/recipes/recipes_add/submit_button.dart';
import 'package:dietician_app/dietitian/service/recipes/recipes_service.dart';
import 'package:flutter/material.dart';
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

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
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
        'protein':
            double.tryParse(_proteinController.text.replaceAll(',', '.')) ?? 0.0,
        'fat': double.tryParse(_fatController.text.replaceAll(',', '.')) ?? 0.0,
        'carbs':
            double.tryParse(_carbsController.text.replaceAll(',', '.')) ?? 0.0,
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
                content:
                    Text(response['message'] ?? 'Tarif başarıyla eklendi!'),
                backgroundColor: Colors.green.shade700,
              ),
            );
            Navigator.pop(context, true);
          } else {
            String errorMsg = response['message'] ?? 'Tarif eklenemedi.';
            if (response['data'] is Map) {
              try {
                Map<String, dynamic> errors =
                    Map<String, dynamic>.from(response['data']);
                errorMsg += '\n';
                errors.forEach((key, value) {
                  if (value is List) {
                    errorMsg +=
                        '${translateFieldName(key)}: ${value.join(', ')}\n';
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
                  errorMsg +=
                      '${translateFieldName(key)}: ${value.join(', ')}\n';
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Yeni Tarif Ekle"),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ErrorMessageDisplay(errorMessage: _errorMessage),
              ImagePickerSection(
                selectedImage: _selectedImage,
                onPickImage: _pickImage,
                onRemoveImage: _removeImage,
              ),
              const SizedBox(height: 20),
              RecipeFormFields(
                titleController: _titleController,
                descriptionController: _descriptionController,
                ingredientsController: _ingredientsController,
                instructionsController: _instructionsController,
                prepTimeController: _prepTimeController,
                cookTimeController: _cookTimeController,
                servingsController: _servingsController,
                caloriesController: _caloriesController,
                proteinController: _proteinController,
                fatController: _fatController,
                carbsController: _carbsController,
                tagsController: _tagsController,
                isPublic: _isPublic,
                onPublicChanged: (value) {
                  setState(() {
                    _isPublic = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              SubmitButton(
                isLoading: _isLoading,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}