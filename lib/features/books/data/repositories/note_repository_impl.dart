import 'package:drift/drift.dart';
import 'package:journey/core/database/app_database.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/repositories/note_repository.dart';
import 'package:uuid/uuid.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  @override
  Stream<List<BookNote>> watchByBookId(String bookId, {NoteType? type}) {
    return _database.watchNotesByBookId(bookId, type: type);
  }

  @override
  Future<BookNote?> getById(String id) => _database.getNoteById(id);

  @override
  Future<BookNote> create({
    required String bookId,
    required NoteType type,
    required String title,
    String content = '',
    String attachmentPath = '',
    String loreKeywords = '',
    bool loreAlwaysInclude = false,
    int lorePriority = 5,
    NoteStatus status = NoteStatus.draft,
    double? chronologyOrder,
    String era = '',
  }) async {
    final now = DateTime.now();
    final sortOrder = await _database.nextNoteSortOrder(bookId);
    final id = _uuid.v4();
    return _database.insertNote(
      BookNotesTableCompanion.insert(
        id: id,
        bookId: bookId,
        type: type.storageValue,
        title: title.trim(),
        content: Value(content),
        attachmentPath: Value(attachmentPath),
        loreKeywords: Value(loreKeywords),
        loreAlwaysInclude: Value(loreAlwaysInclude),
        lorePriority: Value(lorePriority.clamp(0, 10)),
        status: Value(status.storageValue),
        chronologyOrder: Value(chronologyOrder),
        era: Value(era),
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<BookNote> update(BookNote note) {
    return _database.updateNote(
      BookNotesTableCompanion(
        id: Value(note.id),
        bookId: Value(note.bookId),
        type: Value(note.type.storageValue),
        title: Value(note.title.trim()),
        content: Value(note.content),
        attachmentPath: Value(note.attachmentPath),
        loreKeywords: Value(note.loreKeywords),
        loreAlwaysInclude: Value(note.loreAlwaysInclude),
        lorePriority: Value(note.lorePriority.clamp(0, 10)),
        status: Value(note.status.storageValue),
        chronologyOrder: Value(note.chronologyOrder),
        era: Value(note.era),
        sortOrder: Value(note.sortOrder),
        createdAt: Value(note.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _database.deleteNote(id);
}
