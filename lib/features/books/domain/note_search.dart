import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

enum NoteSort {
  updatedDesc,
  titleAsc,
  typeThenTitle,
}

abstract final class NoteSearch {
  static List<BookNote> filter(
    Iterable<BookNote> notes, {
    String query = '',
    NoteType? type,
    NoteStatus? status,
    String? tagId,
    NoteSort sort = NoteSort.updatedDesc,
  }) {
    final filtered = notes.where((note) {
      if (type != null && note.type != type) {
        return false;
      }
      if (status != null && note.status != status) {
        return false;
      }
      if (tagId != null && !note.tags.any((tag) => tag.id == tagId)) {
        return false;
      }
      return note.matchesQuery(query);
    }).toList();

    filtered.sort((a, b) {
      switch (sort) {
        case NoteSort.updatedDesc:
          return b.updatedAt.compareTo(a.updatedAt);
        case NoteSort.titleAsc:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case NoteSort.typeThenTitle:
          final typeOrder = a.type.label.compareTo(b.type.label);
          if (typeOrder != 0) {
            return typeOrder;
          }
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });

    return filtered;
  }
}
