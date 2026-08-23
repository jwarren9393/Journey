import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardShortcutsDialog extends StatelessWidget {
  const KeyboardShortcutsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const KeyboardShortcutsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Keyboard shortcuts'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ShortcutRow(
              label: 'Open settings',
              shortcut: 'Ctrl + ,',
            ),
            _ShortcutRow(
              label: 'Focus mode (editor)',
              shortcut: 'Ctrl + Shift + F',
            ),
            _ShortcutRow(
              label: 'Look up lore (editor)',
              shortcut: 'Ctrl + Shift + L',
            ),
            _ShortcutRow(
              label: 'Story Lab brainstorm (editor)',
              shortcut: 'Ctrl + Shift + B',
            ),
            _ShortcutRow(
              label: 'Exit focus mode',
              shortcut: 'Esc',
            ),
            _ShortcutRow(
              label: 'Show shortcuts',
              shortcut: 'Ctrl + /',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({
    required this.label,
    required this.shortcut,
  });

  final String label;
  final String shortcut;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 16),
          Text(
            shortcut,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

abstract final class AppShortcuts {
  static Map<ShortcutActivator, Intent> get global => {
        const SingleActivator(LogicalKeyboardKey.comma, control: true):
            const OpenSettingsIntent(),
        const SingleActivator(LogicalKeyboardKey.slash, control: true):
            const ShowShortcutsIntent(),
      };
}

class OpenSettingsIntent extends Intent {
  const OpenSettingsIntent();
}

class ShowShortcutsIntent extends Intent {
  const ShowShortcutsIntent();
}
