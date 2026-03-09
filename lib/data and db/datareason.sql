-- El siguiente codigo es solo para entender como sera el esquema de la base de datos
-- No es necesario ejecutarlo, de hecho no se recomienda ejectuarlo.

Drop table if exists rutas;
Drop table if exists user;
Drop table if exists adminuser;
Drop table if exists paradas;
-- Drop table if exists combi; Cada combi tiene rutas, pero no la agregaremos todavia al mapa

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,  -- Nunca guardes contraseñas en texto plano
    nombre TEXT NOT NULL,
    is_admin INTEGER NOT NULL DEFAULT 0,  -- 0=usuario, 1=admin
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    foreign key is_admin references adminuser(is_admin)
);

CREATE TABLE rutas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    number TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    color INTEGER NOT NULL,
    start_point TEXT NOT NULL<
    end_point TEXT NOT NULL,
    estimatedTime INTEGER,
    esta_activo INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE paradas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ruta_id INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    longitude REAL NOT NULL,
    latitude REAL NOT NULL,   --- Coordenadas especificas para las paradas puede funcionar, pero ¿Y si cambia una ruta? Con este metodo tendriamos que redistribuir la base, super lentisimo a escala.
    orden_en_rutas INTEGER NOT NULL, -- Podria ser una forma de construir el orden de las rutas en las rutas
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    Foreign key (ruta_id) references rutas(id) ON DELETE UPDATE
);


