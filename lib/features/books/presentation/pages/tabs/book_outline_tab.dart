import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/ai/ai_outline_actions.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/features/books/presentation/widgets/pacing_chip.dart';
import 'package:journey/shared/widgets/empty_state.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/text_input_dialog.dart';

class BookOutlineTab extends ConsumerStatefulWidget {
  const BookOutlineTab({required this.bookId, super.key});

  final String bookId;

  @override
  ConsumerState<BookOutlineTab> createState() => _BookOutlineTabState();
}

class _BookOutlineTabState extends ConsumerState<BookOutlineTab> {
  Map<String, String> _pacingLabels = {};
  bool _showPacing = false;
  bool _analyzingPacing = false;

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(chaptersStreamProvider(widget.bookId));

    return chaptersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState.fromError(
        error: error,
        onRetry: () => ref.invalidate(chaptersStreamProvider(widget.bookId)),
      ),
      data: (chapters) {
        if (chapters.isEmpty) {
          return const EmptyState(
            icon: Icons.view_list_outlined,
            title: 'No chapters yet',
            message: 'Add chapters first, then plan them here.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _analyzingPacing
                        ? null
                        : () => _analyzePacing(chapters),
                    icon: _analyzingPacing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome_outlined, size: 18),
                    label: const Text('Analyze pacing'),
                  ),
                  if (_pacingLabels.isNotEmpty)
                    FilterChip(
                      label: const Text('Show heatmap'),
                      selected: _showPacing,
                      onSelected: (selected) {
                        setState(() => _showPacing = selected);
                      },
                    ),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chapters.length,
                onReorderItem: (oldIndex, newIndex) =>
                    _onReorder(chapters, oldIndex, newIndex),
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return Card(
                    key: ValueKey(chapter.id),
                    child: ListTile(
                      leading: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                      title: Text(chapter.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_showPacing && _pacingLabels.containsKey(chapter.id))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: PacingChip(
                                label: _pacingLabels[chapter.id]!,
                              ),
                            ),
                          Text(
                            chapter.outlineSummary.trim().isEmpty
                                ? 'Tap to add an outline note'
                                : chapter.outlineSummary,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () => context.push(
                        AppRoutes.editor(widget.bookId, chapter.id),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (AiOutlineActions.canPlotBridge(
                            index,
                            chapters.length,
                          ))
                            IconButton(
                              tooltip: 'Plot bridge ideas',
                              icon: const Icon(Icons.alt_route_outlined),
                              onPressed: () => _runPlotBridge(
                                chapters: chapters,
                                index: index,
                              ),
                            ),
                          IconButton(
                            tooltip: 'Edit outline note',
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _editOutlineSummary(chapter),
                          ),
                        ],
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
  }

  Future<void> _analyzePacing(List<Chapter> chapters) async {
    setState(() => _analyzingPacing = true);

    final book = await ref.books.getById(widget.bookId);
    if (!mounted) {
      return;
    }

    final labels = await AiOutlineActions.runPacingHeatmap(
      context: context,
      ref: ref,
      bookId: widget.bookId,
      chapters: chapters,
      book: book,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _analyzingPacing = false;
      if (labels != null) {
        _pacingLabels = labels;
        _showPacing = true;
      }
    });
  }

  Future<void> _runPlotBridge({
    required List<Chapter> chapters,
    required int index,
  }) async {
    final book = await ref.books.getById(widget.bookId);
    if (!mounted) {
      return;
    }

    await AiOutlineActions.runPlotBridge(
      context: context,
      ref: ref,
      bookId: widget.bookId,
      before: chapters[index - 1],
      target: chapters[index],
      after: chapters[index + 1],
      book: book,
    );
  }

  Future<void> _onReorder(
    List<Chapter> chapters,
    int oldIndex,
    int newIndex,
  ) async {
    final reordered = List<Chapter>.of(chapters);
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);

    try {
      await ref.chapters.reorderChapters(
        bookId: widget.bookId,
        chapterIdsInOrder: reordered.map((chapter) => chapter.id).toList(),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _editOutlineSummary(Chapter chapter) async {
    final summary = await showTextInputDialog(
      context: context,
      title: 'Outline note',
      label: 'What happens in this chapter?',
      initialValue: chapter.outlineSummary,
      confirmLabel: 'Save',
      allowEmpty: true,
      maxLines: 5,
    );
    if (summary == null) {
      return;
    }

    try {
      await ref.chapters.update(chapter.copyWith(outlineSummary: summary));
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }
}
