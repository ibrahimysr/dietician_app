import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/parsing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecipeFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController ingredientsController;
  final TextEditingController instructionsController;
  final TextEditingController prepTimeController;
  final TextEditingController cookTimeController;
  final TextEditingController servingsController;
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController fatController;
  final TextEditingController carbsController;
  final TextEditingController tagsController;
  final bool isPublic;
  final ValueChanged<bool> onPublicChanged;

  const RecipeFormFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.ingredientsController,
    required this.instructionsController,
    required this.prepTimeController,
    required this.cookTimeController,
    required this.servingsController,
    required this.caloriesController,
    required this.proteinController,
    required this.fatController,
    required this.carbsController,
    required this.tagsController,
    required this.isPublic,
    required this.onPublicChanged,
  });

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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          alignLabelWithHint: maxLines > 1,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        style: AppTextStyles.body1Regular,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        textInputAction:
            maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: titleController,
          label: "Başlık *",
          validator: validateRequired,
        ),
        _buildTextField(
          controller: descriptionController,
          label: "Açıklama *",
          maxLines: 3,
          validator: validateRequired,
        ),
        _buildTextField(
          controller: ingredientsController,
          label: "Malzemeler (Virgülle Ayırın) *",
          hint: "örn: 1 su bardağı yulaf, 1 adet muz, 1 yk bal",
          maxLines: 3,
          validator: validateRequired,
        ),
        _buildTextField(
          controller: instructionsController,
          label: "Hazırlanış Talimatları *",
          maxLines: 5,
          validator: validateRequired,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                controller: prepTimeController,
                label: "Hazırlık Süresi (dk) *",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: validateRequiredNumber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: cookTimeController,
                label: "Pişirme Süresi (dk) *",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: validateRequiredNumber,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                controller: servingsController,
                label: "Porsiyon Sayısı *",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: validateRequiredNumber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: caloriesController,
                label: "Kalori (kcal) *",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: validateRequiredNumber,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                controller: proteinController,
                label: "Protein (g) *",
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [decimalInputFormatter()],
                validator: validateRequiredDecimal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: fatController,
                label: "Yağ (g) *",
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [decimalInputFormatter()],
                validator: validateRequiredDecimal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: carbsController,
                label: "Karbonhidrat (g) *",
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [decimalInputFormatter()],
                validator: validateRequiredDecimal,
              ),
            ),
          ],
        ),
        _buildTextField(
          controller: tagsController,
          label: "Etiketler (Virgülle Ayırın)",
          hint: "örn: vegan, glutensiz, atıştırmalık",
        ),
        SwitchListTile(
          title: Text("Herkese Açık Tarif", style: AppTextStyles.body1Regular),
          subtitle: Text(
            isPublic
                ? "Bu tarif herkes tarafından görülebilir."
                : "Bu tarif sadece size özeldir.",
            style: AppTextStyles.body2Regular.copyWith(color: AppColor.grey),
          ),
          value: isPublic,
          onChanged: onPublicChanged,
          activeColor: AppColor.primary,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  TextInputFormatter decimalInputFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,])?\d{0,2}'));
  }
}