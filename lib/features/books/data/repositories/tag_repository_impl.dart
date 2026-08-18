import 'package:journey/core/database/app_database.dart';
import 'package:journey/features/books/domain/models/book_tag.dart';
import 'package:journey/features/books/domain/repositories/tag_repository.dart';
import 'package:uuid/uuid.dart';

class TagRepositoryImpl implements TagRepository {
  TagRepositoryImpl(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  @override
  Stream<List<BookTag>> watchByBookId(String bookId) {
    return _database.watchTagsByBookId(bookId);
  }

  @override
  Future<BookTag> getOrCreate({
    required String bookId,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Tag name cannot be empty.');
    }

    final existing = await _database.findTagByName(bookId, trimmed);
    if (existing != null) {
      return existing;
    }

    return _database.insertTag(
      BookTagsTableCompanion.insert(
        id: _uuid.v4(),
        bookId: bookId,
        name: trimmed,
      ),
    );
  }

  @override
  Future<void> setTagsForNote({
    required String noteId,
    required List<String> tagIds,
  }) {
    return _database.setTagsForNote(noteId, tagIds);
  }

  @override
  Future<void> delete(String id) => _database.deleteTag(id);
}
