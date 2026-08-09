class Chapter {
  const Chapter({
    required this.id,
    required this.bookId,
    required this.title,
    required this.content,
    required this.outlineSummary,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String bookId;
  final String title;
  final String content;
  final String outlineSummary;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get wordCount {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return 0;
    }
    return trimmed.split(RegExp(r'\s+')).length;
  }

  Chapter copyWith({
    String? id,
    String? bookId,
    String? title,
    String? content,
    String? outlineSummary,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chapter(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      content: content ?? this.content,
      outlineSummary: outlineSummary ?? this.outlineSummary,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
