import 'package:journey/core/ai/models/continuity_fix.dart';
import 'package:journey/core/ai/models/extracted_entity.dart';
import 'package:journey/core/ai/models/grow_option.dart';
import 'package:journey/core/ai/models/lore_proposal.dart';
import 'package:journey/core/ai/models/world_spark.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/models/canon_pin.dart';
import 'package:journey/features/books/domain/models/note_relationship.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';

/// Which sense to emphasize for [AiAction.sensoryEnhance].
enum SensorySense {
  auto,
  sight,
  sound,
  smell,
  touch,
  taste,
}

/// Scoped context passed to AI actions. Only include what the action needs.
class AiContext {
  const AiContext({
    this.selectedText,
    this.chapter,
    this.book,
    this.userPrompt,
    this.referenceChapter,
    this.sensorySense = SensorySense.auto,
    this.notes = const [],
    this.recentChapters = const [],
    this.plotBridgeBefore,
    this.plotBridgeTarget,
    this.plotBridgeAfter,
    this.canonPins = const [],
    this.storyLabMessages = const [],
    this.relationships = const [],
    this.growType,
    this.focusNote,
    this.requestVariants = false,
    this.variantCount = 3,
    this.triggeredNoteTitles = const [],
  });

  final String? selectedText;
  final Chapter? chapter;
  final Book? book;

  /// Free-form user input (e.g. voice persona or world-bible question).
  final String? userPrompt;

  /// Reference chapter for [AiAction.toneVoiceMeter].
  final Chapter? referenceChapter;

  /// Target sense for [AiAction.sensoryEnhance].
  final SensorySense sensorySense;

  /// Worldbuilding notes included in continuity / world-bible actions.
  final List<BookNote> notes;

  /// Chapters scanned for entity discovery, pacing, or canon updates.
  final List<Chapter> recentChapters;

  /// Plot bridge: chapter N (manuscript before the gap).
  final Chapter? plotBridgeBefore;

  /// Plot bridge: chapter N+1 (the chapter to bridge into).
  final Chapter? plotBridgeTarget;

  /// Plot bridge: chapter N+2 (planned destination after the gap).
  final Chapter? plotBridgeAfter;

  /// Canon pins from Story Lab for brainstorm context.
  final List<CanonPin> canonPins;

  /// Recent Story Lab messages for brainstorm actions.
  final List<StoryLabMessage> storyLabMessages;

  /// Note relationships for world-state / promote context.
  final List<NoteRelationship> relationships;

  /// Optional note type to grow in Foundations.
  final NoteType? growType;

  /// Primary note for [AiAction.deepenNote].
  final BookNote? focusNote;

  /// When true, selection transforms return multiple variants.
  final bool requestVariants;

  final int variantCount;

  /// Titles of lore notes triggered for this action (for UI feedback only).
  final List<String> triggeredNoteTitles;

  AiContext copyWith({
    String? selectedText,
    Chapter? chapter,
    Book? book,
    String? userPrompt,
    Chapter? referenceChapter,
    SensorySense? sensorySense,
    List<BookNote>? notes,
    List<Chapter>? recentChapters,
    Chapter? plotBridgeBefore,
    Chapter? plotBridgeTarget,
    Chapter? plotBridgeAfter,
    List<CanonPin>? canonPins,
    List<StoryLabMessage>? storyLabMessages,
    List<NoteRelationship>? relationships,
    NoteType? growType,
    BookNote? focusNote,
    bool? requestVariants,
    int? variantCount,
    List<String>? triggeredNoteTitles,
  }) {
    return AiContext(
      selectedText: selectedText ?? this.selectedText,
      chapter: chapter ?? this.chapter,
      book: book ?? this.book,
      userPrompt: userPrompt ?? this.userPrompt,
      referenceChapter: referenceChapter ?? this.referenceChapter,
      sensorySense: sensorySense ?? this.sensorySense,
      notes: notes ?? this.notes,
      recentChapters: recentChapters ?? this.recentChapters,
      plotBridgeBefore: plotBridgeBefore ?? this.plotBridgeBefore,
      plotBridgeTarget: plotBridgeTarget ?? this.plotBridgeTarget,
      plotBridgeAfter: plotBridgeAfter ?? this.plotBridgeAfter,
      canonPins: canonPins ?? this.canonPins,
      storyLabMessages: storyLabMessages ?? this.storyLabMessages,
      relationships: relationships ?? this.relationships,
      growType: growType ?? this.growType,
      focusNote: focusNote ?? this.focusNote,
      requestVariants: requestVariants ?? this.requestVariants,
      variantCount: variantCount ?? this.variantCount,
      triggeredNoteTitles: triggeredNoteTitles ?? this.triggeredNoteTitles,
    );
  }
}

enum AiAction {
  continueWriting,
  rephrase,
  expand,
  tighten,
  summarizeChapter,
  recapBook,
  sensoryEnhance,
  showDontTell,
  toneVoiceMeter,
  continuityCheck,
  fixContinuity,
  extractEntities,
  askWorldBible,
  pacingHeatmap,
  plotBridge,
  blurbPitchGenerator,
  updateCanonSummary,
  scenePaths,
  storyLabBrainstorm,
  storyLabSceneIdeas,
  storyLabGlossary,
  storyLabSummarize,
  foundationsSparks,
  foundationsGrow,
  foundationsOpeningScenes,
  promoteToLore,
  deepenNote,
  interrogateLore,
  evolveWorldState,
}

class AiResult {
  const AiResult({
    required this.text,
    required this.action,
    this.isStub = false,
    this.extractedEntities = const [],
    this.pacingLabels = const {},
    this.variants = const [],
    this.continuityFixes = const [],
    this.worldSparks = const [],
    this.growOptions = const [],
    this.loreProposals = const [],
  });

  final String text;
  final AiAction action;
  final bool isStub;
  final List<ExtractedEntity> extractedEntities;
  final Map<String, String> pacingLabels;
  final List<String> variants;
  final List<ContinuityFix> continuityFixes;
  final List<WorldSpark> worldSparks;
  final List<GrowOption> growOptions;
  final List<LoreProposal> loreProposals;
}
