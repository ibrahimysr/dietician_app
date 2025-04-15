import 'package:flutter/material.dart';

class DatePickerHelper {
  static Future<DateTime?> selectDate({
    required BuildContext context,
    required DateTime? selectedStartDate,
    required DateTime? selectedFinishDate,
    required bool isStartDate,
    required Function(DateTime start, DateTime? finish) onDateSelected,
    Color primaryColor = Colors.black
  }) async {
    final DateTime initial =
        (isStartDate ? selectedStartDate : selectedFinishDate) ?? DateTime.now();
    final DateTime first = DateTime(2020);
    final DateTime last = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      DateTime newStart = selectedStartDate ?? picked;
      DateTime? newFinish = selectedFinishDate;

      if (isStartDate) {
        newStart = picked;
        if (newFinish != null && newFinish.isBefore(picked)) {
          newFinish = picked;
        }
      } else {
        newFinish = picked;
        if (newStart.isAfter(picked)) {
          newStart = picked;
        }
      }

      onDateSelected(newStart, newFinish);
      return picked;
    }

    return null;
  }
}
