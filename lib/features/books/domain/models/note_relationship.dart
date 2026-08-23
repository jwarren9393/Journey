/// A directed link between two notes in a book's world bible.
class NoteRelationship {
  const NoteRelationship({
    required this.id,
    required this.bookId,
    required this.sourceNoteId,
    required this.targetNoteId,
    required this.relationshipType,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.sourceNoteTitle = '',
    this.targetNoteTitle = '',
  });

  final String id;
  final String bookId;
  final String sourceNoteId;
  final String targetNoteId;
  final String relationshipType;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Optional display titles (filled by repository joins / UI).
  final String sourceNoteTitle;
  final String targetNoteTitle;

  NoteRelationship copyWith({
    String? id,
    String? bookId,
    String? sourceNoteId,
    String? targetNoteId,
    String? relationshipType,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sourceNoteTitle,
    String? targetNoteTitle,
  }) {
    return NoteRelationship(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      sourceNoteId: sourceNoteId ?? this.sourceNoteId,
      targetNoteId: targetNoteId ?? this.targetNoteId,
      relationshipType: relationshipType ?? this.relationshipType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceNoteTitle: sourceNoteTitle ?? this.sourceNoteTitle,
      targetNoteTitle: targetNoteTitle ?? this.targetNoteTitle,
    );
  }
}

/// Common relationship type labels for pickers.
abstract final class RelationshipTypes {
  static const presets = <String>[
    'Ally',
    'Enemy',
    'Rival',
    'Family',
    'Subordinate',
    'Leader',
    'Creator',
    'Owns',
    'Located in',
    'Member of',
    'Betrayer',
    'Other',
  ];
}
