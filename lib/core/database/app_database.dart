import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:journey/core/database/tables.dart';
import 'package:journey/features/books/domain/models/book.dart' as domain;
import 'package:journey/features/books/domain/models/book_note.dart' as domain;
import 'package:journey/features/books/domain/models/book_tag.dart' as domain;
import 'package:journey/features/books/domain/models/chapter.dart' as domain;
import 'package:journey/features/books/domain/models/note_type.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BooksTable,
    ChaptersTable,
    BookNotesTable,
    BookTagsTable,
    BookNoteTagsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(booksTable, booksTable.category);
            await migrator.addColumn(chaptersTable, chaptersTable.outlineSummary);
            await migrator.createTable(bookNotesTable);
            await migrator.createTable(bookTagsTable);
            await migrator.createTable(bookNoteTagsTable);
          }
        },
      );

  Stream<List<domain.Book>> watchAllBooks() {
    return (select(booksTable)
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]))
        .watch()
        .map((rows) => rows.map(_mapBook).toList());
  }

  Future<domain.Book?> getBookById(String id) async {
    final row = await (select(booksTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapBook(row);
  }

  Future<domain.Book> insertBook(BooksTableCompanion companion) async {
    await into(booksTable).insert(companion);
    final book = await getBookById(companion.id.value);
    return book!;
  }

  Future<domain.Book> updateBook(BooksTableCompanion companion) async {
    await update(booksTable).replace(companion);
    final book = await getBookById(companion.id.value);
    return book!;
  }

  Future<void> deleteBook(String id) async {
    final notes = await (select(bookNotesTable)
          ..where((t) => t.bookId.equals(id)))
        .get();
    for (final note in notes) {
      await (delete(bookNoteTagsTable)..where((t) => t.noteId.equals(note.id)))
          .go();
    }
    await (delete(bookNotesTable)..where((t) => t.bookId.equals(id))).go();
    await (delete(bookTagsTable)..where((t) => t.bookId.equals(id))).go();
    await (delete(chaptersTable)..where((t) => t.bookId.equals(id))).go();
    await (delete(booksTable)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<domain.Chapter>> watchChaptersByBookId(String bookId) {
    return (select(chaptersTable)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_mapChapter).toList());
  }

  Future<domain.Chapter?> getChapterById(String id) async {
    final row = await (select(chaptersTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapChapter(row);
  }

  Future<int> nextChapterSortOrder(String bookId) async {
    final query = selectOnly(chaptersTable)
      ..addColumns([chaptersTable.sortOrder.max()])
      ..where(chaptersTable.bookId.equals(bookId));
    final row = await query.getSingle();
    final maxOrder = row.read(chaptersTable.sortOrder.max());
    return (maxOrder ?? -1) + 1;
  }

  Future<domain.Chapter> insertChapter(ChaptersTableCompanion companion) async {
    await into(chaptersTable).insert(companion);
    final chapter = await getChapterById(companion.id.value);
    return chapter!;
  }

  Future<domain.Chapter> updateChapter(ChaptersTableCompanion companion) async {
    await update(chaptersTable).replace(companion);
    final chapter = await getChapterById(companion.id.value);
    return chapter!;
  }

  Future<void> reorderChapters({
    required String bookId,
    required List<String> chapterIdsInOrder,
  }) async {
    await transaction(() async {
      for (var index = 0; index < chapterIdsInOrder.length; index++) {
        final chapterId = chapterIdsInOrder[index];
        await (update(chaptersTable)..where(
              (t) => t.id.equals(chapterId) & t.bookId.equals(bookId),
            ))
            .write(ChaptersTableCompanion(sortOrder: Value(index)));
      }
    });
  }

  Future<void> deleteChapter(String id) async {
    await (delete(chaptersTable)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<domain.BookNote>> watchNotesByBookId(
    String bookId, {
    NoteType? type,
  }) {
    final query = select(bookNotesTable)..where((t) => t.bookId.equals(bookId));
    if (type != null) {
      query.where((t) => t.type.equals(type.storageValue));
    }
    query.orderBy([(table) => OrderingTerm.asc(table.sortOrder)]);

    return query.watch().asyncMap((rows) async {
      final notes = <domain.BookNote>[];
      for (final row in rows) {
        notes.add(await _mapNote(row));
      }
      return notes;
    });
  }

  Future<domain.BookNote?> getNoteById(String id) async {
    final row = await (select(bookNotesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapNote(row);
  }

  Future<int> nextNoteSortOrder(String bookId) async {
    final query = selectOnly(bookNotesTable)
      ..addColumns([bookNotesTable.sortOrder.max()])
      ..where(bookNotesTable.bookId.equals(bookId));
    final row = await query.getSingle();
    final maxOrder = row.read(bookNotesTable.sortOrder.max());
    return (maxOrder ?? -1) + 1;
  }

  Future<domain.BookNote> insertNote(BookNotesTableCompanion companion) async {
    await into(bookNotesTable).insert(companion);
    final note = await getNoteById(companion.id.value);
    return note!;
  }

  Future<domain.BookNote> updateNote(BookNotesTableCompanion companion) async {
    await update(bookNotesTable).replace(companion);
    final note = await getNoteById(companion.id.value);
    return note!;
  }

  Future<void> deleteNote(String id) async {
    await (delete(bookNoteTagsTable)..where((t) => t.noteId.equals(id))).go();
    await (delete(bookNotesTable)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<domain.BookTag>> watchTagsByBookId(String bookId) {
    return (select(bookTagsTable)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([(table) => OrderingTerm.asc(table.name)]))
        .watch()
        .map((rows) => rows.map(_mapTag).toList());
  }

  Future<domain.BookTag?> findTagByName(String bookId, String name) async {
    final row = await (select(bookTagsTable)
          ..where(
            (t) => t.bookId.equals(bookId) & t.name.equals(name.trim()),
          ))
        .getSingleOrNull();
    return row == null ? null : _mapTag(row);
  }

  Future<domain.BookTag> insertTag(BookTagsTableCompanion companion) async {
    await into(bookTagsTable).insert(companion);
    final row = await (select(bookTagsTable)
          ..where((t) => t.id.equals(companion.id.value)))
        .getSingle();
    return _mapTag(row);
  }

  Future<void> deleteTag(String id) async {
    await (delete(bookNoteTagsTable)..where((t) => t.tagId.equals(id))).go();
    await (delete(bookTagsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> setTagsForNote(String noteId, List<String> tagIds) async {
    await transaction(() async {
      await (delete(bookNoteTagsTable)..where((t) => t.noteId.equals(noteId)))
          .go();
      for (final tagId in tagIds) {
        await into(bookNoteTagsTable).insert(
          BookNoteTagsTableCompanion.insert(noteId: noteId, tagId: tagId),
        );
      }
    });
  }

  Future<List<domain.BookTag>> getTagsForNote(String noteId) async {
    final query = select(bookTagsTable).join([
      innerJoin(
        bookNoteTagsTable,
        bookNoteTagsTable.tagId.equalsExp(bookTagsTable.id),
      ),
    ])
      ..where(bookNoteTagsTable.noteId.equals(noteId));

    final rows = await query.get();
    return rows.map((row) => _mapTag(row.readTable(bookTagsTable))).toList();
  }

  domain.Book _mapBook(BooksTableData row) {
    return domain.Book(
      id: row.id,
      title: row.title,
      description: row.description,
      category: row.category,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  domain.Chapter _mapChapter(ChaptersTableData row) {
    return domain.Chapter(
      id: row.id,
      bookId: row.bookId,
      title: row.title,
      content: row.content,
      outlineSummary: row.outlineSummary,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<domain.BookNote> _mapNote(BookNotesTableData row) async {
    final tags = await getTagsForNote(row.id);
    return domain.BookNote(
      id: row.id,
      bookId: row.bookId,
      type: NoteType.fromStorage(row.type),
      title: row.title,
      content: row.content,
      attachmentPath: row.attachmentPath,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      tags: tags,
    );
  }

  domain.BookTag _mapTag(BookTagsTableData row) {
    return domain.BookTag(
      id: row.id,
      bookId: row.bookId,
      name: row.name,
    );
  }

  Future<void> deleteAllData() async {
    await delete(bookNoteTagsTable).go();
    await delete(bookNotesTable).go();
    await delete(bookTagsTable).go();
    await delete(chaptersTable).go();
    await delete(booksTable).go();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'journey');
}
