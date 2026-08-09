import 'package:journey/core/ai/models/extracted_entity.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/chapter.dart';

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

  /// Chapters scanned for [AiAction.extractEntities] or [AiAction.pacingHeatmap].
  final List<Chapter> recentChapters;

  /// Plot bridge: chapter N (manuscript before the gap).
  final Chapter? plotBridgeBefore;

  /// Plot bridge: chapter N+1 (the chapter to bridge into).
  final Chapter? plotBridgeTarget;

  /// Plot bridge: chapter N+2 (planned destination after the gap).
  final Chapter? plotBridgeAfter;
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
  extractEntities,
  askWorldBible,
  pacingHeatmap,
  plotBridge,
  blurbPitchGenerator,
}

class AiResult {
  const AiResult({
    required this.text,
    required this.action,
    this.isStub = false,
    this.extractedEntities = const [],
    this.pacingLabels = const {},
  });

  final String text;
  final AiAction action;
  final bool isStub;
  final List<ExtractedEntity> extractedEntities;
  final Map<String, String> pacingLabels;
}
