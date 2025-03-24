import 'package:flutter/material.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/extension/context_extension.dart';

class AllergySelector extends StatelessWidget {
  final String? allergies;
  final Function(String?) onAllergiesChanged;

  const AllergySelector({
    super.key,
    required this.allergies,
    required this.onAllergiesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Alerjileriniz Var mı?", style: AppTextStyles.heading2),
          SizedBox(height: context.getDynamicHeight(3)),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Örn: Fındık",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColor.secondary, 
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColor.secondary, 
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColor.secondary, 
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) => onAllergiesChanged(value),
            initialValue: allergies,
          ),
        ],
      ),
    );
  }
}
