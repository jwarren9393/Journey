import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journey/core/theme/appearance_palette.dart';
import 'package:journey/core/theme/app_theme.dart';

void main() {
  test('background and accent presets round-trip from storage names', () {
    expect(
      AppBackgroundPreset.fromStorage('crimson'),
      AppBackgroundPreset.crimson,
    );
    expect(
      AppBackgroundPreset.fromStorage('nope'),
      AppBackgroundPreset.parchment,
    );
    expect(AppAccentPreset.fromStorage('yellow'), AppAccentPreset.yellow);
    expect(AppAccentPreset.fromStorage(null), AppAccentPreset.gold);
  });

  test('ink + yellow dark palette stays high-contrast', () {
    final palette = ResolvedAppearance.resolve(
      background: AppBackgroundPreset.ink,
      accent: AppAccentPreset.yellow,
      brightness: Brightness.dark,
    );

    expect(palette.scaffold.computeLuminance(), lessThan(0.1));
    expect(palette.accent.computeLuminance(), greaterThan(0.5));
    expect(palette.onSurface.computeLuminance(), greaterThan(0.7));
  });

  test('AppTheme builds with custom presets', () {
    final theme = AppTheme.dark(
      background: AppBackgroundPreset.crimson,
      accent: AppAccentPreset.lime,
    );
    expect(theme.scaffoldBackgroundColor, isNotNull);
    expect(theme.colorScheme.primary, AppAccentPreset.lime.swatch);
    expect(
      theme.floatingActionButtonTheme.foregroundColor,
      AppAccentPreset.lime.onAccent,
    );
  });
}
