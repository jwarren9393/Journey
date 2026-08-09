import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/canon_pin.dart';

final canonPinsStreamProvider =
    StreamProvider.family<List<CanonPin>, String>((ref, bookId) {
  return ref.watch(canonPinRepositoryProvider).watchByBookId(bookId);
});
