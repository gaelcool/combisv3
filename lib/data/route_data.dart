import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_colors.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ⚠️  ARCHIVO TEMPORAL — Datos de rutas estáticos solo para desarrollo.
//     NO incluir en compilaciones de producción / compartidas.
//
// TODO: Fase 3b — Reemplazar este archivo completo con consultas a DatabaseHelper:
//       final routes = await DatabaseHelper.instance.getAllRoutes();
//       Cada RouteOverlay se construirá a partir de filas de la BD.
// ═══════════════════════════════════════════════════════════════════════════════

/// Un punto de parada a lo largo de una ruta de combi.
class StopPoint {
  final String name;
  final LatLng position;

  const StopPoint({required this.name, required this.position});
}

/// Una capa de ruta completa — trayecto de polilínea + paradas con nombre.
class RouteOverlay {
  final String name;
  final Color color;
  final List<LatLng> path;
  final List<StopPoint> stops;

  const RouteOverlay({
    required this.name,
    required this.color,
    required this.path,
    required this.stops,
  });
}

// ── Rutas de ejemplo alrededor de Chiautempan, Tlaxcala ─────────────────────
// Las coordenadas son puntos realistas a nivel de calle (~19.306°N, -98.187°O).
// TODO: Fase 3b — Cargar desde SQLite vía DatabaseHelper.instance.getRouteOverlays()

final List<RouteOverlay> sampleRoutes = [
  // ── Ruta A: Centro → Volcanes ───────────────────────────────────────────
  RouteOverlay(
    name: 'Centro → Volcanes',
    color: AppColors.pumpkinSpice,
    path: [
      LatLng(19.3095, -98.1890), // Zócalo
      LatLng(19.3085, -98.1870),
      LatLng(19.3070, -98.1855),
      LatLng(19.3055, -98.1840),
      LatLng(19.3040, -98.1825),
      LatLng(19.3025, -98.1810), // Volcanes
    ],
    stops: [
      StopPoint(name: 'Zócalo', position: LatLng(19.3095, -98.1890)),
      StopPoint(name: 'Av. Hidalgo', position: LatLng(19.3070, -98.1855)),
      StopPoint(name: 'Volcanes', position: LatLng(19.3025, -98.1810)),
    ],
  ),

  // ── Ruta B: Escalinatas → Mercado ───────────────────────────────────────
  RouteOverlay(
    name: 'Escalinatas → Mercado',
    color: AppColors.princetonOrange,
    path: [
      LatLng(19.3110, -98.1900), // Escalinatas
      LatLng(19.3100, -98.1885),
      LatLng(19.3090, -98.1870),
      LatLng(19.3080, -98.1860),
      LatLng(19.3065, -98.1850),
      LatLng(19.3050, -98.1870), // Mercado
    ],
    stops: [
      StopPoint(name: 'Escalinatas', position: LatLng(19.3110, -98.1900)),
      StopPoint(name: 'Plaza Central', position: LatLng(19.3080, -98.1860)),
      StopPoint(name: 'Mercado', position: LatLng(19.3050, -98.1870)),
    ],
  ),

  // ── Ruta C: Zócalo → Bienestar ──────────────────────────────────────────
  RouteOverlay(
    name: 'Zócalo → Bienestar',
    color: AppColors.lavenderPurple,
    path: [
      LatLng(19.3095, -98.1890), // Zócalo (inicio compartido)
      LatLng(19.3100, -98.1910),
      LatLng(19.3105, -98.1930),
      LatLng(19.3110, -98.1950),
      LatLng(19.3115, -98.1970), // Bienestar
    ],
    stops: [
      StopPoint(name: 'Zócalo', position: LatLng(19.3095, -98.1890)),
      StopPoint(name: 'Calle Juárez', position: LatLng(19.3105, -98.1930)),
      StopPoint(name: 'Bienestar', position: LatLng(19.3115, -98.1970)),
    ],
  ),
];
