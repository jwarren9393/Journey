import 'package:journey/features/books/domain/models/story_lab_draft.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';

abstract interface class StoryLabRepository {
  Stream<List<StoryLabMessage>> watchByBookId(String bookId);

  Future<StoryLabMessage> addMessage({
    required String bookId,
    required StoryLabRole role,
    required String content,
  });

  Future<void> clearMessages(String bookId);

  Future<StoryLabDraft> getDraft(String bookId);

  Future<void> saveDraft(String bookId, StoryLabDraft draft);
}
