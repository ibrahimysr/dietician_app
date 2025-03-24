import 'package:flutter/material.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/extension/context_extension.dart';

class GenderPicker extends StatelessWidget {
  final String? gender;
  final Function(String) onGenderSelected;

  const GenderPicker({super.key, this.gender, required this.onGenderSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Cinsiyetiniz Nedir?", style: AppTextStyles.heading2),
          SizedBox(height: context.getDynamicHeight(1)),
          Text(
            "Metabolizmanıza uygun beslenme planı için bu bilgi önemlidir",
            style: TextStyle(color: AppColor.secondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.getDynamicHeight(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGenderCard(
                title: "Erkek",
                icon: Icons.male,
                color: AppColor.secondary,
                isSelected: gender == "erkek",
                onTap: () => onGenderSelected("erkek"),
              ),
              SizedBox(width: context.getDynamicHeight(4)),
              _buildGenderCard(
                title: "Kadın",
                icon: Icons.female,
                color: AppColor.secondary,
                isSelected: gender == "kadın",
                onTap: () => onGenderSelected("kadın"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 150,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [color, color.withOpacity(0.7)]
                : [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: color,
                  size: 20,
                ),
              ),
            SizedBox(height: isSelected ? 10 : 0),
            Icon(
              icon,
              size: 60,
              color: isSelected ? Colors.white : color,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
