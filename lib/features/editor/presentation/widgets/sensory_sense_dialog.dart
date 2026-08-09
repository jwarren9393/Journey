import 'package:flutter/material.dart';
import 'package:journey/core/ai/ai_context.dart';

Future<SensorySense?> showSensorySenseDialog(BuildContext context) {
  return showDialog<SensorySense>(
    context: context,
    builder: (context) {
      return const _SensorySenseDialog();
    },
  );
}

class _SensorySenseDialog extends StatefulWidget {
  const _SensorySenseDialog();

  @override
  State<_SensorySenseDialog> createState() => _SensorySenseDialogState();
}

class _SensorySenseDialogState extends State<_SensorySenseDialog> {
  SensorySense _selected = SensorySense.auto;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sensory focus'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Which sense should the rewrite emphasize?'),
          const SizedBox(height: 8),
          for (final entry in _senseOptions)
            ListTile(
              title: Text(entry.$2),
              selected: _selected == entry.$1,
              trailing: _selected == entry.$1
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => setState(() => _selected = entry.$1),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: const Text('Enhance'),
        ),
      ],
    );
  }
}

const _senseOptions = <(SensorySense, String)>[
  (SensorySense.auto, 'Let AI choose'),
  (SensorySense.sight, 'Sight'),
  (SensorySense.sound, 'Sound'),
  (SensorySense.smell, 'Smell'),
  (SensorySense.touch, 'Touch'),
  (SensorySense.taste, 'Taste'),
];
