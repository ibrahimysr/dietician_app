import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/models/food_model.dart';
import 'package:dietician_app/client/screens/food/all_food_screen.dart';
import 'package:dietician_app/client/screens/food/food_details_screen.dart';
import 'package:dietician_app/client/components/food/food_card.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';

class FoodPreviewSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<Food> allFoods;

  const FoodPreviewSection({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.allFoods,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Besinler", style: AppTextStyles.heading4),
            TextButton(
              onPressed: () {
                if (!isLoading && allFoods.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllFoodsScreen(allFoods: allFoods),
                    ),
                  );
                } else if (isLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Besinler yükleniyor...")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Gösterilecek besin bulunamadı veya yüklenemedi.")),
                  );
                }
              },
              child: Text(
                "Tümünü Gör",
                style:
                    AppTextStyles.body1Medium.copyWith(color: AppColor.primary),
              ),
            ),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(1.5)),
        isLoading
            ? Center(child: CircularProgressIndicator(color: AppColor.primary))
            : errorMessage != null
                ? Center(child: Text("Hata: $errorMessage"))
                : allFoods.isEmpty
                    ? Center(child: Text("Henüz besin eklenmemiş."))
                    : SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: min(allFoods.length, 5),
                          itemBuilder: (context, index) {
                            final food = allFoods[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: context.getDynamicWidth(3)),
                              child: FoodCard(
                                food: food,
                                isHorizontal: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          FoodDetailScreen(food: food),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
      ],
    );
  }
}
