import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/dietitian/model/dietitian_model.dart';
import 'package:dietician_app/dietitian/screens/diet_plan/diet_plan_list_screen.dart';
import 'package:dietician_app/dietitian/service/dietitian/dietitian_service.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/components/shared/custom_app_bar.dart';

class DietitianHomeScreen extends StatefulWidget {
  const DietitianHomeScreen({super.key});

  @override
  State<DietitianHomeScreen> createState() => _DietitianHomeScreenState();
}

class _DietitianHomeScreenState extends State<DietitianHomeScreen> {
  final DietitiansService _dietitiansService = DietitiansService();

  bool _isLoading = true;
  DietitianData? _dietitianData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDietitianInfo();
  }

  Future<void> _fetchDietitianInfo() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? token;
    int? userId;

    try {
      token = await AuthStorage.getToken();
      userId = await AuthStorage.getId(); 

      if (token == null || userId == null) {
        throw Exception("Kimlik bilgileri bulunamadı. Lütfen tekrar giriş yapın.");
      }

      final response = await _dietitiansService.getDietitinInformation(
        id: userId,
        token: token,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
       
        if (response.data is DietitianData) {
             setState(() {
                _dietitianData = response.data;
                _isLoading = false;
             });
        } else {
             throw Exception("Sunucudan beklenmeyen veri formatı alındı. Alınan tip: ${response.data.runtimeType}");
        }
      } else {
        throw Exception(response.message.isNotEmpty ? response.message : "Diyetisyen bilgileri alınamadı.");
      }
    } catch (e) {
      if (!mounted) return;
      print("Diyetisyen bilgisi alınırken hata: $e"); 
      setState(() {
        _errorMessage = "Bir hata oluştu: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = "Diyetisyen Paneli";
    if (!_isLoading && _dietitianData?.user?.name != null) {
       appBarTitle = "Hoş Geldin, ${_dietitianData!.user!.name}";
    }

    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorWidget(_errorMessage!);
    }

    if (_dietitianData == null) {
      return _buildErrorWidget("Diyetisyen verisi bulunamadı.");
    }

    return RefreshIndicator(
      onRefresh: _fetchDietitianInfo,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(_dietitianData!),
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Danışanlarım", Icons.people_outline),
            _buildClientList(_dietitianData!.clients), 
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Tariflerim", Icons.restaurant_menu),
            _buildRecipeList(_dietitianData!.recipes), 
            const SizedBox(height: 24),
            _buildSectionTitle(context, "Abonelik Planları", Icons.subscriptions_outlined),
            _buildSubscriptionPlanList(_dietitianData!.subscriptionPlans), 
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                 icon: const Icon(Icons.refresh),
                 label: const Text("Tekrar Dene"),
                 onPressed: _fetchDietitianInfo,
                 style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor, 
                 ),
              )
            ],
          ),
        ),
      );
  }

  Widget _buildWelcomeSection(DietitianData data) {
    return Card(
       elevation: 3,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                  data.user?.name != null ? "Merhaba, ${data.user!.name}!" : "Kontrol Paneli",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                     fontWeight: FontWeight.bold,
                     color: Theme.of(context).primaryColorDark
                  )
               ),
               const SizedBox(height: 10),
               _buildInfoRow(Icons.star_border, "Uzmanlık", data.specialty),
               const SizedBox(height: 6),
               _buildInfoRow(Icons.work_outline, "Deneyim", "${data.experienceYears} yıl"),
               if (data.bio.isNotEmpty) ...[ 
                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.info_outline, "Hakkında", data.bio, maxLines: 3),
               ]
            ],
         ),
       ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {int maxLines = 1}) {
     return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Icon(icon, size: 18, color: Theme.of(context).primaryColor),
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
             Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 22),
             const SizedBox(width: 10),
             Text(
               title,
               style: Theme.of(context).textTheme.titleLarge?.copyWith(
                 fontWeight: FontWeight.w600,
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
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorLight,
              backgroundImage: (clientPhotoUrl != null && clientPhotoUrl.isNotEmpty)
                  ? NetworkImage(clientPhotoUrl) 
                  : null, 
              child: (clientPhotoUrl == null || clientPhotoUrl.isEmpty)
                  ? Text( 
                      clientName.isNotEmpty ? clientName[0].toUpperCase() : "?",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark),
                    )
                  : null, 
            ),
            title: Text(clientName, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text("Hedef: ${client.goal.isNotEmpty ? client.goal : 'Belirtilmemiş'}"),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              print("Danışan seçildi: $clientName (ID: ${client.id})");
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

  Widget _buildRecipeList(List<DietitianRecipe> recipes) {
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
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
             leading: recipe.photoUrl != null && recipe.photoUrl!.isNotEmpty
               ? SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect( 
                     borderRadius: BorderRadius.circular(8.0),
                     child: Image.network(
                       recipe.photoUrl!,
                       fit: BoxFit.cover, 
                       loadingBuilder: (context, child, progress) {
                         return progress == null ? child : const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                       },
                       errorBuilder: (context, error, stackTrace) {
                         return Container( 
                            color: Colors.grey.shade200,
                            child: Icon(Icons.broken_image, color: Colors.grey.shade400)
                         );
                       },
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
               ? Tooltip(message: "Herkese Açık", child: Icon(Icons.public, size: 20, color: Colors.green.shade600))
               : Tooltip(message: "Özel", child: Icon(Icons.lock_outline, size: 20, color: Colors.grey.shade600)),
            onTap: () {
              print("Tarif seçildi: ${recipe.title} (ID: ${recipe.id})");
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
               label: Text(isActive ? "Aktif" : "Pasif", style: TextStyle(fontSize: 12, color: isActive ? Colors.green.shade900 : Colors.grey.shade700)),
               backgroundColor: isActive ? Colors.green.shade100 : Colors.grey.shade300,
               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
               side: BorderSide.none,
             ),
            isThreeLine: true, 
            onTap: () {
              print("Plan seçildi: ${plan.name} (ID: ${plan.id})");
            },
          ),
        );
      },
    );
  }
}