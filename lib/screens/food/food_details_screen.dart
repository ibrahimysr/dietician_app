import 'package:dietician_app/components/food/food_detail_creator_info.dart';
import 'package:dietician_app/components/food/food_detail_header.dart';
import 'package:dietician_app/components/food/food_detail_macronutrient.dart';
import 'package:dietician_app/components/food/food_detail_nutrition_highlights.dart';
import 'package:dietician_app/components/food/food_detail_other_nutrients.dart';
import 'package:dietician_app/components/food/food_details_date_info.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/models/food_model.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';

class FoodDetailScreen extends StatelessWidget {
  final Food food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Besin Detayı',
          style: AppTextStyles.heading4.copyWith(color: AppColor.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColor.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: AppColor.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FoodHeader(
                  food: food,
                ),
                SizedBox(height: 24),
                FoodNutritionHighlights(
                  food: food,
                ),
                SizedBox(height: 24),
                FoodMacronutrient(
                  food: food,
                ),
                SizedBox(height: 30),
                FoodOtherNutrients(
                  food: food,
                ),
                SizedBox(height: 24),
                if (food.creator != null)
                  FoodCreaterInfo(
                    food: food,
                  ),
                SizedBox(height: 24),
                buildDateInfo(food),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
