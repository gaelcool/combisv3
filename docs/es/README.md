# combis app

> Una app de guía de tránsito en Flutter para rutas de combis en Chiautempan, Tlaxcala.

---

## Stack Tecnológico

- **Flutter** — framework de UI
- **flutter_map** — renderizado de tiles OpenStreetMap
- **latlong2** — tipos de coordenadas para el mapa
- **google_fonts** — tipografía Inter, descargada y cacheada en tiempo de ejecución
- **sqflite** — persistencia SQLite *(deshabilitado, Fase 3b)*

---

Filosofia de refacción.

"Hazlo simple, haz que funcione, hazlo hermoso- en ese orden."

Es buena practica:

Simple - Tablas con datos, modelos claros, logica sensible
Work - Cada componente tiene un gol especifico y lo haze bien.
Beautiful - UI professional con visualizacion de cada elemento clara.



## Estado Actual — Fase 3

La app funciona **sin base de datos**. Los datos de rutas están estáticos en `data/route_data.dart` (archivo temporal — no para compilaciones de producción/compartidas). El mapa renderiza tiles OSM en vivo dentro de una tarjeta en la página principal con capas de polilíneas + marcadores de parada.

---

## Estructura

```
combisv3/
├── lib/
│   ├── main.dart                  # Punto de entrada — sin init de BD
│   ├── data/
│   │   └── route_data.dart       # ⚠️ TEMP — capas de ruta estáticas
│   ├── pages/
│   │   ├── main_screen.dart      # Shell de nav inferior (3 pestañas)
│   │   ├── home_page.dart        # Pestaña 0 — tarjeta de mapa + cuadrícula de rutas
│   │   ├── routes_page.dart      # Pestaña 1 — lista de rutas
│   │   └── profile_page.dart     # Pestaña 2 — placeholder
│   ├── widgets/
│   │   └── map_widget.dart       # Widget de mapa reutilizable con soporte de capas
│   ├── theme/
│   │   ├── app_theme.dart        # ThemeData + re-exporta AppColors
│   │   └── app_colors.dart       # Paleta Vibrant Sunset
│   └── utils/
│       └── common.dart           # debugLog / errorLog
└── pubspec.yaml
```

---

## Pestañas

| # | Etiqueta | Página | Estado |
|---|----------|--------|--------|
| 0 | Inicio | `home_page.dart` | ✅ Tarjeta de mapa + cuadrícula de rutas |
| 1 | Rutas | `routes_page.dart` | ✅ Lista estática |
| 2 | Perfil | `profile_page.dart` | 🔜 Placeholder |

---

## Paleta de Colores — Vibrant Sunset

| Nombre | Hex | Rol |
|--------|-----|-----|
| Pumpkin Spice | `#FF6D00` | Primario / nav activo |
| Princeton Orange | `#FF8500` | Botones / título AppBar |
| Amber Glow | `#FF9E00` | Chips / insignias de tiempo |
| Lavender Purple | `#9D4EDD` | Acento / 4to color de ruta |
| Dark Amethyst | `#240046` | Fondo del scaffold |
| Indigo Ink | `#3C096C` | Superficie (tarjetas, nav bar) |
| Indigo Velvet | `#5A189A` | Superficie elevada (diálogos) |

---

## Fases

- **Fase 1** — código base anterior (mapa canvas con cuadrícula, SQLite conectado)
- **Fase 2** — reconstrucción limpia, tiles de mapa reales, sin BD
- **Fase 3** — mapa en página principal, capas de ruta, pestaña Perfil ← *estás aquí*
- **Fase 3b** — reintegración de SQLite, reemplazar `route_data.dart` con consultas a BD
- **Fase 4** — preferencias de usuario, rutas guardadas, pulido para producción

---

## pubspec.yaml — dependencias activas

```yaml
dependencies:
  flutter_map: ^6.1.0
  latlong2: ^0.9.1
  google_fonts: ^6.2.1
  # sqflite: ^2.4.2        # Fase 3b
  # path: ^1.9.0           # Fase 3b
```
