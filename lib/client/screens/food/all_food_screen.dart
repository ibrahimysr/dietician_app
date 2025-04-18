import 'package:dietician_app/client/viewmodel/all_foods_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class AllFoodsScreen extends StatelessWidget {
  final List<Food> allFoods;

  const AllFoodsScreen({super.key, required this.allFoods});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AllFoodsViewModel(allFoods: allFoods),
      child: const _AllFoodsBody(),
    );
  }
}

class _AllFoodsBody extends StatelessWidget {
  const _AllFoodsBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AllFoodsViewModel>();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(title: "Besinler"),
      body: Column(
        children: [
          FoodSearchBar(
            controller: viewModel.searchController,
            onClear: viewModel.clearSearch,
          ),
          FoodFilterChips(
            currentFilter: viewModel.currentFilter,
            onFilterSelected: viewModel.updateFilter,
          ),
          const SizedBox(height: 16),
          FoodCategoryList(
            categories: viewModel.categories,
            onCategoryTap: viewModel.selectCategory,
          ),
          const SizedBox(height: 16),
          const FoodListTitle(),
          const SizedBox(height: 16),
          Expanded(
            child: viewModel.filteredFoods.isEmpty
                ? FoodEmptyState(isSearchActive: viewModel.searchController.text.isNotEmpty)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    itemCount: viewModel.filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = viewModel.filteredFoods[index];
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
