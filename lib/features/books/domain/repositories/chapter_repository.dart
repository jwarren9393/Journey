import 'package:journey/features/books/domain/models/chapter.dart';

abstract interface class ChapterRepository {
  Stream<List<Chapter>> watchByBookId(String bookId);

  Future<Chapter?> getById(String id);

  Future<Chapter> create({
    required String bookId,
    required String title,
    String content = '',
  });

  Future<Chapter> update(Chapter chapter);

  Future<void> reorderChapters({
    required String bookId,
    required List<String> chapterIdsInOrder,
  });

  Future<void> delete(String id);
}
