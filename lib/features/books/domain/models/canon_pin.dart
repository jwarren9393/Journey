class CanonPin {
  const CanonPin({
    required this.id,
    required this.bookId,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String bookId;
  final String text;
  final DateTime createdAt;

  CanonPin copyWith({
    String? id,
    String? bookId,
    String? text,
    DateTime? createdAt,
  }) {
    return CanonPin(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
