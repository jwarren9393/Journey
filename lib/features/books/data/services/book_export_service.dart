import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/services/book_exporter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BookExportService {
  Future<String> exportBook({
    required Book book,
    required List<Chapter> chapters,
    required BookExportFormat format,
  }) async {
    if (chapters.isEmpty) {
      throw const BookExportException('Add at least one chapter before exporting.');
    }

    final content = BookExporter.export(
      bookTitle: book.title,
      bookDescription: book.description,
      chapters: chapters
          .map((chapter) => (title: chapter.title, content: chapter.content))
          .toList(),
      format: format,
    );

    final bytes = utf8.encode(content);
    final extension = BookExporter.fileExtension(format);
    final fileName = '${BookExporter.sanitizeFileName(book.title)}.$extension';

    if (kIsWeb) {
      await SharePlus.instance.share(
        ShareParams(
          text: content,
          subject: book.title,
        ),
      );
      return fileName;
    }

    final directory = await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(bytes, flush: true);

    if (Platform.isAndroid || Platform.isIOS) {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: book.title,
        ),
      );
    }

    return file.path;
  }
}

class BookExportException implements Exception {
  const BookExportException(this.message);

  final String message;

  @override
  String toString() => message;
}

final bookExportServiceProvider = Provider<BookExportService>(
  (ref) => BookExportService(),
);
