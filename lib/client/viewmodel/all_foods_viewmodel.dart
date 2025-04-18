import 'package:flutter/material.dart';
import 'package:dietician_app/client/models/food_model.dart';

enum FoodFilter { all, custom, nonCustom }

class AllFoodsViewModel extends ChangeNotifier {
  final List<Food> allFoods;
  late List<Food> filteredFoods;
  FoodFilter currentFilter = FoodFilter.all;
  final TextEditingController searchController = TextEditingController();
  List<String> categories = [];

  AllFoodsViewModel({required this.allFoods}) {
    filteredFoods = allFoods;
    _extractCategories();
    searchController.addListener(_filterFoods);
  }

  void _extractCategories() {
    final uniqueCategories = <String>{};
    for (var food in allFoods) {
      uniqueCategories.add(food.category);
    }
    categories = uniqueCategories.toList()..sort();
  }

  void _filterFoods() {
    final searchTerm = searchController.text.toLowerCase();
    List<Food> tempFoods;
    switch (currentFilter) {
      case FoodFilter.custom:
        tempFoods = allFoods.where((food) => food.isCustom).toList();
        break;
      case FoodFilter.nonCustom:
        tempFoods = allFoods.where((food) => !food.isCustom).toList();
        break;
      case FoodFilter.all:
      tempFoods = allFoods;
        break;
    }

    if (searchTerm.isEmpty) {
      filteredFoods = tempFoods;
    } else {
      filteredFoods = tempFoods.where((food) {
        final nameMatch = food.name.toLowerCase().contains(searchTerm);
        final categoryMatch = food.category.toLowerCase().contains(searchTerm);
        return nameMatch || categoryMatch;
      }).toList();
    }
    notifyListeners();
  }

  void updateFilter(FoodFilter newFilter) {
    if (currentFilter != newFilter) {
      currentFilter = newFilter;
      _filterFoods();
    }
  }

  void selectCategory(String category) {
    searchController.text = category;
    _filterFoods();
  }

  void clearSearch() {
    searchController.clear();
    _filterFoods();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterFoods);
    searchController.dispose();
    super.dispose();
  }
}
