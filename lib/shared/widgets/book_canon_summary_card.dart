import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_book_actions.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/text_input_dialog.dart';

class BookCanonSummaryCard extends ConsumerWidget {
  const BookCanonSummaryCard({
    required this.book,
    required this.bookId,
    this.focusChapter,
    super.key,
  });

  final Book book;
  final String bookId;
  final Chapter? focusChapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSummary = book.canonSummary.trim().isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fact_check_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Canon summary',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Edit canon summary',
                  onPressed: () => _editCanonSummary(context, ref),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              hasSummary
                  ? book.canonSummary
                  : 'Running facts about your story. Edit manually or use AI to fold in chapters — only when you ask.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: hasSummary
                        ? null
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                    fontStyle:
                        hasSummary ? FontStyle.normal : FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: () => AiBookActions.runUpdateCanonSummary(
                  context: context,
                  ref: ref,
                  bookId: bookId,
                  focusChapter: focusChapter,
                ),
                icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                label: Text(
                  focusChapter == null
                      ? 'AI: Update from book'
                      : 'AI: Update from chapter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editCanonSummary(BuildContext context, WidgetRef ref) async {
    final text = await showTextInputDialog(
      context: context,
      title: 'Canon summary',
      label: 'Established facts (bullet points work well)',
      initialValue: book.canonSummary,
      confirmLabel: 'Save',
      maxLines: 8,
      allowEmpty: true,
    );
    if (text == null) {
      return;
    }

    try {
      await ref.books.update(book.copyWith(canonSummary: text));
      ref.invalidate(bookProvider(bookId));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }
}
