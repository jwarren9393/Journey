import 'package:drift/drift.dart';
import 'package:journey/core/database/app_database.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/repositories/chapter_repository.dart';
import 'package:uuid/uuid.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  ChapterRepositoryImpl(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  @override
  Stream<List<Chapter>> watchByBookId(String bookId) {
    return _database.watchChaptersByBookId(bookId);
  }

  @override
  Future<Chapter?> getById(String id) => _database.getChapterById(id);

  @override
  Future<Chapter> create({
    required String bookId,
    required String title,
    String content = '',
  }) async {
    final now = DateTime.now();
    final sortOrder = await _database.nextChapterSortOrder(bookId);
    final id = _uuid.v4();
    return _database.insertChapter(
      ChaptersTableCompanion.insert(
        id: id,
        bookId: bookId,
        title: title.trim(),
        content: Value(content),
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<Chapter> update(Chapter chapter) {
    return _database.updateChapter(
      ChaptersTableCompanion(
        id: Value(chapter.id),
        bookId: Value(chapter.bookId),
        title: Value(chapter.title.trim()),
        content: Value(chapter.content),
        outlineSummary: Value(chapter.outlineSummary.trim()),
        sortOrder: Value(chapter.sortOrder),
        createdAt: Value(chapter.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> reorderChapters({
    required String bookId,
    required List<String> chapterIdsInOrder,
  }) {
    return _database.reorderChapters(
      bookId: bookId,
      chapterIdsInOrder: chapterIdsInOrder,
    );
  }

  @override
  Future<void> delete(String id) => _database.deleteChapter(id);
}
