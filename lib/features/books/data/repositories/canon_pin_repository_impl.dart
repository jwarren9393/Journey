import 'package:journey/core/database/app_database.dart';
import 'package:journey/features/books/domain/models/canon_pin.dart';
import 'package:journey/features/books/domain/repositories/canon_pin_repository.dart';
import 'package:uuid/uuid.dart';

class CanonPinRepositoryImpl implements CanonPinRepository {
  CanonPinRepositoryImpl(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  @override
  Stream<List<CanonPin>> watchByBookId(String bookId) {
    return _database.watchCanonPinsByBookId(bookId);
  }

  @override
  Future<CanonPin> create({
    required String bookId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Canon pin text cannot be empty.');
    }

    return _database.insertCanonPin(
      CanonPinsTableCompanion.insert(
        id: _uuid.v4(),
        bookId: bookId,
        pinText: trimmed,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> delete(String id) => _database.deleteCanonPin(id);
}
