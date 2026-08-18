import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/note_context_service.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/models/canon_pin.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';

/// Assembles AI context with triggered lore and book-level guides.
abstract final class AiContextBuilder {
  static AiContext forEditorAction({
    required Book? book,
    required Chapter? chapter,
    required List<BookNote> allNotes,
    String? selectedText,
    bool requestVariants = false,
    int variantCount = 3,
    Chapter? referenceChapter,
    String? userPrompt,
    SensorySense sensorySense = SensorySense.auto,
  }) {
    final scanText = _scanText(chapter: chapter, selectedText: selectedText);
    final triggered = NoteContextService.findTriggeredNotes(
      allNotes,
      scanText,
    );

    return AiContext(
      book: book,
      chapter: chapter,
      selectedText: selectedText,
      notes: triggered.notes,
      referenceChapter: referenceChapter,
      userPrompt: userPrompt,
      sensorySense: sensorySense,
      requestVariants: requestVariants,
      variantCount: variantCount,
      triggeredNoteTitles: triggered.triggeredTitles,
    );
  }

  static AiContext forContinuity({
    required Book? book,
    required Chapter chapter,
    required List<BookNote> allNotes,
  }) {
    final worldbuilding = allNotes
        .where(
          (note) =>
              note.type.isWorldbuilding &&
              (note.status != NoteStatus.spark || note.loreAlwaysInclude),
        )
        .toList();

    final triggered = NoteContextService.findTriggeredNotes(
      worldbuilding,
      chapter.content,
      limit: 15,
    );

    return AiContext(
      book: book,
      chapter: chapter,
      notes: triggered.notes,
      triggeredNoteTitles: triggered.triggeredTitles,
    );
  }

  static AiContext forWorldBible({
    required Book? book,
    required String question,
    required List<BookNote> allNotes,
    Chapter? chapter,
  }) {
    final triggered = NoteContextService.findTriggeredNotes(
      allNotes,
      '$question ${chapter?.content ?? ''}',
      limit: 10,
    );

    return AiContext(
      book: book,
      chapter: chapter,
      userPrompt: question,
      notes: triggered.notes,
      triggeredNoteTitles: triggered.triggeredTitles,
    );
  }

  static AiContext forCanonUpdate({
    required Book book,
    required List<Chapter> chapters,
    Chapter? focusChapter,
  }) {
    return AiContext(
      book: book,
      chapter: focusChapter,
      recentChapters: chapters,
    );
  }

  static AiContext forStoryLab({
    required Book book,
    required List<StoryLabMessage> messages,
    required List<CanonPin> canonPins,
    required List<BookNote> allNotes,
    String? userMessage,
  }) {
    final scanText = [
      userMessage ?? '',
      ...messages.map((message) => message.content),
      book.storyLabSummary,
    ].join('\n');

    final triggered = NoteContextService.findTriggeredNotes(
      allNotes,
      scanText,
      limit: 8,
    );

    return AiContext(
      book: book,
      userPrompt: userMessage,
      notes: triggered.notes,
      canonPins: canonPins,
      storyLabMessages: messages,
      triggeredNoteTitles: triggered.triggeredTitles,
    );
  }

  static String _scanText({
    required Chapter? chapter,
    String? selectedText,
  }) {
    final buffer = StringBuffer();
    if (selectedText != null && selectedText.trim().isNotEmpty) {
      buffer.writeln(selectedText);
    }
    if (chapter != null && chapter.content.trim().isNotEmpty) {
      buffer.write(chapter.content);
    }
    return buffer.toString();
  }

  static AiContext forFoundations({
    required Book book,
    required List<BookNote> allNotes,
    String? userPrompt,
    NoteType? growType,
  }) {
    final usable = allNotes
        .where(
          (note) =>
              note.status != NoteStatus.spark || note.loreAlwaysInclude,
        )
        .toList();

    return AiContext(
      book: book,
      userPrompt: userPrompt,
      notes: usable,
      growType: growType,
    );
  }
}
