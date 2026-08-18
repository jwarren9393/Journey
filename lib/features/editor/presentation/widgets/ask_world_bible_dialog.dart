import 'package:flutter/material.dart';

Future<String?> showAskWorldBibleDialog(BuildContext context) {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ask the world bible'),
        content: SizedBox(
          width: 420,
          child: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Your question',
              hintText: 'What was the name of John\'s sword?',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(context, controller),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _submit(context, controller),
            child: const Text('Ask'),
          ),
        ],
      );
    },
  );
}

void _submit(BuildContext context, TextEditingController controller) {
  final question = controller.text.trim();
  if (question.isEmpty) {
    return;
  }
  Navigator.of(context).pop(question);
}
