import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/utils/auth_storage.dart';
import 'package:dietician_app/client/screens/dietitian/dietitian_screen.dart';
import 'package:dietician_app/client/screens/home/home_screen.dart';
import 'package:dietician_app/client/screens/progress/progress_screen.dart';
import 'package:dietician_app/client/screens/recipes/recipes_screen.dart';
import 'package:dietician_app/client/screens/setting/setting.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({super.key, });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  int id = 0;
  
  final List<Widget> _screens = [
    HomeScreen(),
    RecipesPage(),
    ProgressScreen(),
    DietitianListScreen(),
    ProfileScreen()
  ];

  final List<BottomNavItem> items = [
    BottomNavItem(icon: Icons.home, activeIcon: Icons.home, label: "Ana Sayfa"),
    BottomNavItem(icon: Icons.restaurant_menu_outlined, activeIcon: Icons.restaurant_menu, label: "Tarifler"), 
    
    BottomNavItem(icon: Icons.ssid_chart_outlined, activeIcon: Icons.restaurant_menu, label: "İlerlemeler"),
    BottomNavItem(icon: Icons.person, activeIcon: Icons.person, label: "Diyetisyenler"),
    BottomNavItem(icon: Icons.settings, activeIcon: Icons.settings, label: "Profil"),
  ];

   Future getClientId() async {
    id = await AuthStorage.getId() ?? 0;
   }

  @override
  void initState() {
    super.initState();
    getClientId();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.greyLight.withValues(alpha:  0.3),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: MediaQuery.of(context).size.width / items.length,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isSelected ? 
                    1.0 + (_animationController.value * 0.2) : 
                    1.0,
                  child: Icon(
                    isSelected ? items[index].activeIcon : items[index].icon,
                    color: isSelected ? AppColor.secondary : AppColor.primary,
                    size: 24,
                  ),
                );
              },
            ),
            SizedBox(height: 4),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 3,
                  width: isSelected ? 
                    30 * _animationController.value : 
                    0,
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
            SizedBox(height: 2),
            Text(
              items[index].label,
              style: TextStyle(
                color: isSelected ? AppColor.secondary : AppColor.greyLight,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}