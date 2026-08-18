import 'package:journey/features/books/domain/models/chapter.dart';

class ChapterSearchResult {
  const ChapterSearchResult({
    required this.chapter,
    required this.snippet,
    required this.matchedInTitle,
    required this.matchedInContent,
  });

  final Chapter chapter;
  final String snippet;
  final bool matchedInTitle;
  final bool matchedInContent;
}
