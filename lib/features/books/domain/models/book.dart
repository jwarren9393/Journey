class Book {
  const Book({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.authorsNote,
    required this.canonSummary,
    required this.storyLabSummary,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final String category;

  /// Per-book AI style guide (POV, tense, tone). Injected when AI is used.
  final String authorsNote;

  /// Running canon facts (bullet-style). Updated only when the author requests it.
  final String canonSummary;

  /// Folded summary from Story Lab brainstorms. Updated only on demand.
  final String storyLabSummary;

  final DateTime createdAt;
  final DateTime updatedAt;

  Book copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? authorsNote,
    String? canonSummary,
    String? storyLabSummary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      authorsNote: authorsNote ?? this.authorsNote,
      canonSummary: canonSummary ?? this.canonSummary,
      storyLabSummary: storyLabSummary ?? this.storyLabSummary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
