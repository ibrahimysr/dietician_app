import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/food_model.dart';
import 'package:flutter/material.dart';

Widget buildDateInfo(Food food) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRow(
            icon: Icons.calendar_today,
            title: 'Eklenme Tarihi',
            date: _formatDate(food.createdAt),
          ),
          SizedBox(height: 16),
          _buildDateRow(
            icon: Icons.update,
            title: 'Son Güncelleme',
            date: _formatDate(food.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow({
    required IconData icon,
    required String title,
    required String date,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor.greyLight,
          size: 18,
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.body2Medium.copyWith(
            color: AppColor.greyLight,
          ),
        ),
        Spacer(),
        Text(
          date,
          style: AppTextStyles.body2Regular.copyWith(
            color: AppColor.greyLight,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day.toString().padLeft(2,'0')}.${dateTime.month.toString().padLeft(2,'0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";
    } catch (e) {
      return dateString;
    }
  }