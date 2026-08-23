import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/preferences/app_preferences.dart';
import 'package:journey/core/providers/app_preferences_provider.dart';
import 'package:journey/core/theme/appearance_palette.dart';

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
            'Customize how Journey looks app-wide, plus how the editor feels while you write.',
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
          const SizedBox(height: 28),
          Text(
            'Background',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Scaffold and card surfaces. Glass-style cards stay; only the color shifts.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.65,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PresetSwatchRow<AppBackgroundPreset>(
            values: AppBackgroundPreset.values,
            selected: prefs.backgroundPreset,
            labelOf: (value) => value.label,
            colorOf: (value) => value.swatch,
            onSelected: (value) {
              _update(ref, prefs.copyWith(backgroundPreset: value));
            },
          ),
          const SizedBox(height: 28),
          Text(
            'Highlight',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Buttons, FABs, and primary accents — pick something that pops.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.65,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PresetSwatchRow<AppAccentPreset>(
            values: AppAccentPreset.values,
            selected: prefs.accentPreset,
            labelOf: (value) => value.label,
            colorOf: (value) => value.swatch,
            onSelected: (value) {
              _update(ref, prefs.copyWith(accentPreset: value));
            },
          ),
          const SizedBox(height: 28),
          Text(
            'App text size: ${(prefs.uiFontScale * 100).round()}%',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            'Scales menus, lists, and AI reading text (sparks, results, brainstorm).',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.65,
              ),
            ),
          ),
          Slider(
            value: prefs.uiFontScale,
            min: AppPreferences.minUiFontScale,
            max: AppPreferences.maxUiFontScale,
            divisions: 23,
            label: '${(prefs.uiFontScale * 100).round()}%',
            onChanged: (value) {
              _update(ref, prefs.copyWith(uiFontScale: value));
            },
          ),
          const SizedBox(height: 8),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI reading sample at ${(prefs.uiFontScale * 100).round()}%',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A city that forgets its own name each dawn, and the people who stay to remember it.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Editor: The quick brown fox jumps over the lazy dog.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: prefs.editorFontSize,
                      height: prefs.editorLineHeight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Highlight sample'),
                  ),
                ],
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

class _PresetSwatchRow<T> extends StatelessWidget {
  const _PresetSwatchRow({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.colorOf,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final Color Function(T) colorOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final value in values)
          _SwatchChip(
            label: labelOf(value),
            color: colorOf(value),
            selected: value == selected,
            onTap: () => onSelected(value),
          ),
      ],
    );
  }
}

class _SwatchChip extends StatelessWidget {
  const _SwatchChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: selected ? 3 : 1),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.45),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: selected
                ? Icon(
                    Icons.check,
                    size: 20,
                    color: _contrastOn(color),
                  )
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _contrastOn(Color background) {
    return background.computeLuminance() > 0.45
        ? Colors.black
        : Colors.white;
  }
}
