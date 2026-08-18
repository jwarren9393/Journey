import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/ai_context_builder.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/editor/presentation/widgets/ask_world_bible_dialog.dart';
import 'package:journey/shared/widgets/ai_result_sheet.dart';
import 'package:journey/shared/widgets/continuity_fix_sheet.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/extract_entities_sheet.dart';

abstract final class AiBookActions {
  static Future<List<BookNote>> _loadNotes(WidgetRef ref, String bookId) {
    return ref.read(
      notesStreamProvider(NotesQuery(bookId: bookId)).future,
    );
  }

  static void _showLoreTriggeredSnackBar(
    BuildContext context,
    List<String> titles,
  ) {
    if (titles.isEmpty || !context.mounted) {
      return;
    }

    final preview = titles.take(3).join(', ');
    final suffix = titles.length > 3 ? ' (+${titles.length - 3} more)' : '';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Lore included: $preview$suffix'),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  static Future<void> runContinuityCheck({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required Chapter chapter,
    Book? book,
  }) async {
    try {
      final notes = await _loadNotes(ref, bookId);
      final aiContext = AiContextBuilder.forContinuity(
        book: book,
        chapter: chapter,
        allNotes: notes,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.continuityCheck,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      _showLoreTriggeredSnackBar(context, aiContext.triggeredNoteTitles);

      await showAiResultSheet(
        context: context,
        action: AiAction.continuityCheck,
        resultFuture: resultFuture,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static Future<void> runFixContinuity({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required Chapter chapter,
    Book? book,
  }) async {
    try {
      final notes = await _loadNotes(ref, bookId);
      final aiContext = AiContextBuilder.forContinuity(
        book: book,
        chapter: chapter,
        allNotes: notes,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.fixContinuity,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      _showLoreTriggeredSnackBar(context, aiContext.triggeredNoteTitles);

      await showContinuityFixSheet(
        context: context,
        bookId: bookId,
        resultFuture: resultFuture,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static Future<void> runAskWorldBible({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    Chapter? chapter,
    Book? book,
  }) async {
    final question = await showAskWorldBibleDialog(context);
    if (question == null || !context.mounted) {
      return;
    }

    try {
      final notes = await _loadNotes(ref, bookId);
      final aiContext = AiContextBuilder.forWorldBible(
        book: book,
        question: question,
        allNotes: notes,
        chapter: chapter,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.askWorldBible,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      _showLoreTriggeredSnackBar(context, aiContext.triggeredNoteTitles);

      await showAiResultSheet(
        context: context,
        action: AiAction.askWorldBible,
        resultFuture: resultFuture,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static Future<void> runExtractEntities({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required List<Chapter> chapters,
    Book? book,
  }) async {
    final chaptersWithText = chapters
        .where((chapter) => chapter.content.trim().isNotEmpty)
        .toList();
    if (chaptersWithText.isEmpty) {
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(
        context,
        'Add some manuscript text before discovering entities.',
      );
      return;
    }

    try {
      final notes = await _loadNotes(ref, bookId);
      final aiContext = AiContext(
        book: book,
        notes: notes,
        recentChapters: chaptersWithText,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.extractEntities,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      await showExtractEntitiesSheet(
        context: context,
        bookId: bookId,
        resultFuture: resultFuture,
        onNoteCreated: (noteId) {
          if (context.mounted) {
            context.push(AppRoutes.noteEditor(bookId, noteId));
          }
        },
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static Future<void> runUpdateCanonSummary({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    Chapter? focusChapter,
  }) async {
    try {
      final book = await ref.books.getById(bookId);
      if (book == null || !context.mounted) {
        return;
      }

      final chapters = await ref.read(
        chaptersStreamProvider(bookId).future,
      );
      final chaptersWithText = chapters
          .where((chapter) => chapter.content.trim().isNotEmpty)
          .toList();

      if (chaptersWithText.isEmpty) {
        if (!context.mounted) {
          return;
        }
        showAppSnackBar(
          context,
          'Add manuscript text before updating the canon summary.',
        );
        return;
      }

      final aiContext = AiContextBuilder.forCanonUpdate(
        book: book,
        chapters: focusChapter != null ? [focusChapter] : chaptersWithText,
        focusChapter: focusChapter,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.updateCanonSummary,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      await showAiResultSheet(
        context: context,
        action: AiAction.updateCanonSummary,
        resultFuture: resultFuture,
        replaceLabel: 'Save canon summary',
        onReplace: (text) async {
          await ref.books.update(book.copyWith(canonSummary: text));
          ref.invalidate(bookProvider(bookId));
        },
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static List<Chapter> recentChapters(
    List<Chapter> chapters, {
    int count = 3,
    String? excludeChapterId,
  }) {
    final filtered = excludeChapterId == null
        ? chapters
        : chapters.where((chapter) => chapter.id != excludeChapterId).toList();

    final sorted = [...filtered]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return sorted.take(count).toList();
  }
}
