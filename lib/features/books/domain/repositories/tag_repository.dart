import 'package:journey/features/books/domain/models/book_tag.dart';

abstract interface class TagRepository {
  Stream<List<BookTag>> watchByBookId(String bookId);

  Future<BookTag> getOrCreate({
    required String bookId,
    required String name,
  });

  Future<void> setTagsForNote({
    required String noteId,
    required List<String> tagIds,
  });

  Future<void> delete(String id);
}
