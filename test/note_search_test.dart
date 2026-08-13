import 'package:flutter_test/flutter_test.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/book_tag.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/note_search.dart';

void main() {
  final now = DateTime(2026);

  BookNote note({
    required String id,
    required String title,
    NoteType type = NoteType.character,
    NoteStatus status = NoteStatus.draft,
    String content = '',
    String keywords = '',
    List<BookTag> tags = const [],
    DateTime? updatedAt,
  }) {
    return BookNote(
      id: id,
      bookId: 'b1',
      type: type,
      status: status,
      title: title,
      content: content,
      attachmentPath: '',
      loreKeywords: keywords,
      loreAlwaysInclude: false,
      lorePriority: 5,
      sortOrder: 0,
      createdAt: now,
      updatedAt: updatedAt ?? now,
      tags: tags,
    );
  }

  test('NoteType and NoteStatus round-trip storage values', () {
    for (final type in NoteType.values) {
      expect(NoteType.fromStorage(type.storageValue), type);
    }
    for (final status in NoteStatus.values) {
      expect(NoteStatus.fromStorage(status.storageValue), status);
    }
  });

  test('NoteSearch filters by type, status, query, and tag', () {
    const house = BookTag(id: 't1', bookId: 'b1', name: 'House Veyra');
    final notes = [
      note(id: '1', title: 'Mira', keywords: 'Mira, captain', tags: [house]),
      note(
        id: '2',
        title: 'Silver Oak',
        type: NoteType.location,
        status: NoteStatus.canon,
        content: 'A forgotten port city',
      ),
      note(
        id: '3',
        title: 'What if memory tax',
        type: NoteType.idea,
        status: NoteStatus.spark,
        content: 'Magic that costs names',
      ),
    ];

    expect(
      NoteSearch.filter(notes, type: NoteType.location).map((item) => item.id),
      ['2'],
    );
    expect(
      NoteSearch.filter(notes, status: NoteStatus.spark).map((item) => item.id),
      ['3'],
    );
    expect(
      NoteSearch.filter(notes, query: 'mira').map((item) => item.id),
      ['1'],
    );
    expect(
      NoteSearch.filter(notes, query: 'port').map((item) => item.id),
      ['2'],
    );
    expect(
      NoteSearch.filter(notes, tagId: house.id).map((item) => item.id),
      ['1'],
    );
  });
}
