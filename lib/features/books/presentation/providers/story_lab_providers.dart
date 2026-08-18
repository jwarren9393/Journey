import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/story_lab_draft.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';

final storyLabMessagesStreamProvider =
    StreamProvider.family<List<StoryLabMessage>, String>((ref, bookId) {
  return ref.watch(storyLabRepositoryProvider).watchByBookId(bookId);
});

final storyLabDraftProvider =
    AsyncNotifierProvider.family<StoryLabDraftNotifier, StoryLabDraft, String>(
      StoryLabDraftNotifier.new,
    );

class StoryLabDraftNotifier extends FamilyAsyncNotifier<StoryLabDraft, String> {
  Future<void>? _writeQueue;

  @override
  Future<StoryLabDraft> build(String bookId) {
    return ref.watch(storyLabRepositoryProvider).getDraft(bookId);
  }

  Future<void> patch(StoryLabDraft Function(StoryLabDraft current) update) {
    final previous = _writeQueue;
    final done = () async {
      if (previous != null) {
        await previous;
      }
      final current = state.value ?? StoryLabDraft.empty;
      final next = update(current);
      await ref.read(storyLabRepositoryProvider).saveDraft(arg, next);
      state = AsyncData(next);
    }();
    _writeQueue = done;
    return done;
  }
}
