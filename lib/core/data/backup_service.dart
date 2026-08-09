import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:journey/core/database/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  BackupService(this._database);

  final AppDatabase _database;

  Future<String> exportBackup() async {
    final payload = await _buildPayload();
    final json = const JsonEncoder.withIndent('  ').convert(payload);
    final bytes = utf8.encode(json);
    final fileName =
        'journey-backup-${DateTime.now().toIso8601String().split('T').first}.json';

    if (kIsWeb) {
      await SharePlus.instance.share(
        ShareParams(text: json, subject: 'Journey backup'),
      );
      return fileName;
    }

    final directory = await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(bytes, flush: true);

    if (Platform.isAndroid || Platform.isIOS) {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], subject: 'Journey backup'),
      );
    }

    return file.path;
  }

  Future<void> importBackup(String jsonContent) async {
    final payload = jsonDecode(jsonContent) as Map<String, dynamic>;
    final version = payload['version'] as int? ?? 1;
    if (version != 1) {
      throw const BackupException('Unsupported backup version.');
    }

    await _database.transaction(() async {
      await _database.deleteAllData();
      await _importPayload(payload);
    });
  }

  Future<Map<String, dynamic>> _buildPayload() async {
    final books = await _database.select(_database.booksTable).get();
    final chapters = await _database.select(_database.chaptersTable).get();
    final notes = await _database.select(_database.bookNotesTable).get();
    final tags = await _database.select(_database.bookTagsTable).get();
    final noteTags = await _database.select(_database.bookNoteTagsTable).get();

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'books': books.map((row) => row.toJson()).toList(),
      'chapters': chapters.map((row) => row.toJson()).toList(),
      'notes': notes.map((row) => row.toJson()).toList(),
      'tags': tags.map((row) => row.toJson()).toList(),
      'noteTags': noteTags.map((row) => row.toJson()).toList(),
    };
  }

  Future<void> _importPayload(Map<String, dynamic> payload) async {
    for (final row in payload['books'] as List<dynamic>) {
      await _database.into(_database.booksTable).insert(
            _bookCompanion(row as Map<String, dynamic>),
          );
    }
    for (final row in payload['chapters'] as List<dynamic>) {
      await _database.into(_database.chaptersTable).insert(
            _chapterCompanion(row as Map<String, dynamic>),
          );
    }
    for (final row in payload['notes'] as List<dynamic>) {
      await _database.into(_database.bookNotesTable).insert(
            _noteCompanion(row as Map<String, dynamic>),
          );
    }
    for (final row in payload['tags'] as List<dynamic>) {
      await _database.into(_database.bookTagsTable).insert(
            _tagCompanion(row as Map<String, dynamic>),
          );
    }
    for (final row in payload['noteTags'] as List<dynamic>) {
      final map = row as Map<String, dynamic>;
      await _database.into(_database.bookNoteTagsTable).insert(
            BookNoteTagsTableCompanion.insert(
              noteId: map['noteId'] as String,
              tagId: map['tagId'] as String,
            ),
          );
    }
  }

  BooksTableCompanion _bookCompanion(Map<String, dynamic> json) {
    return BooksTableCompanion.insert(
      id: json['id'] as String,
      title: json['title'] as String,
      description: Value(json['description'] as String? ?? ''),
      category: Value(json['category'] as String? ?? ''),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  ChaptersTableCompanion _chapterCompanion(Map<String, dynamic> json) {
    return ChaptersTableCompanion.insert(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      content: Value(json['content'] as String? ?? ''),
      outlineSummary: Value(json['outlineSummary'] as String? ?? ''),
      sortOrder: json['sortOrder'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  BookNotesTableCompanion _noteCompanion(Map<String, dynamic> json) {
    return BookNotesTableCompanion.insert(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      content: Value(json['content'] as String? ?? ''),
      attachmentPath: Value(json['attachmentPath'] as String? ?? ''),
      sortOrder: json['sortOrder'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  BookTagsTableCompanion _tagCompanion(Map<String, dynamic> json) {
    return BookTagsTableCompanion.insert(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      name: json['name'] as String,
    );
  }
}

class BackupException implements Exception {
  const BackupException(this.message);

  final String message;

  @override
  String toString() => message;
}
