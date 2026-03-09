import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../data/route_data.dart';
import '../theme/app_colors.dart';

/// Widget de mapa reutilizable con soporte para capas de ruta.
///
/// Se usa en la página principal (tarjeta cuadrada) y puede incrustarse en cualquier lugar.
///
/// TODO: Fase 3b — Aceptar rutas del resultado de consulta de BD en vez de
///       la lista estática. El parámetro [routes] ya lo soporta,
///       solo hay que cambiar la fuente de datos en el punto de uso.
class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    this.height,
    this.routes = const [],
    this.selectedRouteIndex,
    this.interactive = true,
    this.borderRadius,
  });

  /// Altura fija — si es null, se expande para llenar el padre.
  final double? height;

  /// Capas de ruta a dibujar (polilíneas + marcadores de parada).
  final List<RouteOverlay> routes;

  /// Índice en [routes] de la ruta resaltada.
  /// Trazo grueso + marcadores de parada visibles. null = sin selección.
  final int? selectedRouteIndex;

  /// Si el paneo/zoom está habilitado.
  final bool interactive;

  /// Recortar esquinas cuando se incrusta en una tarjeta.
  final BorderRadius? borderRadius;

  // Chiautempan, Tlaxcala
  static const LatLng _center = LatLng(19.3066, -98.1870);
  static const double _initialZoom = 14.5;

  @override
  Widget build(BuildContext context) {
    Widget map = FlutterMap(
      options: MapOptions(
        initialCenter: _center,
        initialZoom: _initialZoom,
        minZoom: 12.0,
        maxZoom: 18.0,
        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),
      children: [
        // ── Capa de tiles ───────────────────────────────────────────────
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.combisapp.combisv3',
          tileBuilder: _darkTileBuilder,
        ),

        // ── Capa de polilíneas ──────────────────────────────────────────
        if (routes.isNotEmpty) PolylineLayer(polylines: _buildPolylines()),

        // ── Capa de marcadores (paradas de la ruta seleccionada) ────────
        if (selectedRouteIndex != null &&
            selectedRouteIndex! >= 0 &&
            selectedRouteIndex! < routes.length)
          MarkerLayer(markers: _buildStopMarkers(routes[selectedRouteIndex!])),
      ],
    );

    // Aplicar altura fija si se proporcionó
    if (height != null) {
      map = SizedBox(height: height, child: map);
    }

    // Aplicar recorte de bordes redondeados
    if (borderRadius != null) {
      map = ClipRRect(borderRadius: borderRadius!, child: map);
    }

    return map;
  }

  // ── Polilíneas ──────────────────────────────────────────────────────────────

  List<Polyline> _buildPolylines() {
    return List.generate(routes.length, (i) {
      final route = routes[i];
      final isSelected = i == selectedRouteIndex;

      return Polyline(
        points: route.path,
        color: isSelected ? route.color : route.color.withValues(alpha: 0.45),
        strokeWidth: isSelected ? 5.0 : 2.5,
      );
    });
  }

  // ── Marcadores de parada ────────────────────────────────────────────────────

  List<Marker> _buildStopMarkers(RouteOverlay route) {
    return route.stops.map((stop) {
      return Marker(
        point: stop.position,
        width: 120,
        height: 40,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Punto de parada
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: route.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            // Etiqueta del nombre de la parada
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                stop.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // ── Filtro oscuro para tiles ────────────────────────────────────────────────

  Widget _darkTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: tileWidget,
    );
  }
}