CREATE TABLE user_favorites (
  user_id INTEGER NOT NULL,
  route_id INTEGER NOT NULL,
  added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (user_id, route_id),
  FOREIGN KEY (user_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (route_id) REFERENCES rutas(id) ON DELETE CASCADE
);

CREATE TABLE user_locations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- ------------------------------------------------------
-- Descripción: Ubicación en tiempo real de combis
-- Preparado para un setup imaginario donde haya gps en los vehiculos, eventualmente combi puede ser su propia tabla mjr.
CREATE TABLE combi_ubicacion_real (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    route_id INTEGER NOT NULL,
    id_placas TEXT NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    direccion varchar null, -- Dirección en grados? o seria mejor como compass?
    velocidad varchar null, -- Velocidad en km/h, podriamos estimar cuanto tardara en llegar usando los promedios de velocidad + cantidad de paradas en un dia o algo.
    FOREIGN KEY (route_id) REFERENCES rutas(id) ON DELETE CASCADE

)

-- Usuario regular
INSERT INTO usuarios (email, username, password_hash, nombre, is_admin)
VALUES (
  'gael@example.com',
  'gael',
  '$2b$12$abcdefghijklmnopqrstuvwxyz',  -- Hash bcrypt, NO texto plano
  'Gael González',
  0
);

-- Usuario admin
INSERT INTO usuarios (email, username, password_hash, nombre, is_admin)
VALUES (
  'admin@combisapp.com',
  'admin',
  '$2b$12$xyz123456789',
  'Administrador',
  1
);

-- Resultado:
-- id | email                | username | password_hash      | nombre           | is_admin | created_at              | updated_at
-- 1  | gael@example.com     | gael     | $2b$12$abcdef...   | Gael González    | 0        | 2024-03-08 10:30:00    | 2024-03-08 10:30:00
-- 2  | admin@combisapp.com  | admin    | $2b$12$xyz12...    | Administrador    | 1        | 2024-03-08 10:31:00    | 2024-03-08 10:31:00

-- Ruta Santa Ana → Centro
INSERT INTO rutas (number, name, color, description, start_point, end_point, estimated_time)
VALUES (
  '3',
  'Santa Ana - Centro',
  '#FF6B35',           -- Naranja en hex
  'Recorre desde Santa Ana hasta el centro histórico',
  'Santa Ana',
  'Centro / Zócalo',
  60                   -- 60 minutos = 1 hora
);

-- Ruta mercado → estación
INSERT INTO rutas (number, name, color, description, start_point, end_point, estimated_time)
VALUES (
  'A5',
  'Mercado - Estación',
  '#9D4EDD',           -- Violeta
  'Conecta el mercado municipal con la estación de autobuses',
  'Mercado Municipal',
  'Estación de Autobuses',
  45
);

-- Ruta universitaria
INSERT INTO rutas (number, name, color, description, start_point, end_point, estimated_time)
VALUES (
  'C2',
  'Hospital - Universidad',
  '#3A86FF',           -- Azul
  'Servicio hacia la universidad desde el hospital central',
  'Hospital Central',
  'Universidad Autónoma',
  90
);

-- Resultado:
-- id | number | name                   | color    | description                           | start_point      | end_point              | estimated_time
-- 1  | 3      | Santa Ana - Centro     | #FF6B35  | Recorre desde Santa Ana...            | Santa Ana        | Centro / Zócalo        | 60
-- 2  | A5     | Mercado - Estación     | #9D4EDD  | Conecta el mercado municipal...       | Mercado Municipal| Estación de Autobuses  | 45
-- 3  | C2     | Hospital - Universidad | #3A86FF  | Servicio hacia la universidad...      | Hospital Central | Universidad Autónoma   | 90

-- Paradas para Ruta 3 (Santa Ana - Centro)
INSERT INTO paradas (route_id, name, latitude, longitude, order_in_route)
VALUES
  (1, 'Santa Ana (Inicio)', 19.3050, -98.1900, 1),
  (1, 'Mercado Viejo', 19.3060, -98.1895, 2),
  (1, 'Hospital Central', 19.3070, -98.1880, 3),
  (1, 'Parque Principal', 19.3080, -98.1870, 4),
  (1, 'Centro / Zócalo (Final)', 19.3090, -98.1860, 5);

-- Paradas para Ruta A5 (Mercado - Estación)
INSERT INTO paradas (route_id, name, latitude, longitude, order_in_route)
VALUES
  (2, 'Mercado Municipal', 19.3075, -98.1880, 1),
  (2, 'Calle Principal', 19.3085, -98.1875, 2),
  (2, 'Estación de Autobuses', 19.3100, -98.1900, 3);

-- Paradas para Ruta C2 (Hospital - Universidad)
INSERT INTO paradas (route_id, name, latitude, longitude, order_in_route)
VALUES
  (3, 'Hospital Central', 19.3050, -98.1860, 1),
  (3, 'Clínica Sur', 19.3040, -98.1870, 2),
  (3, 'Biblioteca Pública', 19.3030, -98.1880, 3),
  (3, 'Universidad Autónoma', 19.3020, -98.1890, 4);

-- Resultado (tabla paradas):
-- id | route_id | name                      | latitude | longitude  | order_in_route
-- 1  | 1        | Santa Ana (Inicio)        | 19.3050  | -98.1900   | 1
-- 2  | 1        | Mercado Viejo             | 19.3060  | -98.1895   | 2
-- 3  | 1        | Hospital Central          | 19.3070  | -98.1880   | 3
-- 4  | 1        | Parque Principal          | 19.3080  | -98.1870   | 4
-- 5  | 1        | Centro / Zócalo (Final)   | 19.3090  | -98.1860   | 5
-- 6  | 2        | Mercado Municipal         | 19.3075  | -98.1880   | 1
-- 7  | 2        | Calle Principal           | 19.3085  | -98.1875   | 2
-- 8  | 2        | Estación de Autobuses     | 19.3100  | -98.1900   | 3
-- ...

-- Gael (user_id=1) abrió la app desde Centro
INSERT INTO user_locations (user_id, latitude, longitude, timestamp)
VALUES (1, 19.3090, -98.1860, CURRENT_TIMESTAMP);

-- Gael se movió hacia el mercado
INSERT INTO user_locations (user_id, latitude, longitude)
VALUES (1, 19.3075, -98.1880);

-- Resultado:
-- id | user_id | latitude | longitude  | timestamp
-- 1  | 1       | 19.3090  | -98.1860   | 2024-03-08 10:40:00
-- 2  | 1       | 19.3075  | -98.1880   | 2024-03-08 10:42:00