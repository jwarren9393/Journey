import 'package:journey/features/books/domain/models/chapter_search_result.dart';

abstract interface class BookSearchRepository {
  Future<List<ChapterSearchResult>> searchInBook({
    required String bookId,
    required String query,
  });
}
