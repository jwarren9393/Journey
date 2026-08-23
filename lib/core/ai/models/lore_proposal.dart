import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

/// How a [LoreProposal] should change the world bible.
enum LoreProposalKind {
  /// Create a new note.
  create,

  /// Replace an existing note's body (and optionally type/status/timeline).
  update,

  /// Soft-retire: demote to Idea / Spark so it drops out of writing lore.
  retire,

  /// Create or update a directed relationship between two notes.
  upsertRelationship,

  /// Remove a relationship between two notes.
  deleteRelationship,
}

/// A reviewable suggestion from Promote to lore, Deepen note, or Update World State.
class LoreProposal {
  const LoreProposal({
    required this.id,
    required this.kind,
    required this.title,
    required this.type,
    required this.status,
    required this.content,
    required this.reason,
    this.noteId,
    this.loreKeywords = '',
    this.chronologyOrder,
    this.era,
    this.relationshipId,
    this.sourceNoteId,
    this.targetNoteId,
    this.sourceNoteTitle = '',
    this.targetNoteTitle = '',
    this.relationshipType = '',
    this.relationshipDescription = '',
  });

  /// Stable id for checkbox selection in the review sheet.
  final String id;

  final LoreProposalKind kind;

  /// Existing note id when [kind] is update or retire.
  final String? noteId;

  final String title;
  final NoteType type;
  final NoteStatus status;
  final String content;
  final String reason;
  final String loreKeywords;

  /// Optional timeline fields for update/create (History/Plot).
  final double? chronologyOrder;
  final String? era;

  // Relationship fields
  final String? relationshipId;
  final String? sourceNoteId;
  final String? targetNoteId;
  final String sourceNoteTitle;
  final String targetNoteTitle;
  final String relationshipType;
  final String relationshipDescription;

  bool get isRelationship =>
      kind == LoreProposalKind.upsertRelationship ||
      kind == LoreProposalKind.deleteRelationship;

  String get kindLabel => switch (kind) {
        LoreProposalKind.create => 'Create',
        LoreProposalKind.update => 'Update',
        LoreProposalKind.retire => 'Retire',
        LoreProposalKind.upsertRelationship => 'Link',
        LoreProposalKind.deleteRelationship => 'Unlink',
      };
}
