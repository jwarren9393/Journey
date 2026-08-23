import 'package:flutter/material.dart';
import 'package:journey/core/theme/appearance_palette.dart';

class AppPreferences {
  const AppPreferences({
    this.themeMode = ThemeMode.system,
    this.backgroundPreset = AppBackgroundPreset.parchment,
    this.accentPreset = AppAccentPreset.gold,
    this.uiFontScale = 1.0,
    this.editorFontSize = 16,
    this.editorLineHeight = 1.6,
    this.onboardingCompleted = false,
  });

  final ThemeMode themeMode;
  final AppBackgroundPreset backgroundPreset;
  final AppAccentPreset accentPreset;

  /// App-wide UI + reading text scale (AI cards, sheets, lists). Editor size is separate.
  final double uiFontScale;
  final double editorFontSize;
  final double editorLineHeight;
  final bool onboardingCompleted;

  static const defaults = AppPreferences();

  static const double minUiFontScale = 0.85;
  static const double maxUiFontScale = 2.0;

  AppPreferences copyWith({
    ThemeMode? themeMode,
    AppBackgroundPreset? backgroundPreset,
    AppAccentPreset? accentPreset,
    double? uiFontScale,
    double? editorFontSize,
    double? editorLineHeight,
    bool? onboardingCompleted,
  }) {
    return AppPreferences(
      themeMode: themeMode ?? this.themeMode,
      backgroundPreset: backgroundPreset ?? this.backgroundPreset,
      accentPreset: accentPreset ?? this.accentPreset,
      uiFontScale: uiFontScale ?? this.uiFontScale,
      editorFontSize: editorFontSize ?? this.editorFontSize,
      editorLineHeight: editorLineHeight ?? this.editorLineHeight,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
