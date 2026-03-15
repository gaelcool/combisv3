import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

// Re-exportar para que cualquier archivo que importe app_theme.dart obtenga AppColors gratis.
// Uso en páginas: import '../theme/app_theme.dart'; → AppColors.primary, etc.
export 'app_colors.dart';
// The following apptheme class can be passed over for anything so long as you
// SImplify the build context in main so it just returns the following theme.
class AppTheme {
  AppTheme._(); // no instanciable

  static const String appTitle = 'combis app';

  static ThemeData get darkTheme {
    // Texto base oscuro de Material.
    // Ahora usa la fuente 'Inter' local configurada en pubspec.yaml.
    final baseTextTheme = ThemeData.dark().textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',

      // ── Esquema de color ─────────────────────────────────────────────────
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary, // pumpkinSpice  #FF6D00
        onPrimary: AppColors.textPrimary,
        secondary: AppColors.accent, // lavenderPurple #9D4EDD
        onSecondary: AppColors.textPrimary,
        tertiary: AppColors.primaryLighter, // amberGlow      #FF9E00
        onTertiary: AppColors.darkAmethyst,
        error: AppColors.error,
        onError: AppColors.textPrimary,
        surface: AppColors.surface, // indigoInk      #3C096C
        onSurface: AppColors.textPrimary,
      ),

      scaffoldBackgroundColor: AppColors.background, // darkAmethyst   #240046
      // ── Tipografía (Inter) ───────────────────────────────────────────────
      textTheme: baseTextTheme.copyWith(
        // Encabezados grandes — ej. títulos de página
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        // Títulos de sección dentro de páginas
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        // Cuerpo del texto
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
        // Leyendas, insignias, etiquetas pequeñas
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontSize: 11,
        ),
      ),

      // ── AppBar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,

        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.primaryLight, // princetonOrange en app bar
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),

      // ── Navegación inferior ──────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary, // pumpkinSpice
        unselectedItemColor: AppColors.textDisabled,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 8,
      ),

      // ── Tarjetas ─────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceElevated, // indigoVelvet #5A189A
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: AppColors.border, width: 2),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      ),

      // ── Botón elevado ────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),

      // ── Botón de texto ───────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Campos de entrada / búsqueda ─────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        hintStyle: const TextStyle(color: AppColors.textDisabled),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.primaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),

      // ── Divisor ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevated,
        labelStyle: TextStyle(
          color: AppColors.amberGlow,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // ── Snackbar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.indigoVelvet,
        contentTextStyle: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
