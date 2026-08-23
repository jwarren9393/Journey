import 'package:drift/drift.dart';

class BooksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get category => text().withDefault(const Constant(''))();
  TextColumn get authorsNote => text().withDefault(const Constant(''))();
  TextColumn get canonSummary => text().withDefault(const Constant(''))();
  TextColumn get storyLabSummary => text().withDefault(const Constant(''))();
  TextColumn get storyLabDraft => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ChaptersTable extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(BooksTable, #id)();
  TextColumn get title => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get outlineSummary => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BookNotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(BooksTable, #id)();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get attachmentPath => text().withDefault(const Constant(''))();
  TextColumn get loreKeywords => text().withDefault(const Constant(''))();
  BoolColumn get loreAlwaysInclude =>
      boolean().withDefault(const Constant(false))();
  IntColumn get lorePriority => integer().withDefault(const Constant(5))();
  TextColumn get status => text().withDefault(const Constant('canon'))();
  /// Sort key for History/Plot timeline views; null means unset.
  RealColumn get chronologyOrder => real().nullable()();
  /// Optional era label (e.g. "Age of Ash", "Year 12").
  TextColumn get era => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class NoteRelationshipsTable extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(BooksTable, #id)();
  TextColumn get sourceNoteId => text().references(BookNotesTable, #id)();
  TextColumn get targetNoteId => text().references(BookNotesTable, #id)();
  TextColumn get relationshipType => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CanonPinsTable extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(BooksTable, #id)();
  TextColumn get pinText => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StoryLabMessagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(BooksTable, #id)();
  TextColumn get role => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BookTagsTable extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(BooksTable, #id)();
  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BookNoteTagsTable extends Table {
  TextColumn get noteId => text().references(BookNotesTable, #id)();
  TextColumn get tagId => text().references(BookTagsTable, #id)();

  @override
  Set<Column<Object>> get primaryKey => {noteId, tagId};
}
