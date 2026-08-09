import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/preferences/app_preferences.dart';
import 'package:journey/core/providers/app_preferences_provider.dart';

class AppearanceSettingsSection extends ConsumerWidget {
  const AppearanceSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(appPreferencesProvider);

    return prefsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Could not load appearance settings: $error'),
      data: (prefs) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Customize how Journey looks and how the editor feels while you write.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.7,
              ),
            ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<ThemeMode>(
            initialValue: prefs.themeMode,
            decoration: const InputDecoration(
              labelText: 'Theme',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                _update(ref, prefs.copyWith(themeMode: value));
              }
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Editor font size: ${prefs.editorFontSize.round()}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Slider(
            value: prefs.editorFontSize,
            min: 14,
            max: 24,
            divisions: 10,
            label: prefs.editorFontSize.round().toString(),
            onChanged: (value) {
              _update(ref, prefs.copyWith(editorFontSize: value));
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Line spacing: ${prefs.editorLineHeight.toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Slider(
            value: prefs.editorLineHeight,
            min: 1.2,
            max: 2.2,
            divisions: 10,
            label: prefs.editorLineHeight.toStringAsFixed(1),
            onChanged: (value) {
              _update(ref, prefs.copyWith(editorLineHeight: value));
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Preview',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'The quick brown fox jumps over the lazy dog.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: prefs.editorFontSize,
                  height: prefs.editorLineHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _update(WidgetRef ref, AppPreferences preferences) {
    ref.read(appPreferencesProvider.notifier).savePreferences(preferences);
  }
}
