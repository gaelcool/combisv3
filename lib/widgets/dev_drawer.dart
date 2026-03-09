import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../data and db/models/database_helper.dart';
import '../utils/common.dart';
import '../theme/app_theme.dart';

/// Cajón de herramientas de desarrollo (Hamburguesa)
/// Solo visible en kDebugMode.
class DevDrawer extends StatefulWidget {
  const DevDrawer({super.key});

  @override
  State<DevDrawer> createState() => _DevDrawerState();
}

class _DevDrawerState extends State<DevDrawer> {
  bool _isBusy = false;

  void _resetDatabase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Borrar Base de Datos'),
        backgroundColor: AppColors.surface,
        content: const Text(
          'Esta acción eliminará todas las rutas del almacenamiento persistente.\n'
          '\n¿Está seguro?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('BORRAR'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isBusy = true);
      try {
        await DatabaseHelper.instance.resetDatabase();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✓ Base de datos reiniciada')),
        );
      } catch (e) {
        errorLog('Failed to reset DB', error: e);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted) setState(() => _isBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si no estamos en modo debug, no mostramos nada
    if (!kDebugMode) return const SizedBox.shrink();

    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.indigoInk, AppColors.indigoVelvet],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.bug_report,
                  size: 40,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Panel de Desarrollo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Version 1.0.0+1 (Debug)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'GESTIÓN DE DATOS',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.storage_outlined,
              color: AppColors.primary,
            ),
            title: const Text('SQLite Storage'),
            subtitle: const Text('combisapp.db v1'),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _isBusy ? null : _resetDatabase,
              icon: _isBusy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: const Text('Reiniciar Base de Datos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                elevation: 0,
              ),
            ),
          ),
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'ENTORNO',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.computer, color: AppColors.textSecondary),
            title: Text('Modo Debug'),
            trailing: Chip(
              label: Text('ACTIVO', style: TextStyle(fontSize: 10)),
              backgroundColor: Colors.greenAccent,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.textSecondary),
            title: Text('Rama Actual'),
            subtitle: Text('main'),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sistema de desarrollo v0.5',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
