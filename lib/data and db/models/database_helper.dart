import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../utils/common.dart';
import 'route.dart';

/// Manejador de Base de Datos SQLite
/// Centrado en la gestión de rutas y persistencia local.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'combisapp.db');

    debugLog('Database path: $path', tag: 'DB');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      debugLog('Creating database schema...', tag: 'DB');

      // Tabla de rutas (basada en el modelo AppRoute)
      await db.execute('''
        CREATE TABLE routes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          number TEXT NOT NULL UNIQUE,
          name TEXT NOT NULL,
          color TEXT NOT NULL,
          description TEXT,
          start_point TEXT NOT NULL,
          end_point TEXT NOT NULL,
          estimated_time INTEGER NOT NULL,
          is_active INTEGER NOT NULL DEFAULT 1,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      // Tabla de paradas (asociadas a rutas)
      await db.execute('''
        CREATE TABLE stops (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          route_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          order_in_route INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          FOREIGN KEY (route_id) REFERENCES routes (id) ON DELETE CASCADE
        )
      ''');

      debugLog('✓ Database schema created', tag: 'DB');
    } catch (e, stackTrace) {
      errorLog(
        'Failed to create schema',
        error: e,
        stackTrace: stackTrace,
        tag: 'DB',
      );
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar si la versión de la BD cambia
  }

  Future<List<AppRoute>> getAllRoutes() async {
    try {
      Database database = await db;
      final maps = await database.query('routes', orderBy: 'number ASC');
      return maps.map((map) => AppRoute.fromMap(map)).toList();
    } catch (e) {
      errorLog('Failed to get all routes', error: e, tag: 'DB');
      return [];
    }
  }

  Future<AppRoute?> getRouteById(int id) async {
    try {
      Database database = await db;
      final maps = await database.query(
        'routes',
        where: 'id = ?',
        whereArgs: [id],
      );
      return maps.isNotEmpty ? AppRoute.fromMap(maps.first) : null;
    } catch (e) {
      errorLog('Failed to get route by ID', error: e, tag: 'DB');
      return null;
    }
  }

  Future<int> insertRoute(AppRoute route) async {
    try {
      Database database = await db;
      return await database.insert('routes', route.toMap());
    } catch (e) {
      errorLog('Failed to insert route', error: e, tag: 'DB');
      return -1;
    }
  }

  Future<int> updateRoute(AppRoute route) async {
    try {
      Database database = await db;
      return await database.update(
        'routes',
        route.toMap(),
        where: 'id = ?',
        whereArgs: [route.id],
      );
    } catch (e) {
      errorLog('Failed to update route', error: e, tag: 'DB');
      return -1;
    }
  }

  Future<int> deleteRoute(int id) async {
    try {
      Database database = await db;
      return await database.delete('routes', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      errorLog('Failed to delete route', error: e, tag: 'DB');
      return -1;
    }
  }

  Future<bool> hasData() async {
    try {
      Database database = await db;
      final result = await database.rawQuery(
        'SELECT COUNT(*) as count FROM routes',
      );
      final count = result.first['count'] as int;
      return count > 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> resetDatabase() async {
    try {
      debugLog('Resetting database...', tag: 'DB');
      Database database = await db;
      await database.execute('DROP TABLE IF EXISTS stops');
      await database.execute('DROP TABLE IF EXISTS routes');
      await _onCreate(database, 1);
      debugLog('✓ Database reset successfully', tag: 'DB');
    } catch (e, stackTrace) {
      errorLog(
        'Database reset failed',
        error: e,
        stackTrace: stackTrace,
        tag: 'DB',
      );
      rethrow;
    }
  }

  Future<void> closeDb() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      debugLog('Database closed', tag: 'DB');
    }
  }
}
