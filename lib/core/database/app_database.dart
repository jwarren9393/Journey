import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:journey/core/database/tables.dart';
import 'package:journey/features/books/domain/models/book.dart' as domain;
import 'package:journey/features/books/domain/models/book_note.dart' as domain;
import 'package:journey/features/books/domain/models/book_tag.dart' as domain;
import 'package:journey/features/books/domain/models/canon_pin.dart' as domain;
import 'package:journey/features/books/domain/models/chapter.dart' as domain;
import 'package:journey/features/books/domain/models/note_relationship.dart'
    as domain;
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart' as domain;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BooksTable,
    ChaptersTable,
    BookNotesTable,
    BookTagsTable,
    BookNoteTagsTable,
    CanonPinsTable,
    StoryLabMessagesTable,
    NoteRelationshipsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(booksTable, booksTable.category);
            await migrator.addColumn(
              chaptersTable,
              chaptersTable.outlineSummary,
            );
            await migrator.createTable(bookNotesTable);
            await migrator.createTable(bookTagsTable);
            await migrator.createTable(bookNoteTagsTable);
          }
          if (from < 3) {
            await migrator.addColumn(booksTable, booksTable.authorsNote);
            await migrator.addColumn(booksTable, booksTable.canonSummary);
            await migrator.addColumn(booksTable, booksTable.storyLabSummary);
            await migrator.addColumn(bookNotesTable, bookNotesTable.loreKeywords);
            await migrator.addColumn(
              bookNotesTable,
              bookNotesTable.loreAlwaysInclude,
            );
            await migrator.addColumn(bookNotesTable, bookNotesTable.lorePriority);
            await migrator.createTable(canonPinsTable);
            await migrator.createTable(storyLabMessagesTable);
          }
          if (from < 4) {
            await migrator.addColumn(bookNotesTable, bookNotesTable.status);
          }
          if (from < 5) {
            await migrator.addColumn(booksTable, booksTable.storyLabDraft);
          }
          if (from < 6) {
            await migrator.addColumn(
              bookNotesTable,
              bookNotesTable.chronologyOrder,
            );
            await migrator.addColumn(bookNotesTable, bookNotesTable.era);
            await migrator.createTable(noteRelationshipsTable);
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
    final id = companion.id.value;
    await (update(booksTable)..where((t) => t.id.equals(id))).write(
      companion.copyWith(id: const Value.absent()),
    );
    final book = await getBookById(id);
    return book!;
  }

  Future<String> getStoryLabDraft(String bookId) async {
    final row = await (select(booksTable)..where((t) => t.id.equals(bookId)))
        .getSingleOrNull();
    return row?.storyLabDraft ?? '';
  }

  Future<void> saveStoryLabDraft(String bookId, String json) async {
    await (update(booksTable)..where((t) => t.id.equals(bookId))).write(
      BooksTableCompanion(storyLabDraft: Value(json)),
    );
  }

  Future<void> deleteBook(String id) async {
    final notes = await (select(bookNotesTable)
          ..where((t) => t.bookId.equals(id)))
        .get();
    for (final note in notes) {
      await (delete(bookNoteTagsTable)..where((t) => t.noteId.equals(note.id)))
          .go();
    }
    await (delete(noteRelationshipsTable)..where((t) => t.bookId.equals(id)))
        .go();
    await (delete(bookNotesTable)..where((t) => t.bookId.equals(id))).go();
    await (delete(bookTagsTable)..where((t) => t.bookId.equals(id))).go();
    await (delete(chaptersTable)..where((t) => t.bookId.equals(id))).go();
    await (delete(canonPinsTable)..where((t) => t.bookId.equals(id))).go();
    await (delete(storyLabMessagesTable)..where((t) => t.bookId.equals(id)))
        .go();
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
    await (delete(noteRelationshipsTable)
          ..where(
            (t) => t.sourceNoteId.equals(id) | t.targetNoteId.equals(id),
          ))
        .go();
    await (delete(bookNotesTable)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<domain.NoteRelationship>> watchRelationshipsByBookId(
    String bookId,
  ) {
    return (select(noteRelationshipsTable)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([(table) => OrderingTerm.asc(table.updatedAt)]))
        .watch()
        .asyncMap((rows) async {
      final items = <domain.NoteRelationship>[];
      for (final row in rows) {
        items.add(await _mapRelationship(row));
      }
      return items;
    });
  }

  Stream<List<domain.NoteRelationship>> watchRelationshipsByNoteId(
    String noteId,
  ) {
    return (select(noteRelationshipsTable)
          ..where(
            (t) =>
                t.sourceNoteId.equals(noteId) | t.targetNoteId.equals(noteId),
          )
          ..orderBy([(table) => OrderingTerm.asc(table.updatedAt)]))
        .watch()
        .asyncMap((rows) async {
      final items = <domain.NoteRelationship>[];
      for (final row in rows) {
        items.add(await _mapRelationship(row));
      }
      return items;
    });
  }

  Future<domain.NoteRelationship?> getRelationshipById(String id) async {
    final row = await (select(noteRelationshipsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapRelationship(row);
  }

  Future<domain.NoteRelationship> insertRelationship(
    NoteRelationshipsTableCompanion companion,
  ) async {
    await into(noteRelationshipsTable).insert(companion);
    final rel = await getRelationshipById(companion.id.value);
    return rel!;
  }

  Future<domain.NoteRelationship> updateRelationship(
    NoteRelationshipsTableCompanion companion,
  ) async {
    await update(noteRelationshipsTable).replace(companion);
    final rel = await getRelationshipById(companion.id.value);
    return rel!;
  }

  Future<void> deleteRelationship(String id) async {
    await (delete(noteRelationshipsTable)..where((t) => t.id.equals(id))).go();
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

  Stream<List<domain.CanonPin>> watchCanonPinsByBookId(String bookId) {
    return (select(canonPinsTable)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
        .watch()
        .map((rows) => rows.map(_mapCanonPin).toList());
  }

  Future<domain.CanonPin> insertCanonPin(
    CanonPinsTableCompanion companion,
  ) async {
    await into(canonPinsTable).insert(companion);
    final row = await (select(canonPinsTable)
          ..where((t) => t.id.equals(companion.id.value)))
        .getSingle();
    return _mapCanonPin(row);
  }

  Future<void> deleteCanonPin(String id) async {
    await (delete(canonPinsTable)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<domain.StoryLabMessage>> watchStoryLabMessagesByBookId(
    String bookId,
  ) {
    return (select(storyLabMessagesTable)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
        .watch()
        .map((rows) => rows.map(_mapStoryLabMessage).toList());
  }

  Future<domain.StoryLabMessage> insertStoryLabMessage(
    StoryLabMessagesTableCompanion companion,
  ) async {
    await into(storyLabMessagesTable).insert(companion);
    final row = await (select(storyLabMessagesTable)
          ..where((t) => t.id.equals(companion.id.value)))
        .getSingle();
    return _mapStoryLabMessage(row);
  }

  Future<void> deleteStoryLabMessagesForBook(String bookId) async {
    await (delete(storyLabMessagesTable)..where((t) => t.bookId.equals(bookId)))
        .go();
  }

  domain.Book _mapBook(BooksTableData row) {
    return domain.Book(
      id: row.id,
      title: row.title,
      description: row.description,
      category: row.category,
      authorsNote: row.authorsNote,
      canonSummary: row.canonSummary,
      storyLabSummary: row.storyLabSummary,
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
      status: NoteStatus.fromStorage(row.status),
      title: row.title,
      content: row.content,
      attachmentPath: row.attachmentPath,
      loreKeywords: row.loreKeywords,
      loreAlwaysInclude: row.loreAlwaysInclude,
      lorePriority: row.lorePriority,
      chronologyOrder: row.chronologyOrder,
      era: row.era,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      tags: tags,
    );
  }

  Future<domain.NoteRelationship> _mapRelationship(
    NoteRelationshipsTableData row,
  ) async {
    final source = await (select(bookNotesTable)
          ..where((t) => t.id.equals(row.sourceNoteId)))
        .getSingleOrNull();
    final target = await (select(bookNotesTable)
          ..where((t) => t.id.equals(row.targetNoteId)))
        .getSingleOrNull();
    return domain.NoteRelationship(
      id: row.id,
      bookId: row.bookId,
      sourceNoteId: row.sourceNoteId,
      targetNoteId: row.targetNoteId,
      relationshipType: row.relationshipType,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      sourceNoteTitle: source?.title ?? '',
      targetNoteTitle: target?.title ?? '',
    );
  }

  domain.BookTag _mapTag(BookTagsTableData row) {
    return domain.BookTag(
      id: row.id,
      bookId: row.bookId,
      name: row.name,
    );
  }

  domain.CanonPin _mapCanonPin(CanonPinsTableData row) {
    return domain.CanonPin(
      id: row.id,
      bookId: row.bookId,
      text: row.pinText,
      createdAt: row.createdAt,
    );
  }

  domain.StoryLabMessage _mapStoryLabMessage(StoryLabMessagesTableData row) {
    return domain.StoryLabMessage(
      id: row.id,
      bookId: row.bookId,
      role: domain.StoryLabRole.fromStorage(row.role),
      content: row.content,
      createdAt: row.createdAt,
    );
  }

  Future<void> deleteAllData() async {
    await delete(noteRelationshipsTable).go();
    await delete(bookNoteTagsTable).go();
    await delete(bookNotesTable).go();
    await delete(bookTagsTable).go();
    await delete(canonPinsTable).go();
    await delete(storyLabMessagesTable).go();
    await delete(chaptersTable).go();
    await delete(booksTable).go();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'journey');
}
