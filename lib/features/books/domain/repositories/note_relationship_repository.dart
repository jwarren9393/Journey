import 'package:journey/features/books/domain/models/note_relationship.dart';

abstract interface class NoteRelationshipRepository {
  Stream<List<NoteRelationship>> watchByBookId(String bookId);

  Stream<List<NoteRelationship>> watchByNoteId(String noteId);

  Future<NoteRelationship?> getById(String id);

  Future<NoteRelationship> create({
    required String bookId,
    required String sourceNoteId,
    required String targetNoteId,
    required String relationshipType,
    String description = '',
  });

  Future<NoteRelationship> update(NoteRelationship relationship);

  Future<void> delete(String id);
}
