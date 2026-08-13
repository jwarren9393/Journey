import 'dart:convert';

import 'package:journey/core/ai/models/extracted_entity.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

abstract final class ExtractedEntityParser {
  static List<ExtractedEntity> parse(
    String raw, {
    Set<String> existingNoteTitles = const {},
  }) {
    final jsonText = _extractJsonArray(raw);
    if (jsonText == null) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is! List) {
        return [];
      }

      final existing = existingNoteTitles
          .map((title) => title.trim().toLowerCase())
          .where((title) => title.isNotEmpty)
          .toSet();

      final entities = <ExtractedEntity>[];
      for (final item in decoded) {
        if (item is! Map) {
          continue;
        }

        final name = _readString(item['name']);
        if (name == null || name.isEmpty) {
          continue;
        }
        if (existing.contains(name.toLowerCase())) {
          continue;
        }

        entities.add(
          ExtractedEntity(
            name: name,
            suggestedType: parseType(_readString(item['type'])),
            description: _readString(item['description']) ?? '',
          ),
        );
      }

      return entities;
    } on FormatException {
      return [];
    }
  }

  static String? _extractJsonArray(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('[')) {
      return trimmed;
    }

    final fenceMatch = RegExp(
      r'```(?:json)?\s*(\[[\s\S]*?\])\s*```',
      multiLine: true,
    ).firstMatch(trimmed);
    if (fenceMatch != null) {
      return fenceMatch.group(1);
    }

    final start = trimmed.indexOf('[');
    final end = trimmed.lastIndexOf(']');
    if (start != -1 && end > start) {
      return trimmed.substring(start, end + 1);
    }

    return null;
  }

  static String? _readString(Object? value) {
    if (value is! String) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static NoteType parseType(String? value) {
    return switch (value?.toLowerCase()) {
      'character' => NoteType.character,
      'location' || 'place' => NoteType.location,
      'plot' => NoteType.plot,
      'research' => NoteType.research,
      'item' || 'object' || 'artifact' => NoteType.item,
      'group' || 'family' || 'faction' || 'organization' => NoteType.group,
      'history' || 'timeline' || 'event' => NoteType.history,
      'idea' || 'spark' => NoteType.idea,
      _ => NoteType.general,
    };
  }
}
