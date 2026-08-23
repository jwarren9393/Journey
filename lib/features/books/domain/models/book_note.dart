import 'package:journey/features/books/domain/models/book_tag.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
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
    this.status = NoteStatus.canon,
    this.chronologyOrder,
    this.era = '',
    this.tags = const [],
  });

  final String id;
  final String bookId;
  final NoteType type;
  final NoteStatus status;
  final String title;
  final String content;
  final String attachmentPath;

  /// Comma-separated keywords that trigger this note during AI context assembly.
  final String loreKeywords;

  /// When true, always include in AI context (within token budget).
  final bool loreAlwaysInclude;

  /// Higher priority notes are included first (0–10).
  final int lorePriority;

  /// Optional timeline sort key (History / Plot). Null = unset.
  final double? chronologyOrder;

  /// Optional era label for timeline display.
  final String era;

  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BookTag> tags;

  bool get hasAttachment => attachmentPath.trim().isNotEmpty;

  bool get hasChronology => chronologyOrder != null || era.trim().isNotEmpty;

  List<String> get keywordList => loreKeywords
      .split(',')
      .map((keyword) => keyword.trim())
      .where((keyword) => keyword.isNotEmpty)
      .toList();

  bool matchesQuery(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return true;
    }
    if (title.toLowerCase().contains(needle)) {
      return true;
    }
    if (content.toLowerCase().contains(needle)) {
      return true;
    }
    if (loreKeywords.toLowerCase().contains(needle)) {
      return true;
    }
    if (era.toLowerCase().contains(needle)) {
      return true;
    }
    if (type.label.toLowerCase().contains(needle)) {
      return true;
    }
    if (status.label.toLowerCase().contains(needle)) {
      return true;
    }
    return tags.any((tag) => tag.name.toLowerCase().contains(needle));
  }

  BookNote copyWith({
    String? id,
    String? bookId,
    NoteType? type,
    NoteStatus? status,
    String? title,
    String? content,
    String? attachmentPath,
    String? loreKeywords,
    bool? loreAlwaysInclude,
    int? lorePriority,
    double? chronologyOrder,
    bool clearChronologyOrder = false,
    String? era,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<BookTag>? tags,
  }) {
    return BookNote(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      type: type ?? this.type,
      status: status ?? this.status,
      title: title ?? this.title,
      content: content ?? this.content,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      loreKeywords: loreKeywords ?? this.loreKeywords,
      loreAlwaysInclude: loreAlwaysInclude ?? this.loreAlwaysInclude,
      lorePriority: lorePriority ?? this.lorePriority,
      chronologyOrder: clearChronologyOrder
          ? null
          : (chronologyOrder ?? this.chronologyOrder),
      era: era ?? this.era,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }
}
