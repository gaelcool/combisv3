import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Datos de una ruta individual — clase simple, sin dependencia de BD.
/// TODO: Fase 3b — reemplazar con el modelo AppRoute de models/route.dart
class _RouteItem {
  final String number;
  final String name;
  final String estimatedTime;
  final Color color;

  const _RouteItem({
    required this.number,
    required this.name,
    required this.estimatedTime,
    required this.color,
  });
}

/// Rutas de ejemplo estáticas para Chiautempan, Tlaxcala.
/// TODO: Fase 3b — cargar desde DatabaseHelper.instance.getAllRoutes()
const List<_RouteItem> _sampleRoutes = [
  _RouteItem(
    number: 'A',
    name: 'Centro → Volcanes',
    estimatedTime: '12 min',
    color: AppColors.pumpkinSpice,
  ),
  _RouteItem(
    number: 'B',
    name: 'Escalinatas → Mercado',
    estimatedTime: '10 min',
    color: AppColors.princetonOrange,
  ),
  _RouteItem(
    number: 'C',
    name: 'Zócalo → Bienestar',
    estimatedTime: '8 min',
    color: AppColors.amberGlow,
  ),
  _RouteItem(
    number: 'D',
    name: 'Soriana → Sta. Ana',
    estimatedTime: '6 min',
    color: AppColors.lavenderPurple,
  ),
  _RouteItem(
    number: 'E',
    name: 'Ocotlán → Hospital',
    estimatedTime: '7 min',
    color: AppColors.pumpkinSpice,
  ),
];

/// Muestra la lista de rutas de combis disponibles.
/// Sin base de datos — solo datos de ejemplo hasta la Fase 3b.
class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutas')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _sampleRoutes.length,
        itemBuilder: (context, index) {
          return _RouteCard(route: _sampleRoutes[index]);
        },
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final _RouteItem route;

  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Fase 3b — navegar al detalle de ruta / resaltar en el mapa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ruta ${route.number} — ${route.name}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Insignia del número de ruta
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: route.color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    route.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Nombre de la ruta
              Expanded(
                child: Text(
                  route.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              // Chip de tiempo estimado
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 13,
                      color: AppColors.amberGlow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      route.estimatedTime,
                      style: const TextStyle(
                        color: AppColors.amberGlow,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
