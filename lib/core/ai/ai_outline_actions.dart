import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/shared/widgets/ai_result_sheet.dart';
import 'package:journey/shared/widgets/error_state.dart';

abstract final class AiOutlineActions {
  static Future<Map<String, String>?> runPacingHeatmap({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required List<Chapter> chapters,
    Book? book,
  }) async {
    if (chapters.isEmpty) {
      return null;
    }

    try {
      final aiContext = AiContext(
        book: book,
        recentChapters: chapters,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final result = await runner.run(
        action: AiAction.pacingHeatmap,
        context: aiContext,
      );

      if (result.pacingLabels.isEmpty) {
        if (context.mounted) {
          showAppSnackBar(
            context,
            'Could not read pacing labels. Try again.',
          );
        }
        return null;
      }

      return result.pacingLabels;
    } catch (error) {
      if (context.mounted) {
        showErrorSnackBar(context, error);
      }
      return null;
    }
  }

  static Future<void> runPlotBridge({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required Chapter before,
    required Chapter target,
    required Chapter after,
    Book? book,
  }) async {
    try {
      final aiContext = AiContext(
        book: book,
        plotBridgeBefore: before,
        plotBridgeTarget: target,
        plotBridgeAfter: after,
      );
      final runner = ref.read(aiActionRunnerProvider);
      final resultFuture = runner.run(
        action: AiAction.plotBridge,
        context: aiContext,
      );

      if (!context.mounted) {
        return;
      }

      await showAiResultSheet(
        context: context,
        action: AiAction.plotBridge,
        resultFuture: resultFuture,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  static bool canPlotBridge(int index, int chapterCount) {
    return index >= 1 && index < chapterCount - 1;
  }
}
