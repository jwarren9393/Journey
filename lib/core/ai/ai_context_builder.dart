import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/note_context_service.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/models/canon_pin.dart';
import 'package:journey/features/books/domain/models/note_relationship.dart';
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

  /// Promote brainstorm and/or chapter ideas into structured note proposals.
  ///
  /// Passes all notes for title matching in the parser; the prompt includes
  /// triggered note bodies plus a compact title index of every note.
  static AiContext forPromoteToLore({
    required Book book,
    required List<BookNote> allNotes,
    List<StoryLabMessage> messages = const [],
    List<CanonPin> canonPins = const [],
    List<NoteRelationship> relationships = const [],
    Chapter? chapter,
    String? selectedText,
    String? userPrompt,
  }) {
    final scanText = [
      userPrompt ?? '',
      selectedText ?? '',
      chapter?.content ?? '',
      book.storyLabSummary,
      ...messages.map((message) => message.content),
      ...canonPins.map((pin) => pin.text),
    ].join('\n');

    final triggered = NoteContextService.findTriggeredNotes(
      allNotes,
      scanText,
      limit: 20,
    );

    // Ensure parser can resolve any title the model cites.
    final notesForParser = <BookNote>[
      ...triggered.notes,
      for (final note in allNotes)
        if (!triggered.notes.any((n) => n.id == note.id)) note,
    ];

    return AiContext(
      book: book,
      chapter: chapter,
      selectedText: selectedText,
      userPrompt: userPrompt,
      notes: notesForParser,
      canonPins: canonPins,
      storyLabMessages: messages,
      relationships: relationships,
      triggeredNoteTitles: triggered.triggeredTitles,
    );
  }

  static AiContext forDeepenNote({
    required Book book,
    required BookNote focusNote,
    required List<BookNote> allNotes,
    List<NoteRelationship> relationships = const [],
    String? userPrompt,
  }) {
    final scanText = [
      focusNote.title,
      focusNote.content,
      userPrompt ?? '',
      book.canonSummary,
      book.description,
    ].join('\n');

    final triggered = NoteContextService.findTriggeredNotes(
      allNotes.where((note) => note.id != focusNote.id).toList(),
      scanText,
      limit: 10,
    );

    final notesForParser = <BookNote>[
      focusNote,
      ...triggered.notes,
      for (final note in allNotes)
        if (note.id != focusNote.id &&
            !triggered.notes.any((n) => n.id == note.id))
          note,
    ];

    final relatedLinks = relationships
        .where(
          (rel) =>
              rel.sourceNoteId == focusNote.id ||
              rel.targetNoteId == focusNote.id,
        )
        .toList();

    return AiContext(
      book: book,
      focusNote: focusNote,
      userPrompt: userPrompt,
      notes: notesForParser,
      relationships: relatedLinks,
      triggeredNoteTitles: [
        focusNote.title,
        ...triggered.triggeredTitles,
      ],
    );
  }

  static AiContext forInterrogateLore({
    required Book book,
    required BookNote focusNote,
    required List<BookNote> allNotes,
    List<NoteRelationship> relationships = const [],
    String? userPrompt,
  }) {
    return forDeepenNote(
      book: book,
      focusNote: focusNote,
      allNotes: allNotes,
      relationships: relationships,
      userPrompt: userPrompt,
    );
  }

  static AiContext forEvolveWorldState({
    required Book book,
    required Chapter chapter,
    required List<BookNote> allNotes,
    List<NoteRelationship> relationships = const [],
  }) {
    final triggered = NoteContextService.findTriggeredNotes(
      allNotes,
      chapter.content,
      limit: 20,
    );

    final notesForParser = <BookNote>[
      ...triggered.notes,
      for (final note in allNotes)
        if (!triggered.notes.any((n) => n.id == note.id)) note,
    ];

    return AiContext(
      book: book,
      chapter: chapter,
      notes: notesForParser,
      relationships: relationships,
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
