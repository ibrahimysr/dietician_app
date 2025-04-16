import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/models/recipes_model.dart';
import 'package:dietician_app/client/screens/recipes/recipes_details_screen.dart';
import 'package:dietician_app/client/services/api/api_client.dart';
import 'package:dietician_app/dietitian/screens/recipes/add_recipes_screen.dart';
import 'package:dietician_app/dietitian/screens/recipes/edit_recipe_screen.dart';
import 'package:dietician_app/dietitian/service/recipes/recipes_service.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'dart:developer';

class AllRecipesScreen extends StatefulWidget {
  final List<Recipes> recipes;

  const AllRecipesScreen({super.key, required this.recipes});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

enum RecipeAction { edit, delete }

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  late List<Recipes> _recipes;
  final DietitiansRecipeService _recipeService = DietitiansRecipeService();
  bool _isDeleting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _recipes = List.from(widget.recipes);
  }

  Future<void> _refreshRecipes() async {
    setState(() {
      _errorMessage = null;
    });
    log("Tarif listesi yenileniyor...");
    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bilgisi bulunamadı.");

      if (mounted) {
        setState(() {});
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Liste güncellendi."),
            duration: Duration(seconds: 1)),
      );
    } catch (e) {
      log("Tarif yenileme hatası: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Tarifler yenilenirken hata oluştu: ${e.toString()}";
        });
      }
    }
  }

  Future<void> _deleteRecipe(Recipes recipeToDelete) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tarifi Sil"),
          content: Text(
              "'${recipeToDelete.title}' tarifini silmek istediğinizden emin misiniz? Bu işlem geri alınamaz."),
          actions: <Widget>[
            TextButton(
              child: const Text("İptal"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("Sil", style: TextStyle(color: Colors.red.shade700)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
      _errorMessage = null;
    });

    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Oturum bilgisi bulunamadı.");

      await _recipeService.deleteRecipe(
          token: token, recipeId: recipeToDelete.id);

      if (mounted) {
        setState(() {
          _recipes.removeWhere((recipe) => recipe.id == recipeToDelete.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("'${recipeToDelete.title}' tarifi başarıyla silindi."),
              backgroundColor: Colors.green),
        );
      }
    } on ApiException catch (e) {
      log("Tarif silme API Hatası: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Tarif silinemedi (${e.statusCode}): ${e.message}";
        });
      }
    } catch (e) {
      log("Tarif silme hatası: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Tarif silinirken bir hata oluştu: ${e.toString()}";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Future<void> _editRecipe(Recipes recipeToEdit) async {
    final bool? updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditRecipeScreen(recipe: recipeToEdit),
      ),
    );

    if (updated == true && mounted) {
      _refreshRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBar(title: "Tüm Tariflerim"),
      body: Stack(
        children: [
          _buildRecipeList(context),
          if (_errorMessage != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red.withValues(alpha:0.9),
                padding: const EdgeInsets.all(10),
                child: Text(_errorMessage!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center),
              ),
            ),
          if (_isDeleting)
            Container(
              color: Colors.black.withValues(alpha:0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? addedSuccessfully = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
          );

          if (addedSuccessfully == true) {
            log("Yeni tarif eklendi, liste yenileniyor...");
          }
        },
        tooltip: 'Yeni Tarif Ekle',
        backgroundColor: AppColor.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    if (_recipes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Henüz oluşturulmuş tarifiniz bulunmamaktadır."),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRecipes,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];

          return Card(
            color: AppColor.grey,
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              leading: recipe.photoUrl.isNotEmpty
                  ? SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Hero(
                          tag: 'recipe_image_${recipe.id}_all',
                          child: CachedNetworkImage(
                            imageUrl: recipe.photoUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColor.greyLight,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColor.primary),
                                  strokeWidth: 2.0,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColor.greyLight,
                              child: Icon(Icons.broken_image_outlined,
                                  color: AppColor.grey, size: 30),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColor.greyLight,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(Icons.restaurant_menu,
                          color: AppColor.grey, size: 30),
                    ),
              title: Text(
                recipe.title,
                style: AppTextStyles.body1Medium
                    .copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "${recipe.calories} kcal | P:${recipe.protein}g F:${recipe.fat}g K:${recipe.carbs}g",
                  style: AppTextStyles.body2Regular
                      .copyWith(color: AppColor.secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: PopupMenuButton<RecipeAction>(
                icon: Icon(Icons.more_vert, color: AppColor.secondary),
                tooltip: "Seçenekler",
                onSelected: (RecipeAction action) {
                  switch (action) {
                    case RecipeAction.edit:
                      _editRecipe(recipe);
                      break;
                    case RecipeAction.delete:
                      _deleteRecipe(recipe);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<RecipeAction>>[
                  const PopupMenuItem<RecipeAction>(
                    value: RecipeAction.edit,
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined, size: 20),
                      title: Text('Düzenle'),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem<RecipeAction>(
                    value: RecipeAction.delete,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline,
                          size: 20, color: Colors.red),
                      title: Text('Sil', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                ],
              ),
              onTap: () {
                log("Tüm Tarifler Ekranı - Tarif seçildi: ${recipe.title} (ID: ${recipe.id})");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(recipe: recipe),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
