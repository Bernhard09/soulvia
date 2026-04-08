import 'package:flutter/material.dart';
import 'package:soulvie_app/common/app_colors.dart';
import 'package:soulvie_app/features/activity/activity_menu/presentation/activity_screen.dart';
import 'package:soulvie_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:soulvie_app/features/profile/presentation/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _barMenu = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
    BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Aktivitas"),
    BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Skrinning"),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
  ];

  final _screens = [
    DashboardScreen(),
    ActivityScreen(),
    Placeholder(),
    ProfileScreen(),
  ];

  int _selectedScreen = 0;

  void _selectScreen(int screen) {
    setState(() {
      _selectedScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _selectScreen,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedScreen,
        items: _barMenu,
      ),
      body: _screens[_selectedScreen],
    );
  }
}
