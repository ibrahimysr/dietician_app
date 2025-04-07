import 'package:dietician_app/components/food/food_card.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/utils/formatters.dart';
import 'package:dietician_app/models/food_model.dart';
import 'package:dietician_app/screens/food/food_details_screen.dart';
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
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Besinler",
          style: AppTextStyles.heading4.copyWith(color: AppColor.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColor.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColor.primary),
            onPressed: () {
              // Add new food action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Besin adı veya kategori ara...',
                  hintStyle: AppTextStyles.body1Regular.copyWith(color: AppColor.greyLight),
                  prefixIcon: Icon(Icons.search, color: AppColor.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: AppColor.greyLight),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip("Tümü", _currentFilter == FoodFilter.all, () {
                  _updateFilter(FoodFilter.all);
                }),
                const SizedBox(width: 12),
                _buildFilterChip("Özel Besinler", _currentFilter == FoodFilter.custom, () {
                  _updateFilter(FoodFilter.custom);
                }),
                const SizedBox(width: 12),
                _buildFilterChip("Genel Besinler", _currentFilter == FoodFilter.nonCustom, () {
                  _updateFilter(FoodFilter.nonCustom);
                }),
              ],
            ),
          ),

          SizedBox(height: 16),
          Container(
            height: 120,
            padding: const EdgeInsets.only(left: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(_categories[index]);
              },
            ),
          ),
          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: Divider(color: AppColor.grey)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Besin Listesi",
                    style: AppTextStyles.body2Medium.copyWith(color: AppColor.greyLight),
                  ),
                ),
                Expanded(child: Divider(color: AppColor.grey)),
              ],
            ),
          ),
          SizedBox(height: 16),

          Expanded(
            child: _filteredFoods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColor.greyLight,
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? "Bu filtreye uygun besin bulunamadı."
                              : "Arama sonucuyla eşleşen besin bulunamadı.",
                          style: AppTextStyles.body1Medium.copyWith(color: AppColor.greyLight),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
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

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.grey.withValues(alpha:0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body2Medium.copyWith(
              color: isSelected ? AppColor.white : AppColor.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category) {
    return GestureDetector(
      onTap: () {
        _searchController.text = category;
        _filterFoods();
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColor.grey,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.primary.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                getCategoryIcon(category),
                color: AppColor.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category,
              style: AppTextStyles.body2Medium,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  
}

