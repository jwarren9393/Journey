import 'package:flutter/material.dart';

class BookDescriptionCard extends StatelessWidget {
  const BookDescriptionCard({
    required this.description,
    required this.onEdit,
    super.key,
  });

  final String description;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final hasDescription = description.trim().isNotEmpty;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About this book',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hasDescription
                          ? description
                          : 'Add a description to capture the premise or notes for this project.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: hasDescription
                            ? null
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                        fontStyle:
                            hasDescription ? FontStyle.normal : FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit book',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
