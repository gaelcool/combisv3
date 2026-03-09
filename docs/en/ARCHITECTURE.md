# combis app — Architecture & Developer Guide

This document explains what each file does, what each tab is responsible for, and what the development phases involve. It is intended for both current team members and any future contributors picking up the project.

---

## Project Context

Combis App is a mobile transit guide for combi (minibus) routes in Chiautempan, Tlaxcala, México. The goal is to show users available routes, let them explore the map, and eventually show live or near-live combi positions. The app targets Android as the primary platform, with Linux desktop used during development for faster iteration (no emulator needed).

---

## Development Phases

### Phase 1 — Original Prototype
The first version of the app was built to validate the data model and UI structure. It included a working SQLite database, a custom grid-based canvas map drawn with Flutter's `CustomPainter`, and a Dev tab for resetting the database during development. Routes were seeded with hardcoded data directly in `main.dart`.

**What existed:** `DatabaseHelper`, `AppRoute` model, `Point` model, `MapCanvas` widget, `RouteCard` widget, `DevPage`, `SearchPage`, `ProfilePage`, bottom nav with 4 tabs (Cales, Búsqueda, Perfil, Dev).

**What the problem was:** The canvas map was abstract — it drew routes on a coordinate grid, not on a real geographic map. It served its purpose for data validation but was not something a real user could navigate. The codebase also had seeding logic mixed into `main.dart`, which violated single responsibility and made it harder to hand off.

---

### Phase 2 — Clean Rebuild
The project was restarted from a fresh Flutter app to establish a cleaner file structure and replace the canvas map with real OpenStreetMap tiles via `flutter_map`. The database and all SQLite-related code were deliberately disabled and commented out — not deleted — so nothing is lost. All data is hardcoded directly in the pages. The palette was redesigned around the "Vibrant Sunset" color set (oranges + deep violets).

**Goal of Phase 2:** get a compilable, navigable app with a real map on screen before any data layer is reintroduced. Every DB-related TODO in the code is tagged with `// TODO: Phase 3b`.

---

### Phase 3 — Map on Home Page + Route Overlays (Current)
Phase 3 moved the map from a dedicated fullscreen tab to an embedded widget on the home page. A reusable `MapWidget` was created that supports polyline and stop marker overlays. Route data is hardcoded in a temporary file (`data/route_data.dart`).

**What changed in Phase 3:**
- Deleted `map_page.dart` (fullscreen map tab)
- Created `widgets/map_widget.dart` — reusable map widget with overlay support
- Created `data/route_data.dart` — temporary route data (⚠️ not for production)
- Created `pages/profile_page.dart` — placeholder for Perfil tab
- Modified `home_page.dart` — hero banner replaced with square map card + route selection
- Modified `main_screen.dart` — nav changed to Inicio | Rutas | Perfil | Paradas
- Tapping a route button highlights the corresponding polyline and shows stop markers

**What exists now:** 4-tab nav shell (Inicio/Rutas/Perfil/Paradas), `home_page.dart` with map card + route grid, `routes_page.dart` with route cards, `map_widget.dart` with tiles + polyline/marker overlays, `profile_page.dart` and `paradas_page.dart` as placeholders, `route_data.dart` with temporary data.

---

### Phase 3b — Data Layer Re-integration (Upcoming)
Phase 3b reconnects the SQLite backend to the UI. The models (`AppRoute`, `Point`) and `DatabaseHelper` from Phase 1 are preserved and ready — they just need to be re-imported and the commented-out blocks in `main.dart` uncommented.

**What Phase 3b involves:**
- Re-enable `sqflite` + `path` in `pubspec.yaml`
- Re-enable `sqflite_common_ffi` init in `main.dart` for Linux desktop
- Move seed data out of `main.dart` into a dedicated `utils/seeder.dart`
- Wire `RoutesPage` and `HomePage` to read from `DatabaseHelper` instead of hardcoded lists
- Replace `data/route_data.dart` with DB queries that construct `RouteOverlay`
- Dev tools return as a hamburger menu in the AppBar, gated behind `kDebugMode`

---

### Phase 4 — Production Polish
- User preferences and saved routes
- Full profile page
- Performance optimization
- APK build preparation

---

## File-by-File Breakdown

### `lib/main.dart`
The app entry point. Calls `WidgetsFlutterBinding.ensureInitialized()`, then runs `CombisApp`. In Phase 3 there is no async work here — no database initialization, no seeding. The DB init block is commented out and clearly marked. `CombisApp` is a `StatelessWidget` that builds a `MaterialApp` pointing at `AppTheme.darkTheme` and `MainScreen` as its home.

---

### `lib/pages/main_screen.dart`
The root shell of the app. Holds a `Scaffold` with a `BottomNavigationBar` (3 items) and an `IndexedStack` body. `IndexedStack` is intentional — it keeps all three pages alive in memory so they do not rebuild when the user switches tabs. Tab state (scroll position, loaded data) is preserved across navigation.

---

### `lib/pages/home_page.dart` — Tab 0: Inicio
Matches the "Rutas Disponibles" mockup screen. Structure from top to bottom:

- `AppBar` with hamburger icon (left), centered title, menu icon (right). The hamburger will eventually open a drawer containing dev tools in debug builds.
- `MapWidget` — a square map card with live OSM tiles and polyline/marker overlays. Shows all routes as thin lines; the selected route is highlighted with a bold stroke and visible stop markers.
- "¿A DÓNDE VAMOS HOY?" tagline in bold.
- A 2-column `GridView` of 8 route buttons (`_RouteButton`), each colored with one of the 4 palette colors cycling in order. Tapping a button selects/deselects the route on the map. Buttons without overlay data show a `SnackBar`.
- An `OutlinedButton` at the bottom ("Ver Todas") intended to eventually navigate to the full route list.

