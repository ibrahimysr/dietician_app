import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/recipes_model.dart';
import 'package:dietician_app/client/screens/recipes/recipes_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'dart:developer'; 

class AllRecipesScreen extends StatelessWidget {
  final List<Recipes> recipes;

  const AllRecipesScreen({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(title: "Tüm Tariflerim"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildRecipeList(recipes),
      ),
    );
  }

  Widget _buildRecipeList(List<Recipes> recipes) {
     if (recipes.isEmpty) {
      return const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text("Henüz oluşturulmuş tarifiniz bulunmamaktadır.")),
          ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          color: AppColor.grey,
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
             leading: recipe.photoUrl.isNotEmpty
               ? SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect( 
                     borderRadius: BorderRadius.circular(8.0),
                     child:  Hero(
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
                  ),
                )
               : Container( 
                   width: 60,
                   height: 60,
                   decoration: BoxDecoration(
                     color: Colors.grey.shade200,
                     borderRadius: BorderRadius.circular(8.0),
                   ),
                   child: Icon(Icons.restaurant_menu_outlined, color: Colors.grey.shade400),
                 ),
            title: Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text("${recipe.calories} kcal | P:${recipe.protein}g F:${recipe.fat}g K:${recipe.carbs}g"),
            trailing: recipe.isPublic
               ? Tooltip(message: "Herkese Açık", child: Icon(Icons.public, size: 20, color: AppColor.secondary))
               : Tooltip(message: "Özel", child: Icon(Icons.lock_outline, size: 20, color: AppColor.secondary)),
            onTap: () {
              log("Tarif seçildi: ${recipe.title} (ID: ${recipe.id})"); 
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailsPage(recipe: recipe),));

            },
          ),
        );
      },
    );
  }
}