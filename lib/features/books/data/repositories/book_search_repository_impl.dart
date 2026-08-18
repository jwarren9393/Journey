import 'package:journey/features/books/domain/models/chapter_search_result.dart';
import 'package:journey/features/books/domain/repositories/book_search_repository.dart';
import 'package:journey/features/books/domain/repositories/chapter_repository.dart';

class BookSearchRepositoryImpl implements BookSearchRepository {
  BookSearchRepositoryImpl(this._chapterRepository);

  final ChapterRepository _chapterRepository;

  @override
  Future<List<ChapterSearchResult>> searchInBook({
    required String bookId,
    required String query,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return [];
    }

    final chapters = await _chapterRepository.watchByBookId(bookId).first;
    final lowerQuery = trimmed.toLowerCase();
    final results = <ChapterSearchResult>[];

    for (final chapter in chapters) {
      final titleMatch = chapter.title.toLowerCase().contains(lowerQuery);
      final contentMatch = chapter.content.toLowerCase().contains(lowerQuery);

      if (!titleMatch && !contentMatch) {
        continue;
      }

      results.add(
        ChapterSearchResult(
          chapter: chapter,
          snippet: contentMatch
              ? _extractSnippet(chapter.content, trimmed)
              : chapter.title,
          matchedInTitle: titleMatch,
          matchedInContent: contentMatch,
        ),
      );
    }

    return results;
  }

  String _extractSnippet(String content, String query) {
    final lowerContent = content.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerContent.indexOf(lowerQuery);

    if (index < 0) {
      return '';
    }

    const radius = 48;
    final start = index > radius ? index - radius : 0;
    final end = index + query.length + radius;
    final endClamped = end > content.length ? content.length : end;

    var snippet = content.substring(start, endClamped).replaceAll('\n', ' ').trim();
    if (start > 0) {
      snippet = '…$snippet';
    }
    if (endClamped < content.length) {
      snippet = '$snippet…';
    }

    return snippet;
  }
}
