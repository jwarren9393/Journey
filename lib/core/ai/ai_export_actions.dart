import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/shared/widgets/ai_result_sheet.dart';
import 'package:journey/shared/widgets/error_state.dart';

abstract final class AiExportActions {
  static Future<void> runBlurbPitchGenerator({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    Book? book,
    List<Chapter>? chapters,
  }) async {
    try {
      final resolvedBook = book ?? await ref.books.getById(bookId);
      if (resolvedBook == null || !context.mounted) {
        return;
      }

      final resolvedChapters = chapters ??
          await ref.chapters.watchByBookId(bookId).first;

      if (resolvedChapters.isEmpty) {
        if (context.mounted) {
          showAppSnackBar(
            context,
            'Add at least one chapter before generating a pitch.',
          );
        }
        return;
      }

      final aiContext = AiContext(
        book: resolvedBook,
        recentChapters: resolvedChapters,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.blurbPitchGenerator,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      await showAiResultSheet(
        context: context,
        action: AiAction.blurbPitchGenerator,
        resultFuture: resultFuture,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }
}
