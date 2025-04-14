  import 'package:dietician_app/client/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildDatePickerField({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            Icon(icon, color: AppColor.primary),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    selectedDate == null
                        ? 'Tarih Seç'
                        : DateFormat('dd.MM.yyyy').format(selectedDate),
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate == null ? Colors.grey.shade600 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColor.primary),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
