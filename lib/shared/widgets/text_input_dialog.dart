import 'package:flutter/material.dart';

Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  required String label,
  String? initialValue,
  String confirmLabel = 'Create',
  bool allowEmpty = false,
  int maxLines = 1,
}) {
  final controller = TextEditingController(text: initialValue);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: maxLines,
          decoration: InputDecoration(labelText: label),
          onSubmitted: (_) {
            final value = controller.text.trim();
            if (!allowEmpty && value.isEmpty) {
              return;
            }
            Navigator.of(context).pop(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (!allowEmpty && value.isEmpty) {
                return;
              }
              Navigator.of(context).pop(value);
            },
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
}
