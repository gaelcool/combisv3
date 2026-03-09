import 'package:flutter/material.dart';

/// Combis App — Sistema de Colores
/// Paleta: "Vibrant Sunset" (coolors.co/ff6d00-...-9d4edd)
///
/// ─── NOTA SOBRE FUENTES ────────────────────────────────────────────────────
/// Las fuentes se cargan vía el paquete `google_fonts` (pub.dev/packages/google_fonts)
/// que las descarga de fonts.googleapis.com en la primera ejecución y las cachea localmente.
/// No se necesita empaquetado manual de assets. Agregar a pubspec.yaml:
///   dependencies:
///     google_fonts: ^6.2.1
///
/// Uso en app_theme.dart:
///   import 'package:google_fonts/google_fonts.dart';
///   textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
/// ──────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._(); // no instanciable

  // ── Naranjas (marca principal) ────────────────────────────────────────────
  /// #FF6D00 — naranja más profundo, usado para acciones principales y nav activo
  static const Color pumpkinSpice = Color(0xFFFF6D00);

  static const Color princetonOrange = Color(0xFFFF8500);

  static const Color amberGlow = Color(0xFFFF9E00);

  // ── Fondos (del extremo violeta oscuro de la paleta) ──────────────────────
  /// #240046 — (scaffold)
  static const Color darkAmethyst = Color(0xFF240046);

  /// #3C096C — (tarjetas, app bar, barra de navegación)
  static const Color indigoInk = Color(0xFF3C096C);

  /// #5A189A — (diálogos, hojas)
  static const Color indigoVelvet = Color(0xFF5A189A);

  // ── Acento ────────────────────────────────────────────────────────────────
  /// #9D4EDD — púrpura lavanda, acento secundario (enlaces, toggles)
  static const Color lavenderPurple = Color(0xFF9D4EDD);

  // ── Texto ─────────────────────────────────────────────────────────────────
  /// Texto principal sobre fondos oscuros
  static const Color textPrimary = Color(0xFFF5F5F5);

  /// Texto secundario / atenuado
  static const Color textSecondary = Color(0xFFBBBBBB);

  /// Texto deshabilitado
  static const Color textDisabled = Color(0xFF666666);

  // ── Semántico ─────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF69F0AE);
  static const Color warning = amberGlow;

  static const Color border = Color(
    0x33FF8500,
  );

  // ── Alias de conveniencia (para legibilidad de AppTheme) ──────────────────
  static const Color primary = pumpkinSpice;
  static const Color primaryLight = princetonOrange;
  static const Color primaryLighter = amberGlow;
  static const Color background = darkAmethyst;
  static const Color surface = indigoInk;
  static const Color surfaceElevated = indigoVelvet;
  static const Color accent = lavenderPurple;
}
