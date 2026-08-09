enum BookExportFormat {
  plainText,
  markdown,
}

abstract final class BookExporter {
  static String export({
    required String bookTitle,
    required String bookDescription,
    required List<({String title, String content})> chapters,
    required BookExportFormat format,
  }) {
    return switch (format) {
      BookExportFormat.plainText => _toPlainText(
          bookTitle: bookTitle,
          bookDescription: bookDescription,
          chapters: chapters,
        ),
      BookExportFormat.markdown => _toMarkdown(
          bookTitle: bookTitle,
          bookDescription: bookDescription,
          chapters: chapters,
        ),
    };
  }

  static String fileExtension(BookExportFormat format) {
    return switch (format) {
      BookExportFormat.plainText => 'txt',
      BookExportFormat.markdown => 'md',
    };
  }

  static String _toPlainText({
    required String bookTitle,
    required String bookDescription,
    required List<({String title, String content})> chapters,
  }) {
    final buffer = StringBuffer(bookTitle);

    if (bookDescription.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln()
        ..writeln(bookDescription.trim());
    }

    for (final chapter in chapters) {
      buffer
        ..writeln()
        ..writeln()
        ..writeln(chapter.title)
        ..writeln()
        ..write(chapter.content.trimRight());
    }

    return buffer.toString().trimRight();
  }

  static String _toMarkdown({
    required String bookTitle,
    required String bookDescription,
    required List<({String title, String content})> chapters,
  }) {
    final buffer = StringBuffer('# $bookTitle');

    if (bookDescription.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln()
        ..writeln(bookDescription.trim());
    }

    for (final chapter in chapters) {
      buffer
        ..writeln()
        ..writeln()
        ..writeln('## ${chapter.title}')
        ..writeln()
        ..write(chapter.content.trimRight());
    }

    return buffer.toString().trimRight();
  }

  static String sanitizeFileName(String title) {
    final sanitized = title
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (sanitized.isEmpty) {
      return 'journey-export';
    }

    return sanitized;
  }
}
