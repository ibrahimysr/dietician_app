import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/food_model.dart';
import 'package:flutter/material.dart';

class FoodCreaterInfo extends StatelessWidget {
  final Food food;
  const FoodCreaterInfo({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Oluşturan',
            style: AppTextStyles.heading4.copyWith(color: AppColor.black),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColor.primary.withValues(alpha:0.1),
                backgroundImage: food.creator?.profilePhoto != null
                    ? NetworkImage(food.creator!.profilePhoto!)
                    : null,
                child: food.creator?.profilePhoto == null
                    ? Icon(Icons.person, color: AppColor.primary)
                    : null,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.creator?.name ?? '',
                    style: AppTextStyles.body1Medium,
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.secondary.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      food.creator?.role == 'dietitian'
                          ? 'Diyetisyen'
                          : 'Danışan',
                      style: AppTextStyles.body2Regular.copyWith(
                        color: AppColor.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}