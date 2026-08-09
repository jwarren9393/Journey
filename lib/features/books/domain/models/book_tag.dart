class BookTag {
  const BookTag({
    required this.id,
    required this.bookId,
    required this.name,
  });

  final String id;
  final String bookId;
  final String name;

  BookTag copyWith({
    String? id,
    String? bookId,
    String? name,
  }) {
    return BookTag(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
    );
  }
}
