import 'package:flutter/material.dart';
import 'package:journey/core/preferences/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesRepository {
  AppPreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _editorFontSizeKey = 'editor_font_size';
  static const _editorLineHeightKey = 'editor_line_height';
  static const _onboardingCompletedKey = 'onboarding_completed';

  Future<AppPreferences> load() async {
    final themeIndex = _prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final themeMode = ThemeMode.values.elementAt(
      themeIndex.clamp(0, ThemeMode.values.length - 1),
    );

    return AppPreferences(
      themeMode: themeMode,
      editorFontSize: _prefs.getDouble(_editorFontSizeKey) ?? 16,
      editorLineHeight: _prefs.getDouble(_editorLineHeightKey) ?? 1.6,
      onboardingCompleted: _prefs.getBool(_onboardingCompletedKey) ?? false,
    );
  }

  Future<void> save(AppPreferences preferences) async {
    await _prefs.setInt(_themeModeKey, preferences.themeMode.index);
    await _prefs.setDouble(_editorFontSizeKey, preferences.editorFontSize);
    await _prefs.setDouble(_editorLineHeightKey, preferences.editorLineHeight);
    await _prefs.setBool(
      _onboardingCompletedKey,
      preferences.onboardingCompleted,
    );
  }
}
