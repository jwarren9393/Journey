import 'dart:convert';

import 'package:journey/core/ai/extracted_entity_parser.dart';
import 'package:journey/core/ai/models/lore_proposal.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/note_relationship.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

abstract final class LoreProposalParser {
  static List<LoreProposal> parse(
    String raw, {
    required List<BookNote> notes,
    List<NoteRelationship> relationships = const [],
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
      final relById = {for (final rel in relationships) rel.id: rel};

      final proposals = <LoreProposal>[];
      var index = 0;
      for (final entry in decoded) {
        if (entry is! Map) {
          continue;
        }
        final map = Map<String, dynamic>.from(entry);

        final kind = _parseKind(map['action'] ?? map['kind']);
        if (kind == null) {
          continue;
        }

        final reason = _readString(map['reason']) ?? 'Suggested lore change';

        if (kind == LoreProposalKind.upsertRelationship ||
            kind == LoreProposalKind.deleteRelationship) {
          final proposal = _parseRelationship(
            kind: kind,
            map: map,
            reason: reason,
            index: index,
            notesByTitle: notesByTitle,
            notesById: notesById,
            relById: relById,
            relationships: relationships,
          );
          if (proposal != null) {
            proposals.add(proposal);
            index++;
          }
          continue;
        }

        final noteIdRaw = _readString(map['noteId']);
        final titleRaw = _readString(map['title'] ?? map['noteTitle']) ?? '';

        BookNote? matched;
        if (noteIdRaw != null && notesById.containsKey(noteIdRaw)) {
          matched = notesById[noteIdRaw];
        } else if (titleRaw.isNotEmpty) {
          matched = notesByTitle[titleRaw.toLowerCase()];
        }

        if (kind == LoreProposalKind.create) {
          final title = titleRaw.isNotEmpty ? titleRaw : null;
          final content = _readString(map['content'] ?? map['proposedContent']);
          if (title == null || content == null) {
            continue;
          }

          final type = ExtractedEntityParser.parseType(_readString(map['type']));
          final status = _parseStatus(_readString(map['status'])) ??
              NoteStatus.draft;
          final keywords =
              _readString(map['keywords'] ?? map['loreKeywords']) ?? title;

          proposals.add(
            LoreProposal(
              id: 'create:$index',
              kind: LoreProposalKind.create,
              title: title,
              type: type,
              status: status == NoteStatus.spark ? NoteStatus.spark : status,
              content: content,
              reason: reason,
              loreKeywords: keywords,
              chronologyOrder: _readDouble(map['chronologyOrder']),
              era: _readString(map['era']),
            ),
          );
          index++;
          continue;
        }

        if (matched == null) {
          continue;
        }

        if (kind == LoreProposalKind.retire) {
          proposals.add(
            LoreProposal(
              id: 'retire:${matched.id}',
              kind: LoreProposalKind.retire,
              noteId: matched.id,
              title: matched.title,
              type: NoteType.idea,
              status: NoteStatus.spark,
              content: matched.content,
              reason: reason,
              loreKeywords: matched.loreKeywords,
            ),
          );
          index++;
          continue;
        }

        final content = _readString(map['content'] ?? map['proposedContent']);
        if (content == null) {
          continue;
        }

        final type = _readString(map['type']) != null
            ? ExtractedEntityParser.parseType(_readString(map['type']))
            : matched.type;
        final status = _parseStatus(_readString(map['status'])) ?? matched.status;
        final keywords =
            _readString(map['keywords'] ?? map['loreKeywords']) ??
                matched.loreKeywords;

        proposals.add(
          LoreProposal(
            id: 'update:${matched.id}:$index',
            kind: LoreProposalKind.update,
            noteId: matched.id,
            title: matched.title,
            type: type,
            status: status,
            content: content,
            reason: reason,
            loreKeywords: keywords.isEmpty ? matched.title : keywords,
            chronologyOrder: _readDouble(map['chronologyOrder']) ??
                matched.chronologyOrder,
            era: _readString(map['era']) ?? matched.era,
          ),
        );
        index++;
      }

      return proposals;
    } catch (_) {
      return [];
    }
  }

