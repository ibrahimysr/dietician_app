import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/recipes_model.dart';
import 'package:dietician_app/components/recipes/recipe_icon_text.dart';

class RecipeCard extends StatelessWidget {
  final Recipes recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColor.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColor.greyLight.withValues(alpha:0.2), width: 1),
      ),
      elevation: 6,
      shadowColor: AppColor.black.withValues(alpha:0.1),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecipeImage(),
            _buildRecipeDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Hero(
          tag: 'recipe_image_${recipe.id}',
          child: CachedNetworkImage(
            imageUrl: recipe.photoUrl,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 220,
              color: AppColor.grey,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 220,
              color: AppColor.grey,
              child: Icon(Icons.broken_image, color: AppColor.greyLight, size: 50),
            ),
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColor.black.withValues(alpha:0.7),
                AppColor.black.withValues(alpha:0.0),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            recipe.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.heading3.copyWith(
              color: AppColor.white,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: AppColor.black.withValues(alpha:0.5),
                  offset: const Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body1Regular.copyWith(color: AppColor.black),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            children: [
              RecipeIconText(
                icon: Icons.timer_outlined, 
                text: '${recipe.prepTime} dakika', 
                color: AppColor.secondary,
              ),
              RecipeIconText(
                icon: Icons.local_fire_department_outlined, 
                text: '${recipe.calories} kalori', 
                color: AppColor.primary,
              ),
              RecipeIconText(
                icon: Icons.people_outline, 
                text: '${recipe.servings} Kişilik', 
                color: AppColor.primary.withValues(alpha:0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}