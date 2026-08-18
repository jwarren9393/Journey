import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/repositories/note_repository.dart';

final notesStreamProvider =
    StreamProvider.family<List<BookNote>, NotesQuery>((ref, query) {
  return ref
      .watch(noteRepositoryProvider)
      .watchByBookId(query.bookId, type: query.type);
});

final noteProvider = FutureProvider.family<BookNote?, String>((ref, noteId) {
  return ref.watch(noteRepositoryProvider).getById(noteId);
});

class NotesQuery {
  const NotesQuery({
    required this.bookId,
    this.type,
  });

  final String bookId;
  final NoteType? type;

  @override
  bool operator ==(Object other) {
    return other is NotesQuery &&
        other.bookId == bookId &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(bookId, type);
}

extension NoteRepositoryReader on WidgetRef {
  NoteRepository get notes => read(noteRepositoryProvider);
}
