import 'package:drift/drift.dart';
import 'package:journey/core/database/app_database.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/repositories/book_repository.dart';
import 'package:uuid/uuid.dart';

class BookRepositoryImpl implements BookRepository {
  BookRepositoryImpl(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  @override
  Stream<List<Book>> watchAll() => _database.watchAllBooks();

  @override
  Future<Book?> getById(String id) => _database.getBookById(id);

  @override
  Future<Book> create({
    required String title,
    String description = '',
    String category = '',
  }) {
    final now = DateTime.now();
    final id = _uuid.v4();
    return _database.insertBook(
      BooksTableCompanion.insert(
        id: id,
        title: title.trim(),
        description: Value(description.trim()),
        category: Value(category.trim()),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<Book> update(Book book) {
    return _database.updateBook(
      BooksTableCompanion(
        id: Value(book.id),
        title: Value(book.title.trim()),
        description: Value(book.description.trim()),
        category: Value(book.category.trim()),
        authorsNote: Value(book.authorsNote.trim()),
        canonSummary: Value(book.canonSummary.trim()),
        storyLabSummary: Value(book.storyLabSummary.trim()),
        createdAt: Value(book.createdAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _database.deleteBook(id);
}
