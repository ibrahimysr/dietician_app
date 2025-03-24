import 'package:dietician_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';

class PreferenceSelector extends StatelessWidget {
  final String? preferences;
  final Function(String) onPreferenceSelected;

  const PreferenceSelector({
    super.key,
    required this.preferences,
    required this.onPreferenceSelected,
  });

  @override
  Widget build(BuildContext context) {
    const List<Map<String, String>> preferenceOptions = [
      {"title": "Vegan", "value": "vegan"},
      {"title": "Vejetaryen", "value": "vegetarian"},
      {"title": "Normal", "value": "normal"},
      {"title": "Pesketaryen", "value": "pescatarian"},
      {"title": "Ketojenik", "value": "ketogenic"},
      {"title": "Paleo", "value": "paleo"},
      {"title": "Glutensiz", "value": "gluten_free"},
      {"title": "Düşük Karbonhidrat", "value": "low_carb"},
    ];

    return Padding(
      padding: context.paddingNormal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Beslenme Tercihiniz Nedir?",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
           SizedBox(height: context.getDynamicHeight(5)),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: preferenceOptions.map((option) {
              final isSelected = preferences == option["value"];
              return GestureDetector(
                onTap: () {
                  onPreferenceSelected(option["value"]!); 
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding:context.paddingNormal,
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: context.getDynamicHeight(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.secondary : AppColor.grey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ?AppColor.secondary : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(isSelected ? 0.4 : 0.2),
                        blurRadius: isSelected ? 10 : 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      option["title"]!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body1Medium.copyWith(
                        color: isSelected ? AppColor.white : AppColor.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
