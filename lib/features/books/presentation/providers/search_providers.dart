import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/data/repositories/book_search_repository_impl.dart';
import 'package:journey/features/books/domain/models/chapter_search_result.dart';
import 'package:journey/features/books/domain/repositories/book_search_repository.dart';

final bookSearchRepositoryProvider = Provider<BookSearchRepository>((ref) {
  return BookSearchRepositoryImpl(ref.watch(chapterRepositoryProvider));
});

final bookSearchProvider =
    FutureProvider.family<List<ChapterSearchResult>, BookSearchRequest>(
  (ref, request) {
    return ref.watch(bookSearchRepositoryProvider).searchInBook(
          bookId: request.bookId,
          query: request.query,
        );
  },
);

class BookSearchRequest {
  const BookSearchRequest({
    required this.bookId,
    required this.query,
  });

  final String bookId;
  final String query;

  @override
  bool operator ==(Object other) {
    return other is BookSearchRequest &&
        other.bookId == bookId &&
        other.query == query;
  }

  @override
  int get hashCode => Object.hash(bookId, query);
}
