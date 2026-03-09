import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/map_widget.dart';
import '../data and db/route_data.dart';

/// Página principal — "Rutas Disponibles"
/// Diseño (coincide con el mockup revisado):
///   - AppBar: hamburguesa | título centrado | ícono de menú
///   - Tarjeta cuadrada del mapa con capas de ruta (reemplaza el antiguo banner)
///   - Slogan
///   - Cuadrícula de botones de ruta en 2 columnas (8 rutas)
///   - Botón "Ver Todas" al final
///
/// TODO: Fase 3b — cargar cuadrícula de rutas desde DatabaseHelper.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ── Estado de selección de ruta ────────────────────────────────────────
  // null = ninguna ruta seleccionada, todas se muestran con igual peso.
  // TODO: Fase 3b — el índice de selección se mapeará a rutas cargadas de la BD.
  int? _selectedRouteIndex;

  // ── Rutas de la cuadrícula (datos estáticos) ──────────────────────────
  // Los colores rotan entre los 3 naranjas + lavanda para coincidir con el mockup. Para iniciar tendremos 3
  static const List<_GridRoute> _gridRoutes = [
    _GridRoute('Ruta Centro', AppColors.pumpkinSpice, 0),
    _GridRoute('Ruta Norte', AppColors.princetonOrange, 1),
    _GridRoute('Ruta Sur', AppColors.amberGlow, 2),
    _GridRoute('Ruta Industrial', AppColors.lavenderPurple, null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── AppBar ─────────────────────────────────────────────────────────
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: abrir cajón / menú de desarrollo (protegido con kDebugMode)
          },
        ),
        title: const Text('Rutas Disponibles'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),

      // ── Cuerpo ─────────────────────────────────────────────────────────
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: MapWidget(
                height: 220,
                borderRadius: BorderRadius.circular(16),
                routes: sampleRoutes,
                selectedRouteIndex: _selectedRouteIndex,
                interactive: true,
              ),
            ),

            const SizedBox(height: 20),

            // ── Slogan ─────────────────────────────────────────────────
            const Text(
              '¿A DÓNDE VAMOS HOY?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            // ── Cuadrícula de rutas ────────────────────────────────────
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.6,
                ),
                itemCount: _gridRoutes.length,
                itemBuilder: (context, index) {
                  final gridRoute = _gridRoutes[index];
                  return _RouteButton(
                    route: gridRoute,
                    isSelected:
                        gridRoute.overlayIndex != null &&
                        gridRoute.overlayIndex == _selectedRouteIndex,
                    onTap: () {
                      setState(() {
                        // Alternar: tocar de nuevo para deseleccionar
                        if (_selectedRouteIndex == gridRoute.overlayIndex) {
                          _selectedRouteIndex = null;
                        } else {
                          _selectedRouteIndex = gridRoute.overlayIndex;
                        }
                      });
                      // Mostrar snackbar para rutas sin datos de capa
                      if (gridRoute.overlayIndex == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${gridRoute.label} — sin datos de ruta',
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ── Botón Ver Todas ────────────────────────────────────────
            OutlinedButton(
              onPressed: () {
                // TODO: navegar a la lista completa de rutas o cambiar a pestaña Rutas
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ver Todas',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Datos de la cuadrícula de rutas ─────────────────────────────────────────
class _GridRoute {
  final String label;
  final Color color;

  /// Índice en sampleRoutes para resaltar la capa correspondiente.
  /// null = no hay datos de capa disponibles para esta ruta aún.
  final int? overlayIndex;
  const _GridRoute(this.label, this.color, this.overlayIndex);
}

class _RouteButton extends StatelessWidget {
  final _GridRoute route;
  final bool isSelected;
  final VoidCallback onTap;

  const _RouteButton({
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: route.color,
        borderRadius: BorderRadius.circular(10),
        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: route.color.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    route.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
