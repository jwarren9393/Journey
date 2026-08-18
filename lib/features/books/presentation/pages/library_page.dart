import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/constants/app_constants.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/shared/widgets/empty_state.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/text_input_dialog.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  String? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState.fromError(
          error: error,
          onRetry: () => ref.invalidate(booksStreamProvider),
        ),
        data: (books) {
          final categories = books
              .map((book) => book.category.trim())
              .where((category) => category.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

          final filtered = _categoryFilter == null
              ? books
              : books
                  .where((book) => book.category.trim() == _categoryFilter)
                  .toList();

          if (books.isEmpty) {
            return EmptyState(
              icon: Icons.auto_stories_outlined,
              title: 'No books yet',
              message: 'Create your first book to start writing.',
              action: FilledButton.icon(
                onPressed: () => _createBook(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('New book'),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (categories.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _categoryFilter == null,
                        onSelected: (_) => setState(() => _categoryFilter = null),
                      ),
                      const SizedBox(width: 8),
                      for (final category in categories) ...[
                        FilterChip(
                          label: Text(category),
                          selected: _categoryFilter == category,
                          onSelected: (_) =>
                              setState(() => _categoryFilter = category),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No books in this category.'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final book = filtered[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.menu_book_outlined),
                              title: Text(book.title),
                              subtitle: Text(
                                _subtitleForBook(book),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'delete') {
                                    await _confirmDeleteBook(
                                      context,
                                      ref,
                                      book.id,
                                      book.title,
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
                              onTap: () =>
                                  context.push(AppRoutes.bookDetail(book.id)),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createBook(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New book'),
      ),
    );
  }

  String _subtitleForBook(Book book) {
    if (book.description.isNotEmpty) {
      return book.description;
    }
    if (book.category.isNotEmpty) {
      return book.category;
    }
    return 'Updated ${_formatDate(book.updatedAt)}';
  }

  Future<void> _createBook(BuildContext context, WidgetRef ref) async {
    final title = await showTextInputDialog(
      context: context,
      title: 'New book',
      label: 'Title',
    );
    if (title == null || !context.mounted) {
      return;
    }

    try {
      final book = await ref.books.create(title: title);
      if (!context.mounted) {
        return;
      }
      context.push(AppRoutes.bookDetail(book.id));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _confirmDeleteBook(
    BuildContext context,
    WidgetRef ref,
    String bookId,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete book?'),
        content: Text('"$title" and all its chapters will be permanently deleted.'),
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
      await ref.books.delete(bookId);
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
