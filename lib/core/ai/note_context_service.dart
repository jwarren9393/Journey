import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

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

  static List<BookNote> findRelevantNotes(
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
        .where(
          (note) =>
              note.type == NoteType.character ||
              note.type == NoteType.location ||
              note.type == NoteType.plot,
        )
        .toList();

    final relevant = findRelevantNotes(
      worldbuilding,
      chapter.content,
      limit: limit,
    );

    final selected = <BookNote>[...relevant];
    final selectedIds = selected.map((note) => note.id).toSet();

    for (final note in worldbuilding) {
      if (selected.length >= limit) {
        break;
      }
      if (!selectedIds.contains(note.id)) {
        selected.add(note);
        selectedIds.add(note.id);
      }
    }

    return selected;
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
      buffer.writeln('[${note.type.label}] ${note.title}');
      buffer.writeln(details);
      buffer.writeln();
    }
    return buffer.toString().trim();
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
