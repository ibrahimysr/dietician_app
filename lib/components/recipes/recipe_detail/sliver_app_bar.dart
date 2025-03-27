import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/models/recipes_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';



class RecipeDetailsSliverAppBar extends StatelessWidget {
  final Recipes recipe;

  const RecipeDetailsSliverAppBar({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      stretch: true,
      backgroundColor: AppColor.primary,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColor.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
        centerTitle: true,
        title: Text(
          recipe.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heading4.copyWith(
            color: AppColor.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: AppColor.black.withValues(alpha:0.8),
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'recipe_image_${recipe.id}',
              child: CachedNetworkImage(
                imageUrl: recipe.photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColor.greyLight,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColor.primary),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColor.greyLight,
                  child:
                      Icon(Icons.broken_image, color: AppColor.grey, size: 60),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.7),
                  end: Alignment(0.0, 0.0),
                  colors: <Color>[
                    AppColor.black.withValues(alpha:0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
      ),
    );
  }
}