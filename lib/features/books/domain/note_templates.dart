import 'package:journey/features/books/domain/models/note_type.dart';

/// Scaffolding headings inserted when creating or expanding a note by type.
abstract final class NoteTemplates {
  static bool hasTemplate(NoteType type) => templateFor(type) != null;

  static String? templateFor(NoteType type) {
    return switch (type) {
      NoteType.character => '''
## Motivations


## Secret / Fear


## Alliances / Enmities


## Fatal Flaw

''',
      NoteType.group => '''
## Core Doctrine


## Primary Asset / Resource


## Chief Rival


## Internal Tension

''',
      NoteType.location => '''
## Sensory Atmosphere


## Strategic Importance


## Cultural / Taboo Rules

''',
      NoteType.item => '''
## Origin


## Rules of Use


## Cost / Consequence of Use

''',
      NoteType.history => '''
## Key Catalysts


## Main Factions Involved


## Long-term Ramifications

''',
      NoteType.plot => '''
## Key Catalysts


## Main Factions Involved


## Long-term Ramifications

''',
      _ => null,
    };
  }

  /// Merge template into existing content without duplicating headings.
  static String insertTemplate(NoteType type, String existing) {
    final template = templateFor(type);
    if (template == null) {
      return existing;
    }
    final trimmed = existing.trim();
    if (trimmed.isEmpty) {
      return template.trimRight();
    }
    // Skip if the first heading already appears.
    final firstHeading = template
        .split('\n')
        .map((line) => line.trim())
        .firstWhere((line) => line.startsWith('## '), orElse: () => '');
    if (firstHeading.isNotEmpty && trimmed.contains(firstHeading)) {
      return existing;
    }
    return '$trimmed\n\n${template.trimRight()}';
  }
}
