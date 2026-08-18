import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/search_providers.dart';

class BookSearchPage extends ConsumerStatefulWidget {
  const BookSearchPage({required this.bookId, super.key});

  final String bookId;

  @override
  ConsumerState<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends ConsumerState<BookSearchPage> {
  final _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookAsync = ref.watch(bookProvider(widget.bookId));
    final resultsAsync = _query.trim().isEmpty
        ? null
        : ref.watch(
            bookSearchProvider(
              BookSearchRequest(bookId: widget.bookId, query: _query),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: bookAsync.when(
          data: (book) => Text('Search · ${book?.title ?? 'Book'}'),
          loading: () => const Text('Search'),
          error: (_, _) => const Text('Search'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _queryController,
              hintText: 'Search chapters in this book...',
              leading: const Icon(Icons.search),
              trailing: _query.isEmpty
                  ? null
                  : [
                      IconButton(
                        tooltip: 'Clear',
                        onPressed: () {
                          _queryController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
              onChanged: (value) => setState(() => _query = value),
              onSubmitted: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? const Center(
                    child: Text('Type to search chapter titles and text.'),
                  )
                : resultsAsync!.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('$error')),
                    data: (results) {
                      if (results.isEmpty) {
                        return const Center(
                          child: Text('No matches in this book.'),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return Card(
                            child: ListTile(
                              title: Text(result.chapter.title),
                              subtitle: Text(
                                result.matchedInContent
                                    ? result.snippet
                                    : 'Matched in chapter title',
                              ),
                              isThreeLine: result.matchedInContent,
                              onTap: () => context.push(
                                AppRoutes.editor(
                                  widget.bookId,
                                  result.chapter.id,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
