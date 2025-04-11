import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';

class BirthDatePicker extends StatefulWidget {
  final String? initialDate;
  final Function(String) onDateSelected;

  const BirthDatePicker({super.key, this.initialDate, required this.onDateSelected});

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  String? birthDate;

  @override
  void initState() {
    super.initState();
    birthDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate != null ? DateTime.parse(birthDate!) : DateTime(2000, 1, 1),
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime.now(),
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        birthDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
      widget.onDateSelected(birthDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("📅 Doğum Tarihiniz", style: AppTextStyles.heading2),
          SizedBox(height: context.getDynamicHeight(2)),
          Text(
            "Sizin için en uygun diyet planını oluşturabilmemiz için yaşınızı bilmemiz önemli",
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.getDynamicHeight(5)),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              width: double.infinity,
              height: context.getDynamicHeight(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primary, AppColor.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: birthDate == null ? _buildEmptyDateCard() : _buildSelectedDateCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDateCard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, color: Colors.white, size: 40),
          SizedBox(height: context.getDynamicHeight(2)),
          Text("Doğum Tarihinizi Seçin", style: AppTextStyles.heading3.copyWith(color: Colors.white)),
          SizedBox(height: context.getDynamicHeight(1)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Takvimi Aç", style: AppTextStyles.heading4.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDateCard() {
    final DateTime parsedDate = DateTime.parse(birthDate!);
    final String day = parsedDate.day.toString();
    final List<String> months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final String month = months[parsedDate.month - 1];
    final String year = parsedDate.year.toString();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
          Text(month, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:  0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(year, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
