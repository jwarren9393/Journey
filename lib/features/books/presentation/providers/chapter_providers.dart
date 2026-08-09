import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/repositories/chapter_repository.dart';

final chaptersStreamProvider =
    StreamProvider.family<List<Chapter>, String>((ref, bookId) {
  return ref.watch(chapterRepositoryProvider).watchByBookId(bookId);
});

final chapterProvider = FutureProvider.family<Chapter?, String>((ref, chapterId) {
  return ref.watch(chapterRepositoryProvider).getById(chapterId);
});

extension ChapterRepositoryReader on WidgetRef {
  ChapterRepository get chapters => read(chapterRepositoryProvider);
}
