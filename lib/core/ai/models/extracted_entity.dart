import 'package:journey/features/books/domain/models/note_type.dart';

class ExtractedEntity {
  const ExtractedEntity({
    required this.name,
    required this.suggestedType,
    required this.description,
  });

  final String name;
  final NoteType suggestedType;
  final String description;
}
