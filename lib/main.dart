import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/main_screen.dart';
import 'utils/common.dart';

// TODO: Fase 3b — Reactivar cuando la capa SQLite esté lista
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Fase 3b — Inicialización SQLite para escritorio
  // if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }

  // await _initializeDatabase();

  debugLog('App iniciada — Capa DB deshabilitada (Fase 3)', tag: 'MAIN');

  runApp(const CombisApp());
}

// ─── TODO: Fase 3b — Restaurar cuando se reactive la BD ─────────────────────
// Future<void> _initializeDatabase() async {
//   final db = DatabaseHelper.instance;
//   final hasData = await db.hasData();
//   if (!hasData) {
//     await _seedSampleData();
//   }
// }
//
// Future<void> _seedSampleData() async {
//   // Lógica de siembra aquí — ver Truemain.dart como referencia
// }
// ─────────────────────────────────────────────────────────────────────────────

class CombisApp extends StatelessWidget {
  const CombisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTheme.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
    );
  }
}
