import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'settings_page.dart';
import 'alert_page.dart';

class HomePage extends StatefulWidget {
  final String login;

  const HomePage({super.key, required this.login});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Lista de páginas que mostrarás en cada pestaña
  List<Widget> get _pages =>[
    const DashboardPage(),
    const AlertPage(),
    SettingsPage(login: widget.login),
  ];

  // Textos y iconos de barra de navegación
  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Inicio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_alert_outlined),
      activeIcon: Icon(Icons.add_alert),
      label: 'Alerta',
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
      // Mantiene el estado de cada página
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
