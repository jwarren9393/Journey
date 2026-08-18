import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/text_input_dialog.dart';

class BookWritingGuideCard extends ConsumerWidget {
  const BookWritingGuideCard({
    required this.book,
    super.key,
  });

  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasNote = book.authorsNote.trim().isNotEmpty;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editAuthorsNote(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.edit_note_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Author's note",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasNote
                          ? book.authorsNote
                          : 'Optional style guide for AI (POV, tense, tone). Only used when you run AI actions.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: hasNote
                                ? null
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                            fontStyle: hasNote
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: "Edit author's note",
                onPressed: () => _editAuthorsNote(context, ref),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editAuthorsNote(BuildContext context, WidgetRef ref) async {
    final text = await showTextInputDialog(
      context: context,
      title: "Author's note",
      label: 'Style guide (POV, tense, tone)',
      initialValue: book.authorsNote,
      confirmLabel: 'Save',
      maxLines: 6,
      allowEmpty: true,
    );
    if (text == null) {
      return;
    }

    try {
      await ref.books.update(book.copyWith(authorsNote: text));
      ref.invalidate(bookProvider(book.id));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }
}
