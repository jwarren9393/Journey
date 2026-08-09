import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';

final storyLabMessagesStreamProvider =
    StreamProvider.family<List<StoryLabMessage>, String>((ref, bookId) {
  return ref.watch(storyLabRepositoryProvider).watchByBookId(bookId);
});
