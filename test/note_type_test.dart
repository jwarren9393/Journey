import 'package:flutter_test/flutter_test.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

void main() {
  test('NoteType round-trips storage values', () {
    for (final type in NoteType.values) {
      expect(NoteType.fromStorage(type.storageValue), type);
    }
  });
}
