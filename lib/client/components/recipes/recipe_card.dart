import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/recipes_model.dart';
import 'package:dietician_app/client/components/recipes/recipe_icon_text.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent, 
          child: InkWell(
            onTap: onTap,
            splashColor: AppColor.primary.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                _buildInfoSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Hero(
          tag: 'recipe_image_${recipe.id}',
          child: CachedNetworkImage(
            imageUrl: recipe.photoUrl,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildImagePlaceholder(),
            errorWidget: (context, url, error) => _buildImageError(),
          ),
        ),
        
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColor.black.withOpacity(0.7),
                  AppColor.black.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        
        if (recipe.tags.isNotEmpty)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                recipe.tags.split(',').first.trim(),
                style: AppTextStyles.body1Medium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Text(
            recipe.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body1Medium.copyWith(
              color: AppColor.white,
              shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: AppColor.black.withOpacity(0.5),
                  offset: const Offset(0.5, 0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RecipeIconText(
                icon: Icons.timer_outlined,
                text: '${recipe.prepTime}dk',
                color: AppColor.secondary,
                isCompact: true,
              ),
              Container(
                height: 20,
                width: 1,
                color: AppColor.greyLight.withOpacity(0.5),
              ),
              RecipeIconText(
                icon: Icons.local_fire_department_outlined,
                text: '${recipe.calories}kcal',
                color: AppColor.primary,
                isCompact: true,
              ),
              
              
            ],
          ),
          Container(
                height: 10,
                width: 1,
                color: AppColor.greyLight.withOpacity(0.5),
              ),
          RecipeIconText(
                icon: Icons.people_outline,
                text: '${recipe.servings} kişilik',
                color: AppColor.secondary,
                isCompact: true,
              ),
          SizedBox(height: 6),
          
          if (recipe.dietitian.user!.name.isEmpty)
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColor.primary.withOpacity(0.2),
                  child: Text(
                    recipe.dietitian.user!.name[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    recipe.dietitian.user!.name,
                    style: AppTextStyles.body1Medium.copyWith(
                      color: AppColor.black.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 140,
      color: AppColor.grey,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 140,
      color: AppColor.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_rounded, color: AppColor.greyLight, size: 32),
          SizedBox(height: 4),
          Text(
            "Görsel yüklenemedi",
            style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight),
          ),
        ],
      ),
    );
  }
}