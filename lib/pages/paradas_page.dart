import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ParadasPage extends StatelessWidget {
  const ParadasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paradas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceElevated,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Próximamente',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Preferencias y rutas guardadas',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}