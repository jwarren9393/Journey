import 'dart:convert';

import 'package:journey/features/books/domain/models/chapter.dart';

abstract final class PacingLabelParser {
  static Map<String, String> parse(String raw, List<Chapter> chapters) {
    final jsonText = _extractJsonArray(raw);
    if (jsonText == null) {
      return {};
    }

    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is! List) {
        return {};
      }

      final titleToId = {
        for (final chapter in chapters)
          chapter.title.trim().toLowerCase(): chapter.id,
      };

      final labels = <String, String>{};
      for (final item in decoded) {
        if (item is! Map) {
          continue;
        }

        final title = _readString(item['title']);
        final label = _readString(item['label']);
        if (title == null || label == null) {
          continue;
        }

        final chapterId = titleToId[title.toLowerCase()];
        if (chapterId != null) {
          labels[chapterId] = label;
        }
      }

      return labels;
    } on FormatException {
      return {};
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
}
