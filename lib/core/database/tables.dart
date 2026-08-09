import 'package:drift/drift.dart';

class BooksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get category => text().withDefault(const Constant(''))();
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
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

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
