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
import 'package:journey/features/books/domain/models/canon_pin.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/canon_pin_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/note_relationship_providers.dart';
import 'package:journey/features/books/presentation/providers/story_lab_providers.dart';
import 'package:journey/features/editor/presentation/widgets/ask_world_bible_dialog.dart';
import 'package:journey/shared/widgets/ai_result_sheet.dart';
import 'package:journey/shared/widgets/continuity_fix_sheet.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/extract_entities_sheet.dart';
import 'package:journey/shared/widgets/lore_proposal_sheet.dart';
import 'package:journey/shared/widgets/text_input_dialog.dart';

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

  static Future<bool> runPromoteToLore({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    Book? book,
    List<StoryLabMessage>? messages,
    List<CanonPin>? canonPins,
    Chapter? chapter,
    String? selectedText,
    String? userPrompt,
    String sheetTitle = 'Promote to lore',
    String sheetSubtitle =
        'Review creates, updates, and retires before anything changes.',
  }) async {
    try {
      final resolvedBook = book ?? await ref.books.getById(bookId);
      if (resolvedBook == null || !context.mounted) {
        return false;
      }

      final notes = await _loadNotes(ref, bookId);
      final List<StoryLabMessage> resolvedMessages = messages ??
          await ref.read(storyLabMessagesStreamProvider(bookId).future);
      final List<CanonPin> resolvedPins = canonPins ??
          await ref.read(canonPinsStreamProvider(bookId).future);

      final hasBrainstorm = resolvedMessages.isNotEmpty ||
          resolvedBook.storyLabSummary.trim().isNotEmpty ||
          resolvedPins.isNotEmpty;
      final hasChapter = chapter != null &&
          (chapter.content.trim().isNotEmpty ||
              (selectedText?.trim().isNotEmpty ?? false));

      if (!hasBrainstorm && !hasChapter) {
        if (!context.mounted) {
          return false;
        }
        showAppSnackBar(
          context,
          'Add brainstorm messages or chapter text before promoting to lore.',
        );
        return false;
      }

      final aiContext = AiContextBuilder.forPromoteToLore(
        book: resolvedBook,
        allNotes: notes,
        messages: resolvedMessages,
        canonPins: resolvedPins,
        relationships: await ref
            .read(noteRelationshipsByBookProvider(bookId).future),
        chapter: chapter,
        selectedText: selectedText,
        userPrompt: userPrompt,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.promoteToLore,
        context: aiContext,
      );

      if (!context.mounted) {
        return false;
      }

      _showLoreTriggeredSnackBar(context, aiContext.triggeredNoteTitles);

      return await showLoreProposalSheet(
        context: context,
        bookId: bookId,
        resultFuture: resultFuture,
        title: sheetTitle,
        subtitle: sheetSubtitle,
      );
    } catch (error) {
      if (!context.mounted) {
        return false;
      }
      showErrorSnackBar(context, error);
      return false;
    }
  }

  static Future<bool> runDeepenNote({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required BookNote note,
    Book? book,
  }) async {
    final focus = await showTextInputDialog(
      context: context,
      title: 'Deepen note',
      label: 'What should we develop? (optional)',
      confirmLabel: 'Deepen',
      allowEmpty: true,
      maxLines: 3,
    );
    if (focus == null || !context.mounted) {
      return false;
    }

    try {
      final resolvedBook = book ?? await ref.books.getById(bookId);
      if (resolvedBook == null || !context.mounted) {
        return false;
      }

      final notes = await _loadNotes(ref, bookId);
      final relationships =
          await ref.read(noteRelationshipsByBookProvider(bookId).future);
      final aiContext = AiContextBuilder.forDeepenNote(
        book: resolvedBook,
        focusNote: note,
        allNotes: notes,
        relationships: relationships,
        userPrompt: focus.trim().isEmpty ? null : focus.trim(),
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.deepenNote,
        context: aiContext,
      );

      if (!context.mounted) {
        return false;
      }

      _showLoreTriggeredSnackBar(context, aiContext.triggeredNoteTitles);

      return await showLoreProposalSheet(
        context: context,
        bookId: bookId,
        resultFuture: resultFuture,
        title: 'Deepen note',
        subtitle:
            'Review proposed updates (and any related creates/retires) before applying.',
      );
    } catch (error) {
      if (!context.mounted) {
        return false;
      }
      showErrorSnackBar(context, error);
      return false;
    }
  }

  static Future<void> runInterrogateLore({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required BookNote note,
    Book? book,
  }) async {
    try {
      final resolvedBook = book ?? await ref.books.getById(bookId);
      if (resolvedBook == null || !context.mounted) {
        return;
      }

      final notes = await _loadNotes(ref, bookId);
      final relationships =
          await ref.read(noteRelationshipsByBookProvider(bookId).future);
      final aiContext = AiContextBuilder.forInterrogateLore(
        book: resolvedBook,
        focusNote: note,
        allNotes: notes,
        relationships: relationships,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.interrogateLore,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      await showAiResultSheet(
        context: context,
        action: AiAction.interrogateLore,
        resultFuture: resultFuture,
        replaceLabel: 'Append questions to note',
        onReplace: (text) async {
          final latest = await ref.read(noteRepositoryProvider).getById(note.id);
          if (latest == null) {
            return;
          }
          final appendix = '\n\n## Developmental questions\n$text';
          await ref.read(noteRepositoryProvider).update(
                latest.copyWith(content: '${latest.content.trimRight()}$appendix'),
              );
          ref.invalidate(noteProvider(note.id));
        },
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static Future<bool> runEvolveWorldState({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required Chapter chapter,
    Book? book,
  }) async {
    try {
      final resolvedBook = book ?? await ref.books.getById(bookId);
      if (resolvedBook == null || !context.mounted) {
        return false;
      }

      if (chapter.content.trim().isEmpty) {
        showAppSnackBar(
          context,
          'Add chapter text before updating world state.',
        );
        return false;
      }

      final notes = await _loadNotes(ref, bookId);
      final relationships =
          await ref.read(noteRelationshipsByBookProvider(bookId).future);
      final aiContext = AiContextBuilder.forEvolveWorldState(
        book: resolvedBook,
        chapter: chapter,
        allNotes: notes,
        relationships: relationships,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.evolveWorldState,
        context: aiContext,
      );

      if (!context.mounted) {
        return false;
      }

      _showLoreTriggeredSnackBar(context, aiContext.triggeredNoteTitles);

      return await showLoreProposalSheet(
        context: context,
        bookId: bookId,
        resultFuture: resultFuture,
        title: 'Update world state',
        subtitle:
            'Review note and relationship changes implied by this chapter before applying.',
      );
    } catch (error) {
      if (!context.mounted) {
        return false;
      }
      showErrorSnackBar(context, error);
      return false;
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
