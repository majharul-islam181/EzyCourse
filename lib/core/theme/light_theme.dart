import 'package:flutter/material.dart';

import 'theme_extensions.dart';

const Color _seedColor = Color(0xFF6750A4);

final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
  seedColor: _seedColor,
  brightness: Brightness.light,
);

final ThemeData lightThemeData = _buildTheme(_lightColorScheme);

ThemeData _buildTheme(final ColorScheme colorScheme) {
  const double componentRadius = 12;

  return ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerLow,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(componentRadius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _inputBorder(colorScheme.outlineVariant),
      enabledBorder: _inputBorder(colorScheme.outlineVariant),
      focusedBorder: _inputBorder(colorScheme.primary, width: 1.5),
      errorBorder: _inputBorder(colorScheme.error, width: 1.5),
      focusedErrorBorder: _inputBorder(colorScheme.error, width: 1.5),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size.fromHeight(48),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(componentRadius),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(componentRadius),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        minimumSize: const Size.fromHeight(48),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(componentRadius),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(componentRadius),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      space: 1,
      thickness: 1,
    ),
    extensions: _extensions(colorScheme),
  );
}

OutlineInputBorder _inputBorder(final Color color, {final double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: width),
  );
}

List<ThemeExtension<dynamic>> _extensions(final ColorScheme colorScheme) {
  return [
    AppColorsExtension(
      primary: colorScheme.primary,
      surface: colorScheme.surface,
      surfaceContainerLow: colorScheme.surfaceContainerLow,
      surfaceContainerHighest: colorScheme.surfaceContainerHighest,
      onSurface: colorScheme.onSurface,
      onSurfaceVariant: colorScheme.onSurfaceVariant,
      error: colorScheme.error,
      outline: colorScheme.outline,
      outlineVariant: colorScheme.outlineVariant,
      secondary: colorScheme.secondary,
      background: colorScheme.surface,
      success: const Color(0xFF2E7D32),
      warning: const Color(0xFFF9A825),
      gold: const Color(0xFFFFD700),
      silver: const Color(0xFFC0C0C0),
      bronze: const Color(0xFFCD7F32),
      cardBackground: colorScheme.surfaceContainerLow,
      divider: colorScheme.outlineVariant,
    ),
    const AppSpacingExtension(
      xs: 4,
      sm: 8,
      inputGap: 8,
      cardPadding: 12,
      md: 16,
      pagePadding: 16,
      lg: 24,
      xl: 32,
      xxl: 48,
    ),
    AppRadiusExtension(
      small: BorderRadius.circular(4),
      medium: BorderRadius.circular(8),
      feedItem: BorderRadius.circular(8),
      card: BorderRadius.circular(12),
      button: BorderRadius.circular(12),
      input: BorderRadius.circular(12),
      large: BorderRadius.circular(16),
      round: BorderRadius.circular(99),
    ),
    AppShadowsExtension(
      light: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      medium: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      dark: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
  ];
}
