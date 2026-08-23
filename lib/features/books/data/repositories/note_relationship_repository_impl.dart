import 'package:drift/drift.dart';
import 'package:journey/core/database/app_database.dart';
import 'package:journey/features/books/domain/models/note_relationship.dart';
import 'package:journey/features/books/domain/repositories/note_relationship_repository.dart';
import 'package:uuid/uuid.dart';

class NoteRelationshipRepositoryImpl implements NoteRelationshipRepository {
  NoteRelationshipRepositoryImpl(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  @override
  Stream<List<NoteRelationship>> watchByBookId(String bookId) {
    return _database.watchRelationshipsByBookId(bookId);
  }

  @override
  Stream<List<NoteRelationship>> watchByNoteId(String noteId) {
    return _database.watchRelationshipsByNoteId(noteId);
  }

  @override
  Future<NoteRelationship?> getById(String id) {
    return _database.getRelationshipById(id);
  }

  @override
  Future<NoteRelationship> create({
    required String bookId,
    required String sourceNoteId,
    required String targetNoteId,
    required String relationshipType,
    String description = '',
  }) async {
    if (sourceNoteId == targetNoteId) {
      throw ArgumentError('A note cannot relate to itself.');
    }
    final trimmedType = relationshipType.trim();
    if (trimmedType.isEmpty) {
      throw ArgumentError('Relationship type is required.');
    }

    final now = DateTime.now();
    return _database.insertRelationship(
      NoteRelationshipsTableCompanion.insert(
        id: _uuid.v4(),
        bookId: bookId,
        sourceNoteId: sourceNoteId,
        targetNoteId: targetNoteId,
        relationshipType: trimmedType,
        description: Value(description.trim()),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<NoteRelationship> update(NoteRelationship relationship) {
    if (relationship.sourceNoteId == relationship.targetNoteId) {
      throw ArgumentError('A note cannot relate to itself.');
    }
    return _database.updateRelationship(
      NoteRelationshipsTableCompanion(
        id: Value(relationship.id),
        bookId: Value(relationship.bookId),
        sourceNoteId: Value(relationship.sourceNoteId),
        targetNoteId: Value(relationship.targetNoteId),
        relationshipType: Value(relationship.relationshipType.trim()),
        description: Value(relationship.description.trim()),
        createdAt: Value(relationship.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _database.deleteRelationship(id);
}
