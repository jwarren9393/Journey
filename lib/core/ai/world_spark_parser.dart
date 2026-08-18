import 'dart:convert';

import 'package:journey/core/ai/models/world_spark.dart';

abstract final class WorldSparkParser {
  static List<WorldSpark> parse(String raw) {
    final jsonText = _extractJsonArray(raw);
    if (jsonText == null) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is! List) {
        return [];
      }

      final sparks = <WorldSpark>[];
      for (final item in decoded) {
        if (item is! Map) {
          continue;
        }

        final title = _readString(item['title']);
        final picture = _readString(item['picture']);
        if (title == null || picture == null) {
          continue;
        }

        sparks.add(
          WorldSpark(
            title: title,
            vibe: _readString(item['vibe']) ?? '',
            picture: picture,
            wound: _readString(item['wound']) ?? '',
            tone: _readString(item['tone']) ?? '',
            canon: _readStringList(item['canon']),
          ),
        );
      }
      return sparks;
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

  static List<String> _readStringList(Object? value) {
    if (value is! List) {
      return const [];
    }
    return value
        .whereType<String>()
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }
}
