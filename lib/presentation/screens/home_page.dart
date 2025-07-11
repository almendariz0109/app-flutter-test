// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import '../../data/models/application.dart';
import 'notification_page.dart';
import 'settings_page.dart';
import 'main_menu_page.dart'; // importar nueva pantalla

class HomePage extends StatefulWidget {
  final String login;
  final String name;
  final List<Application> applications;

  const HomePage({super.key, required this.login, required this.name, required this.applications});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
    MainMenuPage(userName: widget.name, applications: widget.applications,), // ahora es la página principal
    const NotificacionPage(),
    SettingsPage(login: widget.login),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Inicio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_alert_outlined),
      activeIcon: Icon(Icons.add_alert),
      label: 'Notificación',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      activeIcon: Icon(Icons.settings),
      label: 'Ajustes',
    ),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
