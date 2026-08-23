import 'package:flutter/material.dart';

/// Comfortable reading style for AI-generated and long-form UI prose.
/// Respects [MediaQuery] text scaler (Settings → Appearance → App text size).
TextStyle appReadingStyle(BuildContext context) {
  final base = Theme.of(context).textTheme.bodyLarge;
  return (base ?? const TextStyle()).copyWith(
    fontSize: base?.fontSize ?? 18,
    height: 1.5,
  );
}
