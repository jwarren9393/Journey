import 'package:journey/features/books/domain/models/book_tag.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

class BookNote {
  const BookNote({
    required this.id,
    required this.bookId,
    required this.type,
    required this.title,
    required this.content,
    required this.attachmentPath,
    required this.loreKeywords,
    required this.loreAlwaysInclude,
    required this.lorePriority,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  final String id;
  final String bookId;
  final NoteType type;
  final String title;
  final String content;
  final String attachmentPath;

  /// Comma-separated keywords that trigger this note during AI context assembly.
  final String loreKeywords;

  /// When true, always include in AI context (within token budget).
  final bool loreAlwaysInclude;

  /// Higher priority notes are included first (0–10).
  final int lorePriority;

  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BookTag> tags;

  bool get hasAttachment => attachmentPath.trim().isNotEmpty;

  List<String> get keywordList => loreKeywords
      .split(',')
      .map((keyword) => keyword.trim())
      .where((keyword) => keyword.isNotEmpty)
      .toList();

  BookNote copyWith({
    String? id,
    String? bookId,
    NoteType? type,
    String? title,
    String? content,
    String? attachmentPath,
    String? loreKeywords,
    bool? loreAlwaysInclude,
    int? lorePriority,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<BookTag>? tags,
  }) {
    return BookNote(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      loreKeywords: loreKeywords ?? this.loreKeywords,
      loreAlwaysInclude: loreAlwaysInclude ?? this.loreAlwaysInclude,
      lorePriority: lorePriority ?? this.lorePriority,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }
}
