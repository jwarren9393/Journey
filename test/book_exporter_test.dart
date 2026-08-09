import 'package:flutter_test/flutter_test.dart';
import 'package:journey/features/books/domain/services/book_exporter.dart';

void main() {
  group('BookExporter', () {
    const chapters = [
      (title: 'Chapter One', content: 'Once upon a time.'),
      (title: 'Chapter Two', content: 'The journey continued.'),
    ];

    test('exports plain text with chapters', () {
      final output = BookExporter.export(
        bookTitle: 'My Story',
        bookDescription: 'A quiet tale.',
        chapters: chapters,
        format: BookExportFormat.plainText,
      );

      expect(output, contains('My Story'));
      expect(output, contains('A quiet tale.'));
      expect(output, contains('Chapter One'));
      expect(output, contains('Once upon a time.'));
    });

    test('exports markdown with headings', () {
      final output = BookExporter.export(
        bookTitle: 'My Story',
        bookDescription: '',
        chapters: chapters,
        format: BookExportFormat.markdown,
      );

      expect(output, startsWith('# My Story'));
      expect(output, contains('## Chapter One'));
      expect(output, contains('Once upon a time.'));
    });

    test('sanitizes file names', () {
      expect(
        BookExporter.sanitizeFileName('Story: Part 1/2'),
        'Story Part 12',
      );
    });
  });
}
