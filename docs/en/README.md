# combis app

> A Flutter transit guide app for combi routes in Chiautempan, Tlaxcala.

---

## Stack

- **Flutter** — UI framework
- **flutter_map** — OpenStreetMap tile rendering
- **latlong2** — coordinate types for the map
- **google_fonts** — Inter typeface, fetched & cached at runtime
- **sqflite** — SQLite persistence *(disabled, Phase 3b)*

---

## Current State — Phase 3

The app runs with **no database**. Route data is hardcoded in `data/route_data.dart` (temporary file — not for shared/production builds). The map renders live OSM tiles inside a card on the home page with polyline + stop marker overlays.

---

## Structure

```
combisv3/
├── lib/
│   ├── main.dart                  # Entry point — no DB init
│   ├── data/
│   │   └── route_data.dart       # ⚠️ TEMP — hardcoded route overlays
│   ├── pages/
│   │   ├── main_screen.dart      # Bottom nav shell (3 tabs)
│   │   ├── home_page.dart        # Tab 0 — map card + route grid
│   │   ├── routes_page.dart      # Tab 1 — route list
│   │   └── profile_page.dart     # Tab 2 — placeholder
│   ├── widgets/
│   │   └── map_widget.dart       # Reusable map with overlay support
│   ├── theme/
│   │   ├── app_theme.dart        # ThemeData + re-exports AppColors
│   │   └── app_colors.dart       # Vibrant Sunset palette
│   └── utils/
│       └── common.dart           # debugLog / errorLog
└── pubspec.yaml
```

---

## Tabs

| # | Label | Page | Status |
|---|-------|------|--------|
| 0 | Inicio | `home_page.dart` | ✅ Map card + route grid |
| 1 | Rutas | `routes_page.dart` | ✅ Hardcoded list |
| 2 | Perfil | `profile_page.dart` | 🔜 Placeholder |

---

## Color Palette — Vibrant Sunset

| Name | Hex | Role |
|------|-----|------|
| Pumpkin Spice | `#FF6D00` | Primary / active nav |
| Princeton Orange | `#FF8500` | Buttons / AppBar title |
| Amber Glow | `#FF9E00` | Chips / time badges |
| Lavender Purple | `#9D4EDD` | Accent / 4th route color |
| Dark Amethyst | `#240046` | Scaffold background |
| Indigo Ink | `#3C096C` | Surface (cards, nav bar) |
| Indigo Velvet | `#5A189A` | Elevated surface (dialogs) |

---

## Phases

- **Phase 1** — prior codebase (grid canvas map, SQLite wired up)
- **Phase 2** — clean rebuild, real map tiles, no DB
- **Phase 3** — map on home page, route overlays, Perfil tab ← *you are here*
- **Phase 3b** — SQLite re-integration, replace `route_data.dart` with DB queries
- **Phase 4** — user preferences, saved routes, production polish

---

## pubspec.yaml — active dependencies

```yaml
dependencies:
  flutter_map: ^6.1.0
  latlong2: ^0.9.1
  google_fonts: ^6.2.1
  # sqflite: ^2.4.2        # Phase 3b
  # path: ^1.9.0           # Phase 3b
```
