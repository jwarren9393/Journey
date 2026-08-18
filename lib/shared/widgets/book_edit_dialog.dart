import 'package:flutter/material.dart';

class BookEditResult {
  const BookEditResult({
    required this.title,
    required this.description,
    required this.category,
  });

  final String title;
  final String description;
  final String category;
}

Future<BookEditResult?> showBookEditDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String category,
}) {
  final titleController = TextEditingController(text: title);
  final descriptionController = TextEditingController(text: description);
  final categoryController = TextEditingController(text: category);

  return showDialog<BookEditResult>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit book'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'e.g. Fantasy, Journal, Fanfic',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'A sentence or two about this book...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                minLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final nextTitle = titleController.text.trim();
              if (nextTitle.isEmpty) {
                return;
              }
              Navigator.of(context).pop(
                BookEditResult(
                  title: nextTitle,
                  description: descriptionController.text.trim(),
                  category: categoryController.text.trim(),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
