# combis app — Arquitectura y Guía del Desarrollador

Este documento deberia de forma concisa explicar lo qué hace cada archivo, de qué es responsable cada pestaña y alguna información sobre las fases de desarrollo. Espero que lo lean todo.

---

## Contexto del Proyecto

Combis App es una guía de tránsito móvil para rutas de combis en aunque todavia no hemos discutido el rango que tendra nuestra app, este demo incluye un prototipo para Chiautempan. El objetivo es mostrar a los usuarios las rutas disponibles, permitirles explorar el mapa y eventualmente mostrar posiciones de combis en vivo o casi en tiempo real. La app tiene como plataforma principal Android, usando Linux de escritorio durante el desarrollo para iteración más rápida (sin necesidad de emulador). La verdad correrla es lo mismo en windows, donde abres el projecto en visual, y con que tengas flutter en tu path podras hacer flutter pub get y flutter -d web-server para correrla localmente. 

*Obtener una apk compilada de la app es un goal de alta importancia*

---

## Fases de Desarrollo

### Fase 1 — Prototipo Original
La primera versión de la app se construyó para validar el modelo de datos y la estructura de UI. Incluía una base de datos SQLite funcional, un mapa canvas personalizado dibujado con `CustomPainter` de Flutter, y una pestaña Dev para resetear la base de datos durante el desarrollo. Las rutas se sembraban con datos estáticos directamente en `main.dart`. Aunque no sea optimo.

**Cuál era el problema:** El mapa canvas era abstracto — dibujaba rutas en una cuadrícula de coordenadas, no en un mapa geográfico real. Cumplió su propósito para validación de datos pero no era algo que un usuario real pudiera navegar. El código también tenía lógica de siembra mezclada en `main.dart`, lo que violaba la responsabilidad única y dificultaba el traspaso.

---

### Fase 2 — Reconstrucción Limpia
El proyecto se reinició desde una app Flutter limpia para establecer una estructura de archivos más ordenada y reemplazar el mapa canvas con tiles reales de OpenStreetMap vía `flutter_map`. La base de datos y todo el código relacionado con SQLite fueron deliberadamente deshabilitados y comentados — no eliminados — para que nada se pierda. Todos los datos están estáticos directamente en las páginas. La paleta se rediseñó alrededor del conjunto de colores "Vibrant Sunset" (naranjas + violetas profundos). Pero en si claramente le falta una personalidad propia todavia.

**Objetivo de la Fase 2:** obtener una app compilable y navegable con un mapa real en pantalla antes de reintroducir cualquier capa de datos. Cada TODO relacionado con BD en el código está etiquetado con `// TODO: Fase 3b`.

---

### Fase 3 — Mapa en Página Principal + Capas de Ruta (Actual)
Fase 3 mueve el mapa de una pestaña dedicada a un widget incrustado en la página principal. Se crea un `MapWidget` reutilizable que soporta capas de polilíneas y marcadores de parada. (*Tip: investiga stateless vs stateful widgets, conceptos de dart*). Los datos de ruta son estáticos en un archivo temporal (`data/route_data.dart`).

**Lo que cambió en la Fase 3:**
- Se creó `widgets/map_widget.dart` — widget de mapa reutilizable con soporte de capas
- Se creó `data/route_data.dart` — datos de ruta temporales (⚠️ no para producción)
- Se creó `pages/profile_page.dart` — placeholder para la pestaña Perfil
- Se modificó `home_page.dart` — banner reemplazado por tarjeta cuadrada de mapa con selección de ruta
- Se modificó `main_screen.dart` — nav cambiado a Inicio | Rutas | Perfil
- Tocar un botón de ruta resalta la polilínea correspondiente y muestra marcadores de parada

**Lo que existe ahora:** Nav de 3 pestañas (Inicio/Rutas/Perfil), `home_page.dart` con tarjeta de mapa + cuadrícula de rutas, `routes_page.dart` con tarjetas de ruta, `map_widget.dart` con tiles + capas de polilíneas/marcadores, `profile_page.dart` como placeholder, `route_data.dart` con datos temporales.

---

## La Gran Decisión: Arquitectura de Base de Datos

**Pregunta original:** ¿SQLite local? ¿MySQL en servidor? ¿Híbrido?

**Respuesta decidida: Híbrido (SQLite Local + Servidor Remoto)**

**Por qué?**
- **SQLite solo** = datos duplicados en 100 teléfonos, inconsistencia si cambias una ruta, reinstalación pierde datos
- **Servidor solo** = requiere internet siempre, latencia, costo
- **Híbrido** = mejor de ambos mundos

**Arquitectura:**
1. **Servidor** (PostgreSQL/MySQL) = fuente de verdad (rutas, paradas, usuarios, favoritos)
2. **SQLite Local** = caché rápido, offline-first. Se descarga una sola vez
3. **API REST** = sincronización + autenticación JWT

### Fase 3b — Reintegración de Capa de Datos (Próxima)
La Fase 3b podria reconecta el backend SQLite a la UI. _O_ podriamos tomar el camino dificil e integrar ambas bases en este paso...
-Me gustaria mencionar que sigo super en duda de como vamos a taclear la base de datos,tengo mas claro algunas dudas pero, ¿Ustedes que opinan? Incluire el schema del db como lo veo ahora, tipo diagrama de entidad ;)

**6 tablas principales:**
- `usuarios` — email, username, password_hash, is_admin, created_at, updated_at
- `rutas` — number, name, color (hex), descripción, start/end_point, estimated_time, is_active
- `paradas` — route_id (FK), name, latitude, longitude, order_in_route
- `user_favorites` — user_id (FK), route_id (FK) [relación M:N]
- `user_locations` — historico de dónde estuvieron los usuarios (analytics)
- `combi_locations` — (futuro) GPS en vehículos


## Roadmap: Próximas Fases


**Lo que involucraría la Fase 3b:**
- Reactivar `sqflite` + `path` en `pubspec.yaml` o usar firebase/mysql.
- Reactivar init de `sqflite_common_ffi` en `main.dart` ** Nota, esa dependencia puede que no sirva en windows
- Mover datos de siembra a un `utils/seeder.dart` dedicado
- Conectar `RoutesPage` y `HomePage` para leer de `DatabaseHelper` en vez de listas estáticas
- Reemplazar `data/route_data.dart` con consultas a BD que construyan `RouteOverlay`
- Herramientas de desarrollo regresan como menú hamburguesa en el AppBar, protegidas con `kDebugMode`

### Fase 3c — Geolocalización + Spawn Point
- Agregar `geolocator` (permisos en runtime)
- Crear selector visual: usuario elige dónde está (Centro, Mercado, Hospital, Estación, etc.)
- Mapa centra automáticamente en spawn point
- Registra ubicación en `user_locations` (para analytics)

### Fase 4 — Servidor + Autenticación + Compilación APK
- Backend (Django/Node.js) + PostgreSQL
- API REST: `/routes`, `/users`, `/auth`
- JWT tokens para autenticación
- WebSocket para posiciones en vivo
- Login screen
- Optimizaciones de rendimiento
- Sincronización offline-first (local ↔ remoto)
- **Compilación APK lista para Google Play**

### Fase 5 — Tiempo Real + Pulido para producción
- GPS en combis (tabla `combi_locations`)
- Google Play Store release


---

## Desglose Archivo por Archivo

### `lib/main.dart`
Punto de entrada de la app. Llama a `WidgetsFlutterBinding.ensureInitialized()`, luego ejecuta `CombisApp`. En Fase 3 no hay trabajo asíncrono aquí — sin inicialización de base de datos, sin siembra. El bloque de init de BD está comentado y claramente marcado. `CombisApp` es un `StatelessWidget` que construye un `MaterialApp` apuntando a `AppTheme.darkTheme` y `MainScreen` como su casa.

---

### `lib/pages/main_screen.dart`
El shell raíz de la app. Contiene un `Scaffold` con un `BottomNavigationBar` (3 ítems) y un cuerpo `IndexedStack`. `IndexedStack` es intencional — mantiene las tres páginas activas en memoria para que no se reconstruyan al cambiar de pestaña. El estado de las pestañas (posición de scroll, datos cargados) se preserva durante la navegación.

---

### `lib/pages/home_page.dart` — Pestaña 0: Inicio
Coincide con la pantalla "Rutas Disponibles" del mockup. Estructura de arriba a abajo:

- `AppBar` con ícono hamburguesa (izquierda), título centrado, ícono de menú (derecha). La hamburguesa eventualmente abrirá un cajón con herramientas dev en compilaciones debug.
- `MapWidget` — tarjeta cuadrada de mapa con tiles OSM en vivo y capas de polilíneas/marcadores. Muestra todas las rutas como líneas delgadas; la ruta seleccionada se resalta con trazo grueso y marcadores de parada visibles.
- Slogan "¿A DÓNDE VAMOS HOY?" en negrita como martin.
- `GridView` de 2 columnas con 8 botones de ruta (`_RouteButton`), cada uno coloreado con uno de los 4 colores de la paleta en rotación. Tocar un botón selecciona/deselecciona la ruta en el mapa. Los botones sin datos de capa muestran un `SnackBar`.
- Un `OutlinedButton` al final ("Ver Todas") destinado a navegar a la lista completa de rutas.

Los primeros 3 botones de ruta tienen `overlayIndex` que los conectan a los datos en `sampleRoutes`. Los demás tienen `null` (sin datos aún).

---

### `lib/pages/routes_page.dart` — Pestaña 1: Rutas
Muestra la lista de rutas de combis disponibles como tarjetas desplazables. Cada tarjeta (`_RouteCard`) muestra:

- Una insignia circular coloreada con la letra de ruta (A–E)
- El nombre de la ruta (origen → destino)
- Un chip de tiempo con el tiempo estimado de viaje

La fuente de datos es una `const List<_RouteItem>` estática definida al inicio del archivo. En Fase 3b, `_RouteItem` se reemplaza con `AppRoute` del modelo compartido.

Tocar una tarjeta actualmente muestra un `SnackBar`. En Fase 3b navegará a una vista de detalle de ruta o resaltará la ruta en el mapa.

---

### `lib/pages/profile_page.dart` — Pestaña 2: Perfil
Página placeholder con un ícono de avatar circular, texto "Próximamente" y subtítulo "Preferencias y rutas guardadas". Se completará en Fase 4.

---

### `lib/widgets/map_widget.dart`
Widget de mapa reutilizable basado en `FlutterMap`. Acepta parámetros configurables:

- `height` — altura fija para tarjeta, o null para expandirse
- `routes` — lista de `RouteOverlay` para dibujar polilíneas
- `selectedRouteIndex` — índice de ruta resaltada (trazo grueso + marcadores)
- `interactive` — habilita/deshabilita paneo y zoom
- `borderRadius` — recorte de esquinas al incrustar en tarjetas

Usa un filtro de color oscuro (`ColorFilter.matrix`) para invertir los tiles y mantener coherencia visual con la paleta oscura violeta/naranja.

---

### `lib/data/route_data.dart`
⚠️ **ARCHIVO TEMPORAL** — solo para desarrollo. Contiene datos estáticos de 3 rutas de ejemplo con coordenadas reales de Chiautempan (~19.306°N, -98.187°O). Cada ruta tiene un trayecto de polilínea (lista de `LatLng`) y paradas con nombre (`StopPoint`). Será reemplazado completamente por consultas a BD en Fase 3b.

---

### `lib/theme/app_colors.dart`
Define todas las constantes de color usadas en la app. Los colores están divididos en grupos semántico para que el código de `AppTheme` sea legible.

Este archivo nunca se importa directamente en las páginas — llega a través del re-export de `app_theme.dart`.

---

### `lib/theme/app_theme.dart`
Construye el objeto `ThemeData` completo consumido por `MaterialApp`. Importa `google_fonts` para aplicar `Inter` en todos los estilos de texto. Aunque en terminos de optimizacion, google fonts es lejos a lo mejor. Funciona bien por ahora y configura: `colorScheme`, `scaffoldBackgroundColor`, `textTheme`, `appBarTheme`, `bottomNavigationBarTheme`, `cardTheme`, `elevatedButtonTheme`, `textButtonTheme`, `inputDecorationTheme`, `dividerTheme`, `chipTheme` y `snackBarTheme`.

Además re-exporta `app_colors.dart` para que cualquier página que haga `import '../theme/app_theme.dart'` obtenga `AppColors` gratis.

**Nota sobre fuentes:** `google_fonts` descarga `Inter` de `fonts.googleapis.com` en el primer lanzamiento y la cachea localmente. Si la app necesita funcionar completamente offline desde el primer lanzamiento, los archivos `.ttf` se pueden empaquetar bajo `assets/fonts/`.

---

### `lib/utils/common.dart`
Dos funciones de logging (`debugLog`, `errorLog`) que solo imprimen en `kDebugMode`, además de helpers de formato (`formatDuration`, `formatDistance`) y validación simple (`isNotEmpty`). También contiene las constantes de base de datos (`databaseName`, `databaseVersion`) aunque actualmente no se usan — se mantienen aquí para que Fase 3b tenga un solo lugar de referencia y es buena práctica de debugeo.

---

## Cadena de Imports

```
main.dart
  └── theme/app_theme.dart
        ├── theme/app_colors.dart   (importado + re-exportado)
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



## Lo Que Está Intencionalmente Ausente Ahora

| Elemento | Ubicación en Fase 1 | Estado |
|----------|---------------------|--------|
| `DatabaseHelper` | `lib/database/database_helper.dart` | Existe, sin usar |
| Modelo `AppRoute` | `lib/models/route.dart` | Existe, sin usar |
| Modelo `Point` | `lib/models/point.dart` | Existe, sin usar |
| Widget `MapCanvas` | `lib/widgets/map_canvas.dart` | Reemplazado por flutter_map |
| Widget `RouteCard` | `lib/widgets/route_card.dart` | Reemplazado por `_RouteCard` local |
| `SearchPage` | `lib/pages/search_page.dart` | Existe de Fase 1, no está en nav |
| `DevPage` | `lib/pages/dev_page.dart` | Regresa como menú hamburguesa |
| Siembra de BD | estaba en `main.dart` | Se moverá a `utils/seeder.dart` |


