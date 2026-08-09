import 'package:journey/features/books/domain/models/book.dart';

abstract interface class BookRepository {
  Stream<List<Book>> watchAll();

  Future<Book?> getById(String id);

  Future<Book> create({
    required String title,
    String description = '',
    String category = '',
  });

  Future<Book> update(Book book);

  Future<void> delete(String id);
}
