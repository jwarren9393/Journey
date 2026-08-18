import 'dart:convert';

import 'package:journey/core/ai/models/continuity_fix.dart';
import 'package:journey/features/books/domain/models/book_note.dart';

abstract final class ContinuityFixParser {
  static List<ContinuityFix> parse(
    String raw, {
    required List<BookNote> notes,
  }) {
    final jsonText = _extractJson(raw);
    if (jsonText == null) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is! List<dynamic>) {
        return [];
      }

      final notesByTitle = {
        for (final note in notes) note.title.trim().toLowerCase(): note,
      };
      final notesById = {for (final note in notes) note.id: note};

      final fixes = <ContinuityFix>[];
      for (final entry in decoded) {
        if (entry is! Map<String, dynamic>) {
          continue;
        }

        final noteId = entry['noteId'] as String?;
        final noteTitle = (entry['noteTitle'] as String?)?.trim() ?? '';
        final proposed =
            (entry['proposedContent'] as String?)?.trim() ?? '';
        final reason = (entry['reason'] as String?)?.trim() ?? '';

        if (proposed.isEmpty) {
          continue;
        }

        BookNote? note;
        if (noteId != null && notesById.containsKey(noteId)) {
          note = notesById[noteId];
        } else if (noteTitle.isNotEmpty) {
          note = notesByTitle[noteTitle.toLowerCase()];
        }

        if (note == null) {
          continue;
        }

        fixes.add(
          ContinuityFix(
            noteId: note.id,
            noteTitle: note.title,
            proposedContent: proposed,
            reason: reason.isEmpty ? 'Suggested note update' : reason,
          ),
        );
      }

      return fixes;
    } catch (_) {
      return [];
    }
  }

  static String? _extractJson(String raw) {
    final trimmed = raw.trim();
    final fenceMatch = RegExp(
      r'```(?:json)?\s*([\s\S]*?)```',
      multiLine: true,
    ).firstMatch(trimmed);
    if (fenceMatch != null) {
      return fenceMatch.group(1)?.trim();
    }

    final start = trimmed.indexOf('[');
    final end = trimmed.lastIndexOf(']');
    if (start >= 0 && end > start) {
      return trimmed.substring(start, end + 1);
    }

    return null;
  }
}
