import 'package:dietician_app/client/components/food/food_category_card.dart';
import 'package:flutter/material.dart';

class FoodCategoryList extends StatelessWidget {
  final List<String> categories;
  final Function(String) onCategoryTap;

  const FoodCategoryList({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.only(left: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return FoodCategoryCard(
            category: categories[index],
            onTap: () => onCategoryTap(categories[index]),
          );
        },
      ),
    );
  }
}