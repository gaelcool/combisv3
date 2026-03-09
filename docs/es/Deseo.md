6. FLUJO DE DATOS: EJEMPLO COMPLETO, el siguiente ejemplo podria ser nuestro gol de flujo;

Escenario: "Usuario(_gael_) abre la app, ve rutas cerca suyo, marca una como favorita"

Paso 1: Usuario abre la app
App lanza → Lee de BD → tabla usuarios
Query: SELECT * FROM usuarios WHERE username = 'gael'

Resultado:
id: 1
email: gael@example.com
nombre: Gael González
is_admin: 0

Paso 2: App pide ubicación actual del usuario (con permiso)
LocationService.getCurrentPosition()
Resultado:
latitude: 19.3075
longitude: -98.1880
timestamp: 2024-03-08 10:42:00

→ Guarda en BD:
INSERT INTO user_locations (user_id, latitude, longitude)
VALUES (1, 19.3075, -98.1880)

Paso 3: App carga TODAS las rutas disponibles <--SUPER MAL PRACTICA!!! luego vemos como hacer nuestras queries mas especificas, por ahora funciona.
Query:
SELECT r.*, COUNT(p.id) as total_paradas
FROM rutas r
LEFT JOIN paradas p ON r.id = p.route_id
WHERE r.is_active = 1
GROUP BY r.id

Resultado (muestra en pantalla):
┌─────────────────────────────────┐
│ Ruta 3 (Naranja)                │
│ Santa Ana - Centro              │
│ ⏱️ 60 minutos | 5 paradas        │
│ ❤️ Agregar a favoritos          │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ Ruta A5 (Violeta)               │
│ Mercado - Estación              │
│ ⏱️ 45 minutos | 3 paradas        │
│ ❤️ Agregar a favoritos          │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ Ruta C2 (Azul)                  │
│ Hospital - Universidad          │
│ ⏱️ 90 minutos | 4 paradas        │
│ ❤️ Agregar a favoritos          │
└─────────────────────────────────┘

Paso 4: Usuario toca "Ruta 3" para ver detalle 
Query:
SELECT r.*, p.*
FROM rutas r
LEFT JOIN paradas p ON r.id = p.route_id  // Este join lo podriamos usar como ventaja para empezar a dibujar la ruta encima del mapa.
WHERE r.id = 1
ORDER BY p.order_in_route

Resultado (muestra mapa + lista):
Ruta 3: Santa Ana - Centro (Naranja)
Duración estimada: 60 minutos

Paradas:
1. Santa Ana (Inicio) - 19.3050, -98.1900
2. Mercado Viejo - 19.3060, -98.1895
3. Hospital Central - 19.3070, -98.1880
4. Parque Principal - 19.3080, -98.1870
5. Centro / Zócalo (Final) - 19.3090, -98.1860

[Mapa dibuja polilínea conectando paradas]

Paso 5: Usuario marca Ruta 3 como favorita (toca el corazón)
Click en ❤️ → App ejecuta:
INSERT INTO user_favorites (user_id, route_id)
VALUES (1, 1)

→ Ahora la Ruta 3 aparece con ❤️ ROJO en todas las listas
Paso 6: Usuario abre pestaña "Mis Favoritos"
Query:
SELECT r.*, COUNT(p.id) as total_paradas
FROM user_favorites uf
JOIN rutas r ON uf.route_id = r.id
LEFT JOIN paradas p ON r.id = p.route_id
WHERE uf.user_id = 1
GROUP BY r.id
ORDER BY uf.added_at DESC

Resultado (muestra solo favoritos):
┌─────────────────────────────────┐
│ Ruta 3 (Naranja) ❤️             │
│ Santa Ana - Centro              │
│ ⏱️ 60 minutos | 5 paradas        │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ Ruta A5 (Violeta) ❤️            │
│ Mercado - Estación              │
│ ⏱️ 45 minutos | 3 paradas        │
└─────────────────────────────────┘