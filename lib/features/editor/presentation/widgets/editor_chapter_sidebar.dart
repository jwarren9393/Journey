import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';

class EditorChapterSidebar extends ConsumerWidget {
  const EditorChapterSidebar({
    required this.bookId,
    required this.currentChapterId,
    super.key,
  });

  final String bookId;
  final String currentChapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersStreamProvider(bookId));

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: chaptersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Could not load chapters'),
        ),
        data: (chapters) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Chapters',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    final selected = chapter.id == currentChapterId;

                    return ListTile(
                      selected: selected,
                      title: Text(
                        chapter.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: selected
                          ? null
                          : () => context.go(
                                AppRoutes.editor(bookId, chapter.id),
                              ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
