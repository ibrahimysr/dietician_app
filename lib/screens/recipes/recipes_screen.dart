import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/auth_storage.dart';
import 'package:dietician_app/services/recipes/recipes_service.dart';
import 'package:dietician_app/models/Recipes.dart';
import 'package:flutter/services.dart';

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
          _errorMessage = 'Failed to load recipes. Please check your connection.';
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
          'Healthy Recipes', 
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
      return _buildErrorWidget();
    }

    if (_recipes.isEmpty) {
      return _buildEmptyState();
    }

    return _buildRecipesList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_food_outlined, 
            color: AppColor.greyLight,
            size: 80,
          ),
          const SizedBox(height: 20),
          Text(
            'No Recipes Found',
            style: AppTextStyles.heading3.copyWith(color: AppColor.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Check back later for new recipes!',
            style: AppTextStyles.body2Regular.copyWith(color: AppColor.greyLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh, color: AppColor.white),
            label: Text(
              'Refresh', 
              style: AppTextStyles.buttonText.copyWith(color: AppColor.white),
            ),
            onPressed: _fetchRecipes,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColor.primary,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong.',
              style: AppTextStyles.heading3.copyWith(color: AppColor.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh, color: AppColor.white),
              label: Text(
                'Retry', 
                style: AppTextStyles.buttonText.copyWith(color: AppColor.white),
              ),
              onPressed: _fetchRecipes,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return _buildRecipeCard(recipe);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  Widget _buildRecipeCard(Recipes recipe) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColor.greyLight.withOpacity(0.2), width: 1),
      ),
      elevation: 6,
      shadowColor: AppColor.black.withOpacity(0.1),
      child: InkWell(
        onTap: () => _navigateToRecipeDetails(recipe),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
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
                        AppColor.black.withOpacity(0.7),
                        AppColor.black.withOpacity(0.0),
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
                          color: AppColor.black.withOpacity(0.5),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
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
                      _buildIconText(
                        Icons.timer_outlined, 
                        '${recipe.prepTime} min', 
                        AppColor.secondary
                      ),
                      _buildIconText(
                        Icons.local_fire_department_outlined, 
                        '${recipe.calories} Cal', 
                        AppColor.primary
                      ),
                      _buildIconText(
                        Icons.people_outline, 
                        '${recipe.servings} Servings', 
                        AppColor.primary.withOpacity(0.7)
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.body2Medium.copyWith(color: AppColor.black),
        ),
      ],
    );
  }

  void _navigateToRecipeDetails(Recipes recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProRecipeDetailsPage(recipe: recipe),
      ),
    );
  }
}

class ProRecipeDetailsPage extends StatelessWidget {
  final Recipes recipe;

  const ProRecipeDetailsPage({super.key, required this.recipe});

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
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildQuickInfoSection(),
                const SizedBox(height: 24),
                _buildSectionTitle('Nutrition Facts'),
                const SizedBox(height: 12),
                _buildNutritionSection(),
                const SizedBox(height: 24),
                _buildSectionTitle('Ingredients'),
                const SizedBox(height: 12),
                _buildIngredientsList(),
                const SizedBox(height: 24),
                _buildSectionTitle('Instructions'),
                const SizedBox(height: 12),
                _buildInstructionsList(),
                const SizedBox(height: 24),
                _buildSectionTitle('Created By'),
                const SizedBox(height: 12),
                _buildDietitianDetails(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
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
                color: AppColor.black.withOpacity(0.8),
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
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColor.greyLight,
                  child: Icon(Icons.broken_image, color: AppColor.grey, size: 60),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.7),
                  end: Alignment(0.0, 0.0),
                  colors: <Color>[
                    AppColor.black.withOpacity(0.6),
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

  Widget _buildQuickInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickInfoItem(
              Icons.timer_outlined,
              '${recipe.prepTime} min',
              'Prep Time',
              AppColor.primary,
            ),
            _buildQuickInfoItem(
              Icons.local_fire_department_outlined,
              '${recipe.calories} Cal',
              'Calories',
              AppColor.secondary,
            ),
            _buildQuickInfoItem(
              Icons.people_outline,
              '${recipe.servings} Servings',
              'Servings',
              AppColor.greyLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.body2Regular.copyWith(
            color: AppColor.greyLight,
          ),
        ),
      ],
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

  Widget _buildNutritionSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNutritionItem('Protein', recipe.protein, AppColor.secondary),
            _buildNutritionItem('Carbs', recipe.carbs, AppColor.primary),
            _buildNutritionItem('Fat', recipe.fat, AppColor.greyLight),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.body2Regular.copyWith(
            color: AppColor.greyLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.heading4.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recipe.ingredients.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(
                  Icons.fiber_manual_record,
                  size: 10,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredient.trim(),
                  style: AppTextStyles.body1Regular.copyWith(
                    color: AppColor.black,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstructionsList() {
    final instructions = recipe.instructions
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions.asMap().entries.map((entry) {
        final index = entry.key;
        final instruction = entry.value.trim();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}.',
                style: AppTextStyles.heading4.copyWith(
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  instruction,
                  style: AppTextStyles.body1Regular.copyWith(
                    color: AppColor.black,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDietitianDetails() {
    final dietitian = recipe.dietitian;
    final user = dietitian.user;
    final profileImageUrl = user?.profilePhoto;
    final hasImage = profileImageUrl != null && profileImageUrl.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColor.greyLight,
              backgroundImage: hasImage ? NetworkImage(profileImageUrl) : null,
              child: !hasImage
                  ? Icon(Icons.person, size: 35, color: AppColor.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Dietitian',
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Professional Dietitian',
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColor.greyLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}