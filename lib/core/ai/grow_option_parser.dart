import 'dart:convert';

import 'package:journey/core/ai/extracted_entity_parser.dart';
import 'package:journey/core/ai/models/grow_option.dart';

abstract final class GrowOptionParser {
  static List<GrowOption> parse(String raw) {
    final jsonText = _extractJsonArray(raw);
    if (jsonText == null) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is! List) {
        return [];
      }

      final options = <GrowOption>[];
      for (final item in decoded) {
        if (item is! Map) {
          continue;
        }

        final name = _readString(item['name']);
        final description = _readString(item['description']);
        if (name == null || description == null) {
          continue;
        }

        options.add(
          GrowOption(
            name: name,
            type: ExtractedEntityParser.parseType(_readString(item['type'])),
            description: description,
            keywords: _readString(item['keywords']) ?? name,
          ),
        );
      }
      return options;
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
}
