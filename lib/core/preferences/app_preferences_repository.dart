import 'package:flutter/material.dart';
import 'package:journey/core/preferences/app_preferences.dart';
import 'package:journey/core/theme/appearance_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesRepository {
  AppPreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _backgroundPresetKey = 'background_preset';
  static const _accentPresetKey = 'accent_preset';
  static const _uiFontScaleKey = 'ui_font_scale';
  static const _editorFontSizeKey = 'editor_font_size';
  static const _editorLineHeightKey = 'editor_line_height';
  static const _onboardingCompletedKey = 'onboarding_completed';

  Future<AppPreferences> load() async {
    final themeIndex = _prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final themeMode = ThemeMode.values.elementAt(
      themeIndex.clamp(0, ThemeMode.values.length - 1),
    );
    final uiFontScale = (_prefs.getDouble(_uiFontScaleKey) ?? 1.0).clamp(
      AppPreferences.minUiFontScale,
      AppPreferences.maxUiFontScale,
    );

    return AppPreferences(
      themeMode: themeMode,
      backgroundPreset: AppBackgroundPreset.fromStorage(
        _prefs.getString(_backgroundPresetKey),
      ),
      accentPreset: AppAccentPreset.fromStorage(
        _prefs.getString(_accentPresetKey),
      ),
      uiFontScale: uiFontScale,
      editorFontSize: _prefs.getDouble(_editorFontSizeKey) ?? 16,
      editorLineHeight: _prefs.getDouble(_editorLineHeightKey) ?? 1.6,
      onboardingCompleted: _prefs.getBool(_onboardingCompletedKey) ?? false,
    );
  }

  Future<void> save(AppPreferences preferences) async {
    await _prefs.setInt(_themeModeKey, preferences.themeMode.index);
    await _prefs.setString(
      _backgroundPresetKey,
      preferences.backgroundPreset.name,
    );
    await _prefs.setString(_accentPresetKey, preferences.accentPreset.name);
    await _prefs.setDouble(_uiFontScaleKey, preferences.uiFontScale);
    await _prefs.setDouble(_editorFontSizeKey, preferences.editorFontSize);
    await _prefs.setDouble(_editorLineHeightKey, preferences.editorLineHeight);
    await _prefs.setBool(
      _onboardingCompletedKey,
      preferences.onboardingCompleted,
    );
  }
}
