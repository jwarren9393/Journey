import 'package:flutter_test/flutter_test.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/note_templates.dart';

void main() {
  test('character template includes scaffolding headings', () {
    final template = NoteTemplates.templateFor(NoteType.character)!;
    expect(template, contains('## Motivations'));
    expect(template, contains('## Fatal Flaw'));
  });

  test('insertTemplate skips when heading already present', () {
    const existing = '## Motivations\nAlready here';
    final next = NoteTemplates.insertTemplate(NoteType.character, existing);
    expect(next, existing);
  });

  test('insertTemplate appends to non-empty content', () {
    const existing = 'Mara is a scout.';
    final next = NoteTemplates.insertTemplate(NoteType.character, existing);
    expect(next, startsWith(existing));
    expect(next, contains('## Motivations'));
  });
}
