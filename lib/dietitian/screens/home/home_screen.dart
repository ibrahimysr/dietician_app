import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/models/recipes_model.dart';
import 'package:dietician_app/client/screens/recipes/recipes_details_screen.dart';
import 'package:dietician_app/dietitian/model/dietitian_model.dart';
import 'package:dietician_app/dietitian/screens/diet_plan/diet_plan_list_screen.dart';
import 'package:dietician_app/dietitian/screens/recipes/all_recipes_screen.dart';
import 'package:dietician_app/dietitian/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:provider/provider.dart';

class DietitianHomeScreen extends StatelessWidget {
  const DietitianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DietitianProvider>(
      builder: (context, provider, child) {
        String appBarTitle = "Diyetisyen Paneli";
        if (!provider.isLoading && provider.dietitianData?.user?.name != null) {
          appBarTitle = "Hoş Geldin, ${provider.dietitianData!.user!.name}";
        }

        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: CustomAppBar(title: appBarTitle),
          body: _buildBody(context, provider),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DietitianProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return _buildErrorWidget(provider.errorMessage!, provider.fetchDietitianInfo);
    }

    if (provider.dietitianData == null) {
      return _buildErrorWidget("Diyetisyen verisi bulunamadı.", provider.fetchDietitianInfo);
    }

    final List<Recipes> allRecipes = provider.dietitianData!.recipes;
    final bool showSeeAllButton = allRecipes.length > 2;
    final List<Recipes> recipesToShow = showSeeAllButton ? allRecipes.take(3).toList() : allRecipes;

    return RefreshIndicator(
      onRefresh: provider.fetchDietitianInfo,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(provider.dietitianData!),
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Danışanlarım", Icons.people_outline),
            _buildClientList(provider.dietitianData!.clients),
            const SizedBox(height: 24),
            _buildSectionTitleWithSeeAll(
              context: context,
              title: "Tariflerim",
              icon: Icons.restaurant_menu,
              showSeeAll: showSeeAllButton,
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllRecipesScreen(recipes: allRecipes),
                  ),
                );
              },
            ),
            _buildRecipeList(recipesToShow),
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Abonelik Planları", Icons.subscriptions_outlined),
            _buildSubscriptionPlanList(provider.dietitianData!.subscriptionPlans),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 60),
            const SizedBox(height: 15),
            Text(
              "Hata Oluştu",
              style: AppTextStyles.heading3.copyWith(color: Colors.red.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Regular,
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Tekrar Dene"),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(DietitianData data) {
    return Card(
      color: AppColor.grey,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.user?.name != null ? "Merhaba, ${data.user!.name}!" : "Kontrol Paneli",
              style: AppTextStyles.body1Medium.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColor.secondary,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.star_border, "Uzmanlık", data.specialty),
            const SizedBox(height: 6),
            _buildInfoRow(Icons.work_outline, "Deneyim", "${data.experienceYears} yıl"),
            if (data.bio.isNotEmpty) ...[
              const SizedBox(height: 6),
              _buildInfoRow(Icons.info_outline, "Hakkında", data.bio, maxLines: 3),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitleWithSeeAll({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool showSeeAll,
    VoidCallback? onSeeAllTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColor.black, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTextStyles.body1Medium.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
            ],
          ),
          if (showSeeAll && onSeeAllTap != null)
            InkWell(
              onTap: onSeeAllTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  "Tümünü Gör",
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColor.secondary),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColor.black, size: 22),
          const SizedBox(width: 10),
          Text(
            title,
            style: AppTextStyles.body1Medium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientList(List<DietitianClient> clients) {
    if (clients.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("Henüz kayıtlı danışanınız bulunmamaktadır.")),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        final String clientName = client.user?.name ?? 'ID: ${client.userId}';
        final String? clientPhotoUrl = client.user?.profilePhoto;

        return Card(
          color: AppColor.grey,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColor.secondary,
              backgroundImage: (clientPhotoUrl != null && clientPhotoUrl.isNotEmpty)
                  ? NetworkImage(clientPhotoUrl)
                  : null,
              child: (clientPhotoUrl == null || clientPhotoUrl.isEmpty)
                  ? Text(
                      clientName.isNotEmpty ? clientName[0].toUpperCase() : "?",
                      style: AppTextStyles.body1Medium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColor.white,
                      ),
                    )
                  : null,
            ),
            title: Text(clientName, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text("Hedef: ${client.goal.isNotEmpty ? client.goal : 'Belirtilmemiş'}"),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ClientDietPlansScreen(clientId: client.id),
                ),
              );
            },
          ),
        );
      },
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
                      child: Hero(
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
            subtitle:
                Text("${recipe.calories} kcal | P:${recipe.protein}g F:${recipe.fat}g K:${recipe.carbs}g"),
            trailing: recipe.isPublic
                ? Tooltip(
                    message: "Herkese Açık",
                    child: Icon(Icons.public, size: 20, color: AppColor.secondary))
                : Tooltip(
                    message: "Özel",
                    child: Icon(Icons.lock_outline, size: 20, color: AppColor.secondary)),
            onTap: () {
              log("Tarif seçildi: ${recipe.title} (ID: ${recipe.id})");
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
    );
  }

  Widget _buildSubscriptionPlanList(List<DietitianSubscriptionPlan> plans) {
    if (plans.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("Henüz abonelik planı oluşturulmamış.")),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        bool isActive = plan.status.toLowerCase() == 'active';
        return Card(
          color: AppColor.grey,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(plan.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text("Süre: ${plan.duration} gün | Fiyat: ${plan.price.toStringAsFixed(2)} TL"),
              ],
            ),
            trailing: Chip(
              label: Text(
                  isActive ? "Aktif" : "Pasif",
                  style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.green.shade900 : Colors.grey.shade700)),
              backgroundColor: isActive ? Colors.green.shade100 : Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              side: BorderSide.none,
            ),
            isThreeLine: true,
            onTap: () {
              log("Plan seçildi: ${plan.name} (ID: ${plan.id})");
            },
          ),
        );
      },
    );
  }
}