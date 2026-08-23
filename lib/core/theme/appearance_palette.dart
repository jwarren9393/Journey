import 'package:flutter/material.dart';

/// App-wide background families. Each resolves differently for light vs dark.
enum AppBackgroundPreset {
  parchment,
  ink,
  slate,
  crimson,
  forest;

  String get label => switch (this) {
        AppBackgroundPreset.parchment => 'Parchment',
        AppBackgroundPreset.ink => 'Ink',
        AppBackgroundPreset.slate => 'Slate',
        AppBackgroundPreset.crimson => 'Crimson',
        AppBackgroundPreset.forest => 'Forest',
      };

  /// Swatch shown in settings (dark-mode tone of this family).
  Color get swatch => switch (this) {
        AppBackgroundPreset.parchment => const Color(0xFF2C2C3A),
        AppBackgroundPreset.ink => const Color(0xFF0A0A0A),
        AppBackgroundPreset.slate => const Color(0xFF1A2332),
        AppBackgroundPreset.crimson => const Color(0xFF3B0A12),
        AppBackgroundPreset.forest => const Color(0xFF0A1810),
      };

  static AppBackgroundPreset fromStorage(String? raw) {
    return AppBackgroundPreset.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => AppBackgroundPreset.parchment,
    );
  }
}

/// Highlight / accent colors used for FABs, primary actions, and seeds.
enum AppAccentPreset {
  gold,
  yellow,
  red,
  amber,
  cyan,
  lime,
  white;

  String get label => switch (this) {
        AppAccentPreset.gold => 'Gold',
        AppAccentPreset.yellow => 'Yellow',
        AppAccentPreset.red => 'Red',
        AppAccentPreset.amber => 'Amber',
        AppAccentPreset.cyan => 'Cyan',
        AppAccentPreset.lime => 'Lime',
        AppAccentPreset.white => 'White',
      };

  Color get swatch => switch (this) {
        AppAccentPreset.gold => const Color(0xFFC9A227),
        AppAccentPreset.yellow => const Color(0xFFF5D000),
        AppAccentPreset.red => const Color(0xFFE53935),
        AppAccentPreset.amber => const Color(0xFFFF8F00),
        AppAccentPreset.cyan => const Color(0xFF00BCD4),
        AppAccentPreset.lime => const Color(0xFFC6FF00),
        AppAccentPreset.white => const Color(0xFFF5F5F5),
      };

  Color get onAccent => switch (this) {
        AppAccentPreset.gold => const Color(0xFF1A1A2E),
        AppAccentPreset.yellow => const Color(0xFF0A0A0A),
        AppAccentPreset.red => const Color(0xFFFFFFFF),
        AppAccentPreset.amber => const Color(0xFF0A0A0A),
        AppAccentPreset.cyan => const Color(0xFF00363A),
        AppAccentPreset.lime => const Color(0xFF0A0A0A),
        AppAccentPreset.white => const Color(0xFF0A0A0A),
      };

  static AppAccentPreset fromStorage(String? raw) {
    return AppAccentPreset.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => AppAccentPreset.gold,
    );
  }
}

/// Resolved colors for one brightness + background + accent combination.
class ResolvedAppearance {
  const ResolvedAppearance({
    required this.scaffold,
    required this.surface,
    required this.onSurface,
    required this.accent,
    required this.onAccent,
    required this.border,
  });

  final Color scaffold;
  final Color surface;
  final Color onSurface;
  final Color accent;
  final Color onAccent;
  final Color border;

  static ResolvedAppearance resolve({
    required AppBackgroundPreset background,
    required AppAccentPreset accent,
    required Brightness brightness,
  }) {
    final isLight = brightness == Brightness.light;
    final surfaces = _surfaces(background, isLight);
    return ResolvedAppearance(
      scaffold: surfaces.$1,
      surface: surfaces.$2,
      onSurface: surfaces.$3,
      accent: accent.swatch,
      onAccent: accent.onAccent,
      border: accent.swatch.withValues(alpha: isLight ? 0.35 : 0.45),
    );
  }

  /// scaffold, surface, onSurface
  static (Color, Color, Color) _surfaces(
    AppBackgroundPreset background,
    bool isLight,
  ) {
    return switch (background) {
      AppBackgroundPreset.parchment => isLight
          ? (
              const Color(0xFFF5F0E8),
              const Color(0xFFFFFBF5),
              const Color(0xFF1A1A2E),
            )
          : (
              const Color(0xFF2C2C3A),
              const Color(0xFF1E1E2E),
              const Color(0xFFF5F0E8),
            ),
      AppBackgroundPreset.ink => isLight
          ? (
              const Color(0xFFF2F2F0),
              const Color(0xFFFFFFFF),
              const Color(0xFF0A0A0A),
            )
          : (
              const Color(0xFF0A0A0A),
              const Color(0xFF161616),
              const Color(0xFFF2F2F0),
            ),
      AppBackgroundPreset.slate => isLight
          ? (
              const Color(0xFFE8EEF4),
              const Color(0xFFF4F7FA),
              const Color(0xFF0F172A),
            )
          : (
              const Color(0xFF1A2332),
              const Color(0xFF121820),
              const Color(0xFFE8EEF4),
            ),
      AppBackgroundPreset.crimson => isLight
          ? (
              const Color(0xFFF8EDEB),
              const Color(0xFFFFF8F6),
              const Color(0xFF2A0A0C),
            )
          : (
              const Color(0xFF1A080A),
              const Color(0xFF120507),
              const Color(0xFFF8EDEB),
            ),
      AppBackgroundPreset.forest => isLight
          ? (
              const Color(0xFFEAF0EA),
              const Color(0xFFF5F9F5),
              const Color(0xFF0C1A12),
            )
          : (
              const Color(0xFF0A1410),
              const Color(0xFF07100C),
              const Color(0xFFEAF0EA),
            ),
    };
  }
}
