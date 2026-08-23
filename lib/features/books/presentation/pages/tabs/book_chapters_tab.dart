import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/core/ai/ai_export_actions.dart';
import 'package:journey/features/books/data/services/book_export_service.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/story_lab_draft.dart';
import 'package:journey/features/books/domain/services/book_exporter.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/story_lab_providers.dart';
import 'package:journey/shared/widgets/ai_result_sheet.dart';
import 'package:journey/shared/widgets/book_canon_summary_card.dart';
import 'package:journey/shared/widgets/book_description_card.dart';
import 'package:journey/shared/widgets/book_writing_guide_card.dart';
import 'package:journey/shared/widgets/book_edit_dialog.dart';
import 'package:journey/shared/widgets/empty_state.dart';
import 'package:journey/shared/widgets/error_state.dart';

class BookChaptersTab extends ConsumerWidget {
  const BookChaptersTab({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookProvider(bookId));
    final chaptersAsync = ref.watch(chaptersStreamProvider(bookId));
    final draftAsync = ref.watch(storyLabDraftProvider(bookId));
    final notesAsync = ref.watch(
      notesStreamProvider(NotesQuery(bookId: bookId)),
    );

    return bookAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState.fromError(
        error: error,
        onRetry: () => ref.invalidate(bookProvider(bookId)),
      ),
      data: (book) {
        if (book == null) {
          return const ErrorState(
            message: 'This book could not be found.',
            icon: Icons.menu_book_outlined,
          );
        }

        return chaptersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorState.fromError(
            error: error,
            onRetry: () => ref.invalidate(chaptersStreamProvider(bookId)),
          ),
          data: (chapters) {
            final draft = draftAsync.asData?.value ?? StoryLabDraft.empty;
            final noteCount = notesAsync.asData?.value.length ?? 0;
            final hasPicture = book.description.trim().isNotEmpty ||
                book.canonSummary.trim().isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      BookDescriptionCard(
                        description: book.description,
                        onEdit: () => editBook(context, ref, bookId, book: book),
                      ),
                      const SizedBox(height: 8),
                      BookWritingGuideCard(book: book),
                      const SizedBox(height: 8),
                      BookCanonSummaryCard(book: book, bookId: bookId),
                    ],
                  ),
                ),
                Expanded(
                  child: chapters.isEmpty
                      ? _ChaptersEmptyState(
                          bookId: bookId,
                          draft: draft,
                          hasPicture: hasPicture,
                          noteCount: noteCount,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: chapters.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final chapter = chapters[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${chapter.sortOrder + 1}'),
                                ),
                                title: Text(chapter.title),
                                subtitle: Text(
                                  'Updated ${_formatDate(chapter.updatedAt)}',
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'delete') {
                                      await _confirmDeleteChapter(
                                        context,
                                        ref,
                                        chapter.id,
                                        chapter.title,
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                                onTap: () => context.push(
                                  AppRoutes.editor(bookId, chapter.id),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Future<void> showRecap(
    BuildContext context,
    WidgetRef ref,
    String bookId,
  ) async {
    try {
      final book = await ref.books.getById(bookId);
      if (book == null || !context.mounted) {
        return;
      }

      final chapters = await ref.chapters.watchByBookId(bookId).first;
      if (chapters.isEmpty) {
        if (!context.mounted) {
          return;
        }
        showAppSnackBar(
          context,
          'Add a chapter before requesting a recap.',
        );
        return;
      }

      final latestChapter = chapters.reduce(
        (current, next) =>
            next.updatedAt.isAfter(current.updatedAt) ? next : current,
      );
      final aiContext = AiContext(book: book, chapter: latestChapter);
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.recapBook,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      await showAiResultSheet(
        context: context,
        action: AiAction.recapBook,
        resultFuture: resultFuture,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static Future<void> editBook(
    BuildContext context,
    WidgetRef ref,
    String bookId, {
    Book? book,
  }) async {
    final currentBook = book ?? await ref.books.getById(bookId);
    if (currentBook == null || !context.mounted) {
      return;
    }

    final result = await showBookEditDialog(
      context: context,
      title: currentBook.title,
      description: currentBook.description,
      category: currentBook.category,
    );
    if (result == null) {
      return;
    }

    try {
      await ref.books.update(
        currentBook.copyWith(
          title: result.title,
          description: result.description,
          category: result.category,
        ),
      );
      ref.invalidate(bookProvider(bookId));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static Future<void> exportBook(
    BuildContext context,
    WidgetRef ref,
    String bookId, {
    required bool isMarkdown,
  }) async {
    try {
      final book = await ref.books.getById(bookId);
      if (book == null || !context.mounted) {
        return;
      }

      final chapters = await ref.chapters.watchByBookId(bookId).first;
      final savedPath = await ref.read(bookExportServiceProvider).exportBook(
            book: book,
            chapters: chapters,
            format: isMarkdown
                ? BookExportFormat.markdown
                : BookExportFormat.plainText,
          );

      if (!context.mounted) {
        return;
      }

      final label = isMarkdown ? 'Markdown' : 'plain text';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Exported as $label to $savedPath'),
            action: SnackBarAction(
              label: 'Blurb & pitch',
              onPressed: () => AiExportActions.runBlurbPitchGenerator(
                context: context,
                ref: ref,
                bookId: bookId,
                book: book,
                chapters: chapters,
              ),
            ),
          ),
        );
    } on BookExportException catch (error) {
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(context, error.message);
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _confirmDeleteChapter(
    BuildContext context,
    WidgetRef ref,
    String chapterId,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete chapter?'),
        content: Text('"$title" will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await ref.chapters.delete(chapterId);
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _ChaptersEmptyState extends StatelessWidget {
  const _ChaptersEmptyState({
    required this.bookId,
    required this.draft,
    required this.hasPicture,
    required this.noteCount,
  });

  final String bookId;
  final StoryLabDraft draft;
  final bool hasPicture;
  final int noteCount;

  @override
  Widget build(BuildContext context) {
    final inProgress = draft.hasInProgressWork;
    final String message;
    final String buttonLabel;
    final IconData buttonIcon;

    if (hasPicture || noteCount > 0) {
      message = noteCount > 0
          ? 'You already have lore notes. Open Foundations to keep growing, or add a chapter with the button below.'
          : 'Your picture is saved. Continue growing the world in Foundations, or add a chapter with the button below.';
      buttonLabel = 'Continue Foundations';
      buttonIcon = Icons.auto_awesome;
    } else if (inProgress) {
      message =
          '${draft.foundationsProgressLabel}. Or start writing with New chapter below.';
      buttonLabel = 'Continue Foundations';
      buttonIcon = Icons.auto_awesome;
    } else {
      message =
          'No world yet? Open Foundations to discover one. Ready to write? Use New chapter below.';
      buttonLabel = 'Start from scratch';
      buttonIcon = Icons.auto_awesome;
    }

    return EmptyState(
      icon: Icons.article_outlined,
      title: 'No chapters yet',
      message: message,
      action: FilledButton.icon(
        onPressed: () => context.push(AppRoutes.storyLab(bookId)),
        icon: Icon(buttonIcon),
        label: Text(buttonLabel),
      ),
    );
  }
}
