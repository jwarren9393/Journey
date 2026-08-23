import 'package:flutter/material.dart';

/// Legacy named colors kept for any direct call sites.
/// Prefer [ResolvedAppearance] / Settings → Appearance presets for UI chrome.
abstract final class AppColors {
  static const Color ink = Color(0xFF1A1A2E);
  static const Color parchment = Color(0xFFF5F0E8);
  static const Color parchmentDark = Color(0xFF2C2C3A);
  static const Color accent = Color(0xFFC9A227);
  static const Color accentMuted = Color(0xFF8B7355);
  static const Color surfaceLight = Color(0xFFFFFBF5);
  static const Color surfaceDark = Color(0xFF1E1E2E);
}
