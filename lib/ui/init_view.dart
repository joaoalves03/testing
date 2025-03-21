import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:goipvc/ui/widgets/header.dart';

import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/schedule.dart';
import 'screens/blueprints.dart';
import 'screens/menu.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/login': (context) => const LoginScreen(),
    '/home': (context) => const HomeScreen(),
    '/schedule': (context) => const ScheduleScreen(),
    '/blueprints': (context) => const BlueprintScreen(),
    '/menu': (context) => const MenuScreen(),
  };
}

class InitView extends StatefulWidget {
  const InitView({super.key});

  @override
  State<InitView> createState() => _InitViewState();
}

class _InitViewState extends State<InitView> {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScheduleScreen(),
    const BlueprintScreen(),
    const MenuScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: _selectedIndex < _previousIndex,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },

        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Horário',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Plantas',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_outlined),
            selectedIcon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
