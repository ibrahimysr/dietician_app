import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  
  final List<Widget> _screens = [
    HomeScreen(),
    Center(child: Text("Tarifler")),
    Center(child: Text("Planlama")),
    Center(child: Text("Profil")),
  ];

  final List<BottomNavItem> items = [
    BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: "Ana Sayfa"),
    BottomNavItem(icon: Icons.restaurant_menu_outlined, activeIcon: Icons.restaurant_menu, label: "Tarifler"),
    BottomNavItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today, label: "Planlama"),
    BottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: "Profil"),
  ];

  @override
  void initState() {
    super.initState();
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
                    color: isSelected ? AppColor.secondary : AppColor.greyLight,
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