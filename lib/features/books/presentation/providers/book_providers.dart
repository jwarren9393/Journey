import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/repositories/book_repository.dart';

final booksStreamProvider = StreamProvider<List<Book>>((ref) {
  return ref.watch(bookRepositoryProvider).watchAll();
});

final bookProvider = FutureProvider.family<Book?, String>((ref, bookId) {
  return ref.watch(bookRepositoryProvider).getById(bookId);
});

extension BookRepositoryReader on WidgetRef {
  BookRepository get books => read(bookRepositoryProvider);
}
