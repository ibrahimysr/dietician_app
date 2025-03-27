import 'package:dietician_app/components/recipes/recipe_card.dart';
import 'package:dietician_app/components/recipes/recipe_empty_state.dart';
import 'package:dietician_app/components/recipes/recipe_error_widget.dart';
import 'package:dietician_app/screens/recipes/recipes_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/services/recipes/recipes_service.dart';
import 'package:dietician_app/models/recipes_model.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final RecipesService _recipesService = RecipesService();
  List<Recipes> _recipes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final token = await AuthStorage.getToken();
      final response = await _recipesService.getRecipes(token: token);

      if (mounted) {
        setState(() {
          if (response.success) {
            _recipes = response.data;
            _isLoading = false;
          } else {
            _errorMessage = response.message;
            _isLoading = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Failed to load recipes. Please check your connection.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'Sağlıklı Tarifler',
          style: AppTextStyles.heading2.copyWith(color: AppColor.white),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 4.0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return RecipeErrorWidget(
        errorMessage: _errorMessage,
        onRetry: _fetchRecipes,
      );
    }

    if (_recipes.isEmpty) {
      return RecipeEmptyState(onRefresh: _fetchRecipes);
    }

    return _buildRecipesList();
  }

  Widget _buildRecipesList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return RecipeCard(
          recipe: recipe,
          onTap: () => _navigateToRecipeDetails(recipe),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  void _navigateToRecipeDetails(Recipes recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailsPage(recipe: recipe),
      ),
    );
  }
}

