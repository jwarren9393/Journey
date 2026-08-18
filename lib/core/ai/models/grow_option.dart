import 'package:journey/features/books/domain/models/note_type.dart';

class GrowOption {
  const GrowOption({
    required this.name,
    required this.type,
    required this.description,
    required this.keywords,
  });

  final String name;
  final NoteType type;
  final String description;
  final String keywords;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.storageValue,
      'description': description,
      'keywords': keywords,
    };
  }

  factory GrowOption.fromJson(Map<String, dynamic> json) {
    return GrowOption(
      name: json['name'] as String? ?? '',
      type: NoteType.fromStorage(json['type'] as String? ?? 'idea'),
      description: json['description'] as String? ?? '',
      keywords: json['keywords'] as String? ?? '',
    );
  }

  String get loreKeywords {
    final fromAi = keywords
        .split(',')
        .map((keyword) => keyword.trim())
        .where((keyword) => keyword.isNotEmpty)
        .toList();
    if (fromAi.isEmpty) {
      return name.trim();
    }
    if (!fromAi.any((keyword) => keyword.toLowerCase() == name.toLowerCase())) {
      return [name.trim(), ...fromAi].join(', ');
    }
    return fromAi.join(', ');
  }
}
