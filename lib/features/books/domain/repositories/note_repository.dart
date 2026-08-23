import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

abstract interface class NoteRepository {
  Stream<List<BookNote>> watchByBookId(String bookId, {NoteType? type});

  Future<BookNote?> getById(String id);

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
  });

  Future<BookNote> update(BookNote note);

  Future<void> delete(String id);
}
