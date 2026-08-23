import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/note_relationship.dart';

final noteRelationshipsByBookProvider =
    StreamProvider.family<List<NoteRelationship>, String>((ref, bookId) {
  return ref.watch(noteRelationshipRepositoryProvider).watchByBookId(bookId);
});

final noteRelationshipsByNoteProvider =
    StreamProvider.family<List<NoteRelationship>, String>((ref, noteId) {
  return ref.watch(noteRelationshipRepositoryProvider).watchByNoteId(noteId);
});