  static LoreProposal? _parseRelationship({
    required LoreProposalKind kind,
    required Map<String, dynamic> map,
    required String reason,
    required int index,
    required Map<String, BookNote> notesByTitle,
    required Map<String, BookNote> notesById,
    required Map<String, NoteRelationship> relById,
    required List<NoteRelationship> relationships,
  }) {
    final relId = _readString(map['relationshipId']);
    NoteRelationship? existing;
    if (relId != null && relById.containsKey(relId)) {
      existing = relById[relId];
    }

    BookNote? source = _resolveNote(
      id: _readString(map['sourceNoteId']) ?? existing?.sourceNoteId,
      title: _readString(map['sourceTitle'] ?? map['sourceNoteTitle']),
      notesById: notesById,
      notesByTitle: notesByTitle,
    );
    BookNote? target = _resolveNote(
      id: _readString(map['targetNoteId']) ?? existing?.targetNoteId,
      title: _readString(map['targetTitle'] ?? map['targetNoteTitle']),
      notesById: notesById,
      notesByTitle: notesByTitle,
    );

    if (existing != null && (source == null || target == null)) {
      source ??= notesById[existing.sourceNoteId];
      target ??= notesById[existing.targetNoteId];
    }

    // Match existing by endpoints + type when deleting without id.
    if (existing == null &&
        kind == LoreProposalKind.deleteRelationship &&
        source != null &&
        target != null) {
      final typeHint = _readString(map['relationshipType'])?.toLowerCase();
      for (final rel in relationships) {
        if (rel.sourceNoteId == source.id &&
            rel.targetNoteId == target.id &&
            (typeHint == null ||
                rel.relationshipType.toLowerCase() == typeHint)) {
          existing = rel;
          break;
        }
      }
    }

    if (kind == LoreProposalKind.deleteRelationship) {
      if (existing == null && (source == null || target == null)) {
        return null;
      }
      final rel = existing;
      return LoreProposal(
        id: 'unlink:${rel?.id ?? '$index'}',
        kind: LoreProposalKind.deleteRelationship,
        title: '${source?.title ?? rel?.sourceNoteTitle ?? '?'} → '
            '${target?.title ?? rel?.targetNoteTitle ?? '?'}',
        type: NoteType.general,
        status: NoteStatus.draft,
        content: '',
        reason: reason,
        relationshipId: rel?.id,
        sourceNoteId: source?.id ?? rel?.sourceNoteId,
        targetNoteId: target?.id ?? rel?.targetNoteId,
        sourceNoteTitle: source?.title ?? rel?.sourceNoteTitle ?? '',
        targetNoteTitle: target?.title ?? rel?.targetNoteTitle ?? '',
        relationshipType:
            _readString(map['relationshipType']) ?? rel?.relationshipType ?? '',
      );
    }

    // upsert
    if (source == null || target == null) {
      return null;
    }
    final relType = _readString(map['relationshipType']) ??
        existing?.relationshipType ??
        '';
    if (relType.isEmpty) {
      return null;
    }

    // Prefer matching existing link between same endpoints.
    NoteRelationship? match = existing;
    if (match == null) {
      for (final rel in relationships) {
        if (rel.sourceNoteId == source.id && rel.targetNoteId == target.id) {
          match = rel;
          break;
        }
      }
    }

    return LoreProposal(
      id: 'link:${match?.id ?? '$index'}',
      kind: LoreProposalKind.upsertRelationship,
      title: '${source.title} → ${target.title}',
      type: NoteType.general,
      status: NoteStatus.draft,
      content: '',
      reason: reason,
      relationshipId: match?.id,
      sourceNoteId: source.id,
      targetNoteId: target.id,
      sourceNoteTitle: source.title,
      targetNoteTitle: target.title,
      relationshipType: relType,
      relationshipDescription: _readString(map['description']) ??
          existing?.description ??
          '',
    );
  }

  static BookNote? _resolveNote({
    required String? id,
    required String? title,
    required Map<String, BookNote> notesById,
    required Map<String, BookNote> notesByTitle,
  }) {
    if (id != null && notesById.containsKey(id)) {
      return notesById[id];
    }
    if (title != null && title.trim().isNotEmpty) {
      return notesByTitle[title.trim().toLowerCase()];
    }
    return null;
  }

  static LoreProposalKind? _parseKind(Object? value) {
    final raw = value?.toString().trim().toLowerCase();
    return switch (raw) {
      'create' || 'new' || 'add' => LoreProposalKind.create,
      'update' || 'edit' || 'revise' => LoreProposalKind.update,
      'retire' || 'archive' || 'demote' || 'discard' || 'delete' =>
        LoreProposalKind.retire,
      'upsertrelationship' ||
      'upsert_relationship' ||
      'link' ||
      'relationship' ||
      'setrelationship' ||
      'set_relationship' ||
      'updaterelationship' ||
      'update_relationship' ||
      'createrelationship' ||
      'create_relationship' =>
        LoreProposalKind.upsertRelationship,
      'deleterelationship' ||
      'delete_relationship' ||
      'unlink' ||
      'removerelationship' ||
      'remove_relationship' =>
        LoreProposalKind.deleteRelationship,
      _ => null,
    };
  }

  static NoteStatus? _parseStatus(String? value) {
    if (value == null) {
      return null;
    }
    return switch (value.trim().toLowerCase()) {
      'spark' => NoteStatus.spark,
      'draft' => NoteStatus.draft,
      'canon' => NoteStatus.canon,
      _ => null,
    };
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

  static String? _readString(Object? value) {
    if (value is! String) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static double? _readDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }
}
