import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/models/note_status.dart';

class TriggeredNotesResult {
  const TriggeredNotesResult({
    required this.notes,
    required this.triggeredTitles,
  });

  final List<BookNote> notes;
  final List<String> triggeredTitles;
}

abstract final class NoteContextService {
  static const _stopWords = {
    'a',
    'an',
    'and',
    'are',
    'as',
    'at',
    'be',
    'but',
    'by',
    'for',
    'from',
    'had',
    'has',
    'have',
    'he',
    'her',
    'him',
    'his',
    'how',
    'i',
    'if',
    'in',
    'into',
    'is',
    'it',
    'its',
    'of',
    'on',
    'or',
    'she',
    'that',
    'the',
    'their',
    'them',
    'then',
    'there',
    'they',
    'this',
    'to',
    'was',
    'were',
    'what',
    'when',
    'where',
    'which',
    'who',
    'why',
    'with',
    'you',
    'your',
  };

  static const _defaultCharBudget = 6000;

  static List<BookNote> findRelevantNotes(
    List<BookNote> allNotes,
    String query, {
    int limit = 8,
  }) {
    return findTriggeredNotes(allNotes, query, limit: limit).notes;
  }

  /// Keyword-triggered lore with always-include notes, priority, and budget.
  static TriggeredNotesResult findTriggeredNotes(
    List<BookNote> allNotes,
    String scanText, {
    int limit = 12,
    int charBudget = _defaultCharBudget,
  }) {
    final terms = _tokenize(scanText);
    final scored = <({BookNote note, int score, bool keywordHit})>[];

    for (final note in allNotes) {
      if (note.status == NoteStatus.spark && !note.loreAlwaysInclude) {
        continue;
      }

      if (note.loreAlwaysInclude) {
        scored.add((note: note, score: 1000 + note.lorePriority, keywordHit: false));
        continue;
      }

      var score = note.lorePriority;
      var keywordHit = false;

      for (final keyword in note.keywordList) {
        final keywordLower = keyword.toLowerCase();
        if (terms.contains(keywordLower) ||
            scanText.toLowerCase().contains(keywordLower)) {
          score += 20;
          keywordHit = true;
        }
      }

      if (terms.isNotEmpty) {
        score += _scoreNote(note, terms);
        if (score > note.lorePriority) {
          keywordHit = true;
        }
      }

      if (keywordHit || note.loreAlwaysInclude) {
        scored.add((note: note, score: score, keywordHit: keywordHit));
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));

    final selected = <BookNote>[];
    final triggeredTitles = <String>[];
    var usedChars = 0;

    for (final entry in scored) {
      if (selected.length >= limit) {
        break;
      }

      final noteChars = entry.note.content.length + entry.note.title.length + 32;
      if (usedChars + noteChars > charBudget && selected.isNotEmpty) {
        continue;
      }

      selected.add(entry.note);
      usedChars += noteChars;
      if (entry.keywordHit || entry.note.loreAlwaysInclude) {
        triggeredTitles.add(entry.note.title);
      }
    }

    if (selected.isEmpty && terms.isNotEmpty) {
      final fallback = findRelevantNotesLegacy(allNotes, scanText, limit: limit);
      return TriggeredNotesResult(
        notes: fallback,
        triggeredTitles: fallback.map((note) => note.title).toList(),
      );
    }

    return TriggeredNotesResult(
      notes: selected,
      triggeredTitles: triggeredTitles,
    );
  }

  static List<BookNote> findRelevantNotesLegacy(
    List<BookNote> allNotes,
    String query, {
    int limit = 8,
  }) {
    final terms = _tokenize(query);
    if (terms.isEmpty) {
      return allNotes.take(limit).toList();
    }

    final scored = <({BookNote note, int score})>[];
    for (final note in allNotes) {
      final score = _scoreNote(note, terms);
      if (score > 0) {
        scored.add((note: note, score: score));
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(limit).map((entry) => entry.note).toList();
  }

  static List<BookNote> notesForContinuityCheck(
    List<BookNote> allNotes,
    Chapter chapter, {
    int limit = 15,
  }) {
    final worldbuilding = allNotes
        .where((note) => note.type.isWorldbuilding)
        .toList();

    return findTriggeredNotes(
      worldbuilding,
      chapter.content,
      limit: limit,
    ).notes;
  }

  static String formatNotesForPrompt(List<BookNote> notes) {
    if (notes.isEmpty) {
      return '(No worldbuilding notes provided.)';
    }

    final buffer = StringBuffer();
    for (final note in notes) {
      final details = note.content.trim().isEmpty
          ? '(no details yet)'
          : note.content.trim();
      buffer.writeln('[${note.type.label} · ${note.status.label}] ${note.title}');
      buffer.writeln(details);
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  static String formatBookContext({
    required String authorsNote,
    required String canonSummary,
  }) {
    final buffer = StringBuffer();
    if (authorsNote.trim().isNotEmpty) {
      buffer.writeln("AUTHOR'S NOTE (style guide for this book):");
      buffer.writeln(authorsNote.trim());
      buffer.writeln();
    }
    if (canonSummary.trim().isNotEmpty) {
      buffer.writeln('CANON SUMMARY (established facts):');
      buffer.writeln(canonSummary.trim());
      buffer.writeln();
    }

    final result = buffer.toString().trim();
    return result.isEmpty ? '' : '$result\n\n';
  }

  static Set<String> existingNoteTitles(List<BookNote> notes) {
    return notes.map((note) => note.title.trim()).toSet();
  }

  static int _scoreNote(BookNote note, Set<String> terms) {
    final title = note.title.toLowerCase();
    final content = note.content.toLowerCase();
    var score = 0;

    for (final term in terms) {
      if (title.contains(term)) {
        score += 4;
      }
      if (content.contains(term)) {
        score += 1;
      }
    }

    return score;
  }

  static Set<String> _tokenize(String text) {
    final matches = RegExp(r"[a-z0-9']+").allMatches(text.toLowerCase());
    return matches
        .map((match) => match.group(0)!)
        .where((term) => term.length > 2 && !_stopWords.contains(term))
        .toSet();
  }
}
