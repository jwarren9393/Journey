import 'package:journey/core/database/app_database.dart';
import 'package:journey/features/books/domain/models/story_lab_draft.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';
import 'package:journey/features/books/domain/repositories/story_lab_repository.dart';
import 'package:uuid/uuid.dart';

class StoryLabRepositoryImpl implements StoryLabRepository {
  StoryLabRepositoryImpl(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  @override
  Stream<List<StoryLabMessage>> watchByBookId(String bookId) {
    return _database.watchStoryLabMessagesByBookId(bookId);
  }

  @override
  Future<StoryLabMessage> addMessage({
    required String bookId,
    required StoryLabRole role,
    required String content,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Message content cannot be empty.');
    }

    return _database.insertStoryLabMessage(
      StoryLabMessagesTableCompanion.insert(
        id: _uuid.v4(),
        bookId: bookId,
        role: role.storageValue,
        content: trimmed,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> clearMessages(String bookId) {
    return _database.deleteStoryLabMessagesForBook(bookId);
  }

  @override
  Future<StoryLabDraft> getDraft(String bookId) async {
    final json = await _database.getStoryLabDraft(bookId);
    return StoryLabDraft.decode(json);
  }

  @override
  Future<void> saveDraft(String bookId, StoryLabDraft draft) {
    return _database.saveStoryLabDraft(bookId, draft.encode());
  }
}
