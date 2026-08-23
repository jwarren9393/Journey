import 'package:flutter_test/flutter_test.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/continuity_fix_parser.dart';
import 'package:journey/core/ai/extracted_entity_parser.dart';
import 'package:journey/core/ai/variants_parser.dart';
import 'package:journey/core/ai/note_context_service.dart';
import 'package:journey/core/ai/pacing_label_parser.dart';
import 'package:journey/core/ai/prompt_templates.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

void main() {
  group('PromptTemplates Phase 5A', () {
    test('sensoryEnhance includes selected text and sense', () {
      final prompt = PromptTemplates.forAction(
        AiAction.sensoryEnhance,
        const AiContext(
          selectedText: 'He walked into the room.',
          sensorySense: SensorySense.sound,
        ),
      );

      expect(prompt, contains('He walked into the room.'));
      expect(prompt, contains('sound and auditory detail'));
    });

    test('showDontTell asks for multiple showing options', () {
      final prompt = PromptTemplates.forAction(
        AiAction.showDontTell,
        const AiContext(selectedText: 'He was terrified.'),
      );

      expect(prompt, contains('He was terrified.'));
      expect(prompt, contains('---VARIANT---'));
      expect(prompt, contains('3 alternative'));
    });

    test('toneVoiceMeter includes reference chapter and current chapter', () {
      final now = DateTime(2026);
      final prompt = PromptTemplates.forAction(
        AiAction.toneVoiceMeter,
        AiContext(
          chapter: Chapter(
            id: 'c1',
            bookId: 'b1',
            title: 'Chapter 3',
            content: 'Current prose here.',
            outlineSummary: '',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
          ),
          referenceChapter: Chapter(
            id: 'c0',
            bookId: 'b1',
            title: 'Chapter 1',
            content: 'Reference prose here.',
            outlineSummary: '',
            sortOrder: 0,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );

      expect(prompt, contains('REFERENCE CHAPTER ("Chapter 1")'));
      expect(prompt, contains('Reference prose here.'));
      expect(prompt, contains('CURRENT CHAPTER ("Chapter 3")'));
      expect(prompt, contains('Current prose here.'));
    });

    test('toneVoiceMeter uses persona when provided', () {
      final now = DateTime(2026);
      final prompt = PromptTemplates.forAction(
        AiAction.toneVoiceMeter,
        AiContext(
          userPrompt: 'lyrical historical fiction',
          chapter: Chapter(
            id: 'c1',
            bookId: 'b1',
            title: 'Chapter 1',
            content: 'Some text.',
            outlineSummary: '',
            sortOrder: 0,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );

      expect(prompt, contains('lyrical historical fiction'));
    });
  });

  group('PromptTemplates Phase 5B', () {
    final now = DateTime(2026);
    final notes = [
      BookNote(
        id: 'n1',
        bookId: 'b1',
        type: NoteType.character,
        title: 'Marcus',
        content: 'Left-handed swordsman with green eyes.',
        attachmentPath: '',
        loreKeywords: '',
        loreAlwaysInclude: false,
        lorePriority: 5,
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('continuityCheck includes notes and chapter', () {
      final prompt = PromptTemplates.forAction(
        AiAction.continuityCheck,
        AiContext(
          chapter: Chapter(
            id: 'c1',
            bookId: 'b1',
            title: 'Chapter 2',
            content: 'Marcus threw a right jab.',
            outlineSummary: '',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
          ),
          notes: notes,
        ),
      );

      expect(prompt, contains('Marcus'));
      expect(prompt, contains('Left-handed'));
      expect(prompt, contains('Marcus threw a right jab.'));
    });

    test('askWorldBible includes question and notes', () {
      final prompt = PromptTemplates.forAction(
        AiAction.askWorldBible,
        AiContext(
          userPrompt: "What color are Marcus's eyes?",
          notes: notes,
        ),
      );

      expect(prompt, contains("What color are Marcus's eyes?"));
      expect(prompt, contains('green eyes'));
    });

    test('extractEntities asks for JSON and existing note titles', () {
      final prompt = PromptTemplates.forAction(
        AiAction.extractEntities,
        AiContext(
          notes: notes,
          recentChapters: [
            Chapter(
              id: 'c1',
              bookId: 'b1',
              title: 'Chapter 2',
              content: 'Elena entered the Silver Oak tavern.',
              outlineSummary: '',
              sortOrder: 1,
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      );

      expect(prompt, contains('JSON array'));
      expect(prompt, contains('Marcus'));
      expect(prompt, contains('Silver Oak tavern'));
    });
  });

  group('NoteContextService', () {
    final now = DateTime(2026);
    final notes = [
      BookNote(
        id: 'n1',
        bookId: 'b1',
        type: NoteType.character,
        title: 'Marcus',
        content: 'Left-handed.',
        attachmentPath: '',
        loreKeywords: '',
        loreAlwaysInclude: false,
        lorePriority: 5,
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
      ),
      BookNote(
        id: 'n2',
        bookId: 'b1',
        type: NoteType.location,
        title: 'Silver Oak',
        content: 'A riverside tavern.',
        attachmentPath: '',
        loreKeywords: '',
        loreAlwaysInclude: false,
        lorePriority: 5,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('findRelevantNotes ranks matching notes higher', () {
      final relevant = NoteContextService.findRelevantNotes(
        notes,
        'Where is the Silver Oak tavern?',
      );

      expect(relevant.first.title, 'Silver Oak');
    });
  });

  group('ExtractedEntityParser', () {
    test('parses JSON array and skips existing titles', () {
      const raw = '''
[
  {"name": "Marcus", "type": "character", "description": "A soldier."},
  {"name": "Elena", "type": "character", "description": "A healer."}
]
''';

      final entities = ExtractedEntityParser.parse(
        raw,
        existingNoteTitles: {'Marcus'},
      );

      expect(entities, hasLength(1));
      expect(entities.first.name, 'Elena');
      expect(entities.first.suggestedType, NoteType.character);
    });

    test('parses fenced JSON', () {
      const raw = '''
```json
[{"name": "North Gate", "type": "location", "description": "City entrance."}]
```
''';

      final entities = ExtractedEntityParser.parse(raw);
      expect(entities.single.name, 'North Gate');
      expect(entities.single.suggestedType, NoteType.location);
    });
  });

  group('PacingLabelParser', () {
    final now = DateTime(2026);
    final chapters = [
      Chapter(
        id: 'c1',
        bookId: 'b1',
        title: 'Chapter 1',
        content: 'A chase through the market.',
        outlineSummary: 'Marcus escapes the guards.',
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
      ),
      Chapter(
        id: 'c2',
        bookId: 'b1',
        title: 'Chapter 2',
        content: 'They talked for hours.',
        outlineSummary: 'Elena and Marcus plan their next move.',
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('maps labels to chapter ids by title', () {
      const raw = '''
[
  {"title": "Chapter 1", "label": "High Action"},
  {"title": "Chapter 2", "label": "Dialogue Heavy"}
]
''';

      final labels = PacingLabelParser.parse(raw, chapters);

      expect(labels['c1'], 'High Action');
      expect(labels['c2'], 'Dialogue Heavy');
    });
  });

  group('PromptTemplates Phase 5C', () {
    final now = DateTime(2026);

    test('pacingHeatmap includes outlines and label list', () {
      final prompt = PromptTemplates.forAction(
        AiAction.pacingHeatmap,
        AiContext(
          recentChapters: [
            Chapter(
              id: 'c1',
              bookId: 'b1',
              title: 'Chapter 1',
              content: 'Action scene.',
              outlineSummary: 'A chase.',
              sortOrder: 0,
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      );

      expect(prompt, contains('High Action'));
      expect(prompt, contains('Outline: A chase.'));
    });

    test('plotBridge includes before, target, and after chapters', () {
      Chapter chapter({
        required String id,
        required String title,
        required String content,
        required String outline,
        required int order,
      }) {
        return Chapter(
          id: id,
          bookId: 'b1',
          title: title,
          content: content,
          outlineSummary: outline,
          sortOrder: order,
          createdAt: now,
          updatedAt: now,
        );
      }

      final prompt = PromptTemplates.forAction(
        AiAction.plotBridge,
        AiContext(
          plotBridgeBefore: chapter(
            id: 'c1',
            title: 'Chapter 1',
            content: 'Marcus fled the city.',
            outline: '',
            order: 0,
          ),
          plotBridgeTarget: chapter(
            id: 'c2',
            title: 'Chapter 2',
            content: '',
            outline: 'Cross the river.',
            order: 1,
          ),
          plotBridgeAfter: chapter(
            id: 'c3',
            title: 'Chapter 3',
            content: '',
            outline: 'Reach the safe house.',
            order: 2,
          ),
        ),
      );

      expect(prompt, contains('Marcus fled the city.'));
      expect(prompt, contains('Cross the river.'));
      expect(prompt, contains('Reach the safe house.'));
      expect(prompt, contains('TARGET CHAPTER N+1'));
    });
  });

  group('PromptTemplates Phase 5D', () {
    final now = DateTime(2026);

    test('blurbPitchGenerator includes book summary and chapter outlines', () {
      final prompt = PromptTemplates.forAction(
        AiAction.blurbPitchGenerator,
        AiContext(
          book: Book(
            id: 'b1',
            title: 'The River Road',
            description: 'A fantasy journey along a forgotten trade route.',
            category: 'Fantasy',
            authorsNote: '',
            canonSummary: '',
            storyLabSummary: '',
            createdAt: now,
            updatedAt: now,
          ),
          recentChapters: [
            Chapter(
              id: 'c1',
              bookId: 'b1',
              title: 'Chapter 1',
              content: '',
              outlineSummary: 'The hero leaves home.',
              sortOrder: 0,
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      );

      expect(prompt, contains('The River Road'));
      expect(prompt, contains('forgotten trade route'));
      expect(prompt, contains('The hero leaves home.'));
      expect(prompt, contains('TAGLINE:'));
      expect(prompt, contains('QUERY PITCH:'));
    });
  });

  group('PromptTemplates Phase 6', () {
    final now = DateTime(2026);

    test('updateCanonSummary includes existing canon and manuscript', () {
      final prompt = PromptTemplates.forAction(
        AiAction.updateCanonSummary,
        AiContext(
          book: Book(
            id: 'b1',
            title: 'Test Book',
            description: '',
            category: '',
            authorsNote: 'Third person past tense.',
            canonSummary: '- Marcus is left-handed.',
            storyLabSummary: '',
            createdAt: now,
            updatedAt: now,
          ),
          recentChapters: [
            Chapter(
              id: 'c1',
              bookId: 'b1',
              title: 'Chapter 1',
              content: 'Marcus threw a punch with his right hand.',
              outlineSummary: '',
              sortOrder: 0,
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      );

      expect(prompt, contains('Third person past tense.'));
      expect(prompt, contains('Marcus is left-handed'));
      expect(prompt, contains('right hand'));
    });

    test('fixContinuity asks for JSON note fixes', () {
      final prompt = PromptTemplates.forAction(
        AiAction.fixContinuity,
        AiContext(
          chapter: Chapter(
            id: 'c1',
            bookId: 'b1',
            title: 'Ch 1',
            content: 'Test',
            outlineSummary: '',
            sortOrder: 0,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );

      expect(prompt, contains('JSON array'));
      expect(prompt, contains('proposedContent'));
    });

    test('promoteToLore includes brainstorm and create/update/retire actions', () {
      final prompt = PromptTemplates.forAction(
        AiAction.promoteToLore,
        AiContext(
          book: Book(
            id: 'b1',
            title: 'Tide',
            description: 'A harbor city.',
            category: '',
            authorsNote: '',
            canonSummary: '- The pier is wood',
            storyLabSummary: '- Guild controls docks',
            createdAt: now,
            updatedAt: now,
          ),
          storyLabMessages: const [],
        ),
      );

      expect(prompt, contains('create'));
      expect(prompt, contains('update'));
      expect(prompt, contains('retire'));
      expect(prompt, contains('STORY LAB SUMMARY'));
      expect(prompt, contains('Guild controls docks'));
    });

    test('deepenNote focuses on the named note', () {
      final prompt = PromptTemplates.forAction(
        AiAction.deepenNote,
        AiContext(
          focusNote: BookNote(
            id: 'n1',
            bookId: 'b1',
            type: NoteType.character,
            status: NoteStatus.draft,
            title: 'Mara',
            content: 'A scout.',
            attachmentPath: '',
            loreKeywords: 'Mara',
            loreAlwaysInclude: false,
            lorePriority: 5,
            sortOrder: 0,
            createdAt: now,
            updatedAt: now,
          ),
          userPrompt: 'Add her family ties',
        ),
      );

      expect(prompt, contains('FOCUS NOTE ("Mara")'));
      expect(prompt, contains('Add her family ties'));
      expect(prompt, contains('"action"'));
    });

    test('scenePaths asks for six beat ideas', () {
      final prompt = PromptTemplates.forAction(
        AiAction.scenePaths,
        AiContext(
          selectedText: 'She reached for the door.',
        ),
      );

      expect(prompt, contains('6 brief beat ideas'));
      expect(prompt, contains('She reached for the door.'));
    });
  });

  group('VariantsParser', () {
    test('splits on variant separator', () {
      const raw = 'First version\n---VARIANT---\nSecond version';
      final variants = VariantsParser.parse(raw);
      expect(variants, hasLength(2));
      expect(variants.first, 'First version');
    });
  });

  group('ContinuityFixParser', () {
    final now = DateTime(2026);
    final notes = [
      BookNote(
        id: 'n1',
        bookId: 'b1',
        type: NoteType.character,
        title: 'Marcus',
        content: 'Left-handed.',
        attachmentPath: '',
        loreKeywords: '',
        loreAlwaysInclude: false,
        lorePriority: 5,
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('parses fix proposals by note title', () {
      const raw = '''
[{"noteTitle": "Marcus", "proposedContent": "Ambidextrous.", "reason": "Chapter shows right hand."}]
''';

      final fixes = ContinuityFixParser.parse(raw, notes: notes);
      expect(fixes, hasLength(1));
      expect(fixes.first.noteId, 'n1');
      expect(fixes.first.proposedContent, 'Ambidextrous.');
    });
  });
}
