import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/book_tag.dart';
import 'package:journey/features/books/domain/repositories/tag_repository.dart';

final tagsStreamProvider =
    StreamProvider.family<List<BookTag>, String>((ref, bookId) {
  return ref.watch(tagRepositoryProvider).watchByBookId(bookId);
});

extension TagRepositoryReader on WidgetRef {
  TagRepository get tags => read(tagRepositoryProvider);
}
