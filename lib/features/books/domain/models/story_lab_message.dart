enum StoryLabRole {
  user,
  assistant;

  String get storageValue => name;

  static StoryLabRole fromStorage(String value) {
    return StoryLabRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => StoryLabRole.user,
    );
  }
}

class StoryLabMessage {
  const StoryLabMessage({
    required this.id,
    required this.bookId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String bookId;
  final StoryLabRole role;
  final String content;
  final DateTime createdAt;

  StoryLabMessage copyWith({
    String? id,
    String? bookId,
    StoryLabRole? role,
    String? content,
    DateTime? createdAt,
  }) {
    return StoryLabMessage(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
