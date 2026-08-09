import 'package:journey/features/books/domain/models/canon_pin.dart';

abstract interface class CanonPinRepository {
  Stream<List<CanonPin>> watchByBookId(String bookId);

  Future<CanonPin> create({
    required String bookId,
    required String text,
  });

  Future<void> delete(String id);
}
