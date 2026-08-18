import 'package:flutter/material.dart';

class AppPreferences {
  const AppPreferences({
    this.themeMode = ThemeMode.system,
    this.editorFontSize = 16,
    this.editorLineHeight = 1.6,
    this.onboardingCompleted = false,
  });

  final ThemeMode themeMode;
  final double editorFontSize;
  final double editorLineHeight;
  final bool onboardingCompleted;

  static const defaults = AppPreferences();

  AppPreferences copyWith({
    ThemeMode? themeMode,
    double? editorFontSize,
    double? editorLineHeight,
    bool? onboardingCompleted,
  }) {
    return AppPreferences(
      themeMode: themeMode ?? this.themeMode,
      editorFontSize: editorFontSize ?? this.editorFontSize,
      editorLineHeight: editorLineHeight ?? this.editorLineHeight,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
