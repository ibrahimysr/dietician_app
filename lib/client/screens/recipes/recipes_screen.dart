import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/services/recipes/recipes_service.dart';
import 'package:dietician_app/client/models/recipes_model.dart';
import 'package:dietician_app/client/components/recipes/recipe_card.dart';
import 'package:dietician_app/client/components/recipes/recipe_empty_state.dart';
import 'package:dietician_app/client/components/recipes/recipe_error_widget.dart';
import 'package:dietician_app/client/screens/recipes/recipes_details_screen.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage>
    with SingleTickerProviderStateMixin {
  final RecipesService _recipesService = RecipesService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Recipes> _recipes = [];
  List<Recipes> _filteredRecipes = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  late TabController _tabController;

  void initState() {
    super.initState();
    _fetchRecipes();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterRecipes();
    });
  }

  void _filterRecipes() {
    if (_searchQuery.isEmpty && _tabController.index == 0) {
      _filteredRecipes = _recipes;
      return;
    }

    _filteredRecipes = _recipes.where((recipe) {
      // İsim araması
      bool matchesSearch = _searchQuery.isEmpty ||
          recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesSearch;
    }).toList();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
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
            _filteredRecipes = _recipes;
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
              'Tarifler yüklenirken bir hata oluştu. Lütfen bağlantınızı kontrol edin.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: "Sağlıklı Tarifler"),
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: _fetchRecipes,
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tarif ara...',
          prefixIcon: Icon(Icons.search, color: AppColor.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
            ),
            SizedBox(height: 12),
            Text(
              "Tarifler yükleniyor...",
              style:
                  AppTextStyles.body1Regular.copyWith(color: AppColor.primary),
            ),
          ],
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

    if (_filteredRecipes.isEmpty) {
      return _buildNoResultsFound();
    }

    return _buildRecipesList();
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: AppColor.greyLight,
          ),
          SizedBox(height: 16),
          Text(
            "Aradığınız kriterlere uygun tarif bulunamadı",
            style: AppTextStyles.body1Regular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          TextButton.icon(
            icon: Icon(Icons.refresh, color: AppColor.primary),
            label: Text("Filtreleri Temizle"),
            onPressed: () {
              _searchController.clear();
              _tabController.animateTo(0);
              setState(() {
                _searchQuery = '';
                _filterRecipes();
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList() {
    return CustomScrollView(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recipe = _filteredRecipes[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () => _navigateToRecipeDetails(recipe),
                );
              },
              childCount: _filteredRecipes.length,
            ),
          ),
        ),
      ],
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
