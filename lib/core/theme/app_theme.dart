import 'package:flutter/material.dart';
import 'package:journey/core/theme/appearance_palette.dart';

abstract final class AppTheme {
  static ThemeData light({
    AppBackgroundPreset background = AppBackgroundPreset.parchment,
    AppAccentPreset accent = AppAccentPreset.gold,
  }) {
    return _build(
      brightness: Brightness.light,
      background: background,
      accent: accent,
    );
  }

  static ThemeData dark({
    AppBackgroundPreset background = AppBackgroundPreset.parchment,
    AppAccentPreset accent = AppAccentPreset.gold,
  }) {
    return _build(
      brightness: Brightness.dark,
      background: background,
      accent: accent,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required AppBackgroundPreset background,
    required AppAccentPreset accent,
  }) {
    final palette = ResolvedAppearance.resolve(
      background: background,
      accent: accent,
      brightness: brightness,
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.accent,
      brightness: brightness,
      surface: palette.surface,
      primary: palette.accent,
      onPrimary: palette.onAccent,
    ).copyWith(
      onSurface: palette.onSurface,
    );

    final baseText = Typography.material2021(
      platform: TargetPlatform.linux,
      colorScheme: colorScheme,
    );
    final textTheme = (brightness == Brightness.light
            ? baseText.black
            : baseText.white)
        .apply(
          bodyColor: palette.onSurface,
          displayColor: palette.onSurface,
        )
        .copyWith(
          // Writing-app defaults: Material bodyMedium is ~14; bump for prose.
          bodyLarge: TextStyle(
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: palette.onSurface,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w400,
            color: palette.onSurface,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w400,
            color: palette.onSurface.withValues(alpha: 0.85),
          ),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: palette.scaffold,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: palette.scaffold,
        foregroundColor: palette.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: palette.border),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: palette.onAccent,
        ),
      ),
    );
  }
}
