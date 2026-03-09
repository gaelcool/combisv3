import 'package:flutter/material.dart';
import 'home_page.dart';
import 'routes_page.dart';
import 'profile_page.dart';

/// Shell raíz — gestiona las 3 pestañas de la barra de navegación inferior.
/// Usa IndexedStack para mantener las páginas activas al cambiar de pestaña.
///
/// Orden de pestañas:
///   0 — Inicio  (HomePage)      — tarjeta de mapa + cuadrícula de rutas
///   1 — Rutas   (RoutesPage)    — lista de rutas
///   2 — Perfil  (ProfilePage)   — placeholder (Fase 4)
///
/// TODO: Herramientas de desarrollo → menú hamburguesa en AppBar, protegido con kDebugMode.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), RoutesPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus_outlined),
            activeIcon: Icon(Icons.directions_bus),
            label: 'Rutas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