The first 3 route buttons have `overlayIndex` values linking them to `sampleRoutes` data. The rest have `null` (no data yet).

---

### `lib/pages/routes_page.dart` — Tab 1: Rutas
Shows the list of available combi routes as scrollable cards. Each card (`_RouteCard`) displays:

- A colored circular badge with the route letter (A–E)
- The route name (origin → destination)
- A time chip showing estimated travel time

The data source is a hardcoded `const List<_RouteItem>` defined at the top of the file. In Phase 3b, `_RouteItem` is removed and `AppRoute` takes over.

Tapping a card currently shows a `SnackBar`. In Phase 3b this navigates to a route detail view or highlights the route on the map.

---

### `lib/pages/profile_page.dart` — Tab 2: Perfil
Placeholder page with a circular avatar icon, "Próximamente" text, and "Preferencias y rutas guardadas" subtitle. Will be completed in Phase 4.

---

### `lib/pages/paradas_page.dart` — Tab 3: Paradas
Shows a list of all stops (points of interest) in the city. Currently a placeholder with "Próximamente" but will evolve into a search and filter page for specific locations and what routes pass through them.

---

### `lib/widgets/map_widget.dart`
Reusable map widget based on `FlutterMap`. Accepts configurable parameters:

- `height` — fixed height for card mode, or null to expand
- `routes` — list of `RouteOverlay` to draw as polylines
- `selectedRouteIndex` — highlighted route index (bold stroke + markers)
- `interactive` — enables/disables pan and zoom
- `borderRadius` — corner clipping when embedded in cards

Uses a dark color filter (`ColorFilter.matrix`) to invert tiles and maintain visual coherence with the dark violet/orange palette.

---

### `lib/data/route_data.dart`
⚠️ **TEMPORARY FILE** — development only. Contains hardcoded data for 3 sample routes with real Chiautempan coordinates (~19.306°N, -98.187°W). Each route has a polyline path (`List<LatLng>`) and named stops (`StopPoint`). Will be completely replaced by DB queries in Phase 3b.

---

### `lib/theme/app_colors.dart`
Defines every color constant used in the app. Based on the "Vibrant Sunset" palette. Colors are split into semantic groups: oranges (primary brand), dark violets (backgrounds), accent (lavender), text, semantic (error/success/warning), and borders. Convenience aliases (`primary`, `surface`, `background`, etc.) are provided so `AppTheme` code reads naturally.

This file is never imported directly by pages (except `map_widget.dart` which needs it directly) — it generally comes in through `app_theme.dart`'s re-export.

---

### `lib/theme/app_theme.dart`
Builds the full `ThemeData` object consumed by `MaterialApp`. Imports `google_fonts` to apply `Inter` across all text styles. Configures: `colorScheme`, `scaffoldBackgroundColor`, `textTheme`, `appBarTheme`, `bottomNavigationBarTheme`, `cardTheme`, `elevatedButtonTheme`, `textButtonTheme`, `inputDecorationTheme`, `dividerTheme`, `chipTheme`, and `snackBarTheme`.

Re-exports `app_colors.dart` so any file importing `app_theme.dart` gets `AppColors` for free.

**Font note:** `google_fonts` fetches `Inter` from `fonts.googleapis.com` on first launch and caches it locally. No manual asset setup is needed. If the app needs to work fully offline from first launch, the font `.ttf` files can be bundled under `assets/fonts/` instead.

---

### `lib/utils/common.dart`
Two logging functions (`debugLog`, `errorLog`) that only print in `kDebugMode`, plus formatting helpers (`formatDuration`, `formatDistance`) and simple validation (`isNotEmpty`). Also holds the database constants (`databaseName`, `databaseVersion`) even though they are currently unused — kept here so Phase 3b has a single place to reference them.

---

## Import Chain

```
main.dart
  └── theme/app_theme.dart
        ├── theme/app_colors.dart   (imported + re-exported)
        └── google_fonts
  └── pages/main_screen.dart
        ├── pages/home_page.dart
        │     ├── theme/app_theme.dart
        │     ├── widgets/map_widget.dart
        │     │     ├── flutter_map
        │     │     ├── latlong2
        │     │     ├── data/route_data.dart
        │     │     └── theme/app_colors.dart
        │     └── data/route_data.dart
        ├── pages/routes_page.dart
        │     └── theme/app_theme.dart
        └── pages/profile_page.dart
              └── theme/app_theme.dart
  └── utils/common.dart
```

`app_colors.dart` never appears as a direct import in any page (except `map_widget.dart` which needs it directly) — it generally arrives via `app_theme.dart`. This means changing a color only requires touching one file.

---

## What Is Intentionally Missing Right Now

| Item | Location in Phase 1 | Status |
|------|---------------------|--------|
| `DatabaseHelper` | `lib/database/database_helper.dart` | Exists, unused |
| `AppRoute` model | `lib/models/route.dart` | Exists, unused |
| `Point` model | `lib/models/point.dart` | Exists, unused |
| `MapCanvas` widget | `lib/widgets/map_canvas.dart` | Superseded by flutter_map |
| `RouteCard` widget | `lib/widgets/route_card.dart` | Superseded by local `_RouteCard` |
| `SearchPage` | `lib/pages/search_page.dart` | Exists from Phase 1, not in nav |
| `DevPage` | `lib/pages/dev_page.dart` | Returning as hamburger menu |
| DB seeding | was in `main.dart` | Moving to `utils/seeder.dart` |

None of these are deleted. They sit in the project and will be reconnected in Phase 3b.
