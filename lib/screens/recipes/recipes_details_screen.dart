// recipe_details_page.dart
import 'package:dietician_app/components/recipes/recipe_detail/dietitian_details.dart';
import 'package:dietician_app/components/recipes/recipe_detail/ingredients_list.dart';
import 'package:dietician_app/components/recipes/recipe_detail/instructions_list.dart';
import 'package:dietician_app/components/recipes/recipe_detail/nutrition_section.dart';
import 'package:dietician_app/components/recipes/recipe_detail/quick_info_section.dart';
import 'package:dietician_app/components/recipes/recipe_detail/sliver_app_bar.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/recipes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class RecipeDetailsPage extends StatelessWidget {
  final Recipes recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColor.white,
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.white,
      body: CustomScrollView(
        slivers: [
          RecipeDetailsSliverAppBar(
            recipe: recipe,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                QuickInfoSection(recipe: recipe),
                const SizedBox(height: 24),
                _buildSectionTitle('Besin Değerleri'),
                const SizedBox(height: 12),
                NutritionSection(recipe: recipe),
                const SizedBox(height: 24),
                _buildSectionTitle('Malzemeler'),
                const SizedBox(height: 12),
                IngredientsList(ingredients: recipe.ingredients),
                const SizedBox(height: 24),
                _buildSectionTitle('Tarif'),
                const SizedBox(height: 12),
                InstructionsList(instructions: recipe.instructions),
                const SizedBox(height: 24),
                _buildSectionTitle('Oluşturan'),
                const SizedBox(height: 12),
                DietitianDetails(dietitian: recipe.dietitian),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(
        color: AppColor.primary,
      ),
    );
  }
}