import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ParadasPage extends StatelessWidget {
  const ParadasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paradas')),
      body: const Center(child: Text('Paradas')),
    );
  }
}
