import 'package:dietician_app/client/components/food/food_card.dart';
import 'package:dietician_app/client/components/food/food_category_list.dart';
import 'package:dietician_app/client/components/food/food_empty_state.dart';
import 'package:dietician_app/client/components/food/food_filter_chips.dart';
import 'package:dietician_app/client/components/food/food_list_title.dart';
import 'package:dietician_app/client/components/food/food_search_bar.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/models/food_model.dart';
import 'package:dietician_app/client/screens/food/food_details_screen.dart';
import 'package:flutter/material.dart';

enum FoodFilter { all, custom, nonCustom }

class AllFoodsScreen extends StatefulWidget {
  final List<Food> allFoods;

  const AllFoodsScreen({super.key, required this.allFoods});

  @override
  State<AllFoodsScreen> createState() => _AllFoodsScreenState();
}

class _AllFoodsScreenState extends State<AllFoodsScreen> {
  late List<Food> _filteredFoods;
  FoodFilter _currentFilter = FoodFilter.all;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _filteredFoods = widget.allFoods;
    _searchController.addListener(_filterFoods);
    _extractCategories();
  }

  void _extractCategories() {
    Set<String> uniqueCategories = {};
    for (var food in widget.allFoods) {
      uniqueCategories.add(food.category);
    }
    _categories = uniqueCategories.toList()..sort();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFoods);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterFoods() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      List<Food> tempFoods;
      switch (_currentFilter) {
        case FoodFilter.custom:
          tempFoods = widget.allFoods.where((food) => food.isCustom).toList();
          break;
        case FoodFilter.nonCustom:
          tempFoods = widget.allFoods.where((food) => !food.isCustom).toList();
          break;
        case FoodFilter.all:
          tempFoods = widget.allFoods;
          break;
      }
      if (searchTerm.isEmpty) {
        _filteredFoods = tempFoods;
      } else {
        _filteredFoods = tempFoods.where((food) {
          final nameMatch = food.name.toLowerCase().contains(searchTerm);
          final categoryMatch = food.category.toLowerCase().contains(searchTerm);
          return nameMatch || categoryMatch;
        }).toList();
      }
    });
  }

  void _updateFilter(FoodFilter newFilter) {
    if (_currentFilter != newFilter) {
      setState(() {
        _currentFilter = newFilter;
      });
      _filterFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar:CustomAppBar(title: "Besinler"),
      body: Column(
        children: [
          FoodSearchBar(
            controller: _searchController,
            onClear: () => _searchController.clear(),
          ),
          FoodFilterChips(
            currentFilter: _currentFilter,
            onFilterSelected: _updateFilter,
          ),
          const SizedBox(height: 16),
          FoodCategoryList(
            categories: _categories,
            onCategoryTap: (category) {
              _searchController.text = category;
              _filterFoods();
            },
          ),
          const SizedBox(height: 16),
          const FoodListTitle(),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredFoods.isEmpty
                ? FoodEmptyState(isSearchActive: _searchController.text.isNotEmpty)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    itemCount: _filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = _filteredFoods[index];
                      return FoodCard(
                        food: food,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(food: food),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}