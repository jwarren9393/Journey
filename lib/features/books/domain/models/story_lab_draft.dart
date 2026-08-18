import 'dart:convert';

import 'package:journey/core/ai/models/grow_option.dart';
import 'package:journey/core/ai/models/world_spark.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

class StoryLabDraft {
  const StoryLabDraft({
    this.seed = '',
    this.sparks = const [],
    this.growType,
    this.growFocus = '',
    this.growOptions = const [],
    this.composer = '',
  });

  static const empty = StoryLabDraft();
  static const _unset = Object();

  final String seed;
  final List<WorldSpark> sparks;
  final NoteType? growType;
  final String growFocus;
  final List<GrowOption> growOptions;
  final String composer;

  StoryLabDraft copyWith({
    String? seed,
    List<WorldSpark>? sparks,
    Object? growType = _unset,
    String? growFocus,
    List<GrowOption>? growOptions,
    String? composer,
  }) {
    return StoryLabDraft(
      seed: seed ?? this.seed,
      sparks: sparks ?? this.sparks,
      growType: identical(growType, _unset)
          ? this.growType
          : growType as NoteType?,
      growFocus: growFocus ?? this.growFocus,
      growOptions: growOptions ?? this.growOptions,
      composer: composer ?? this.composer,
    );
  }

  String encode() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    return {
      'seed': seed,
      'sparks': sparks.map((spark) => spark.toJson()).toList(),
      'growType': growType?.storageValue,
      'growFocus': growFocus,
      'growOptions': growOptions.map((option) => option.toJson()).toList(),
      'composer': composer,
    };
  }

  static StoryLabDraft decode(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return empty;
    }
    try {
      final json = jsonDecode(trimmed);
      if (json is! Map<String, dynamic>) {
        return empty;
      }
      return StoryLabDraft.fromJson(json);
    } catch (_) {
      return empty;
    }
  }

  factory StoryLabDraft.fromJson(Map<String, dynamic> json) {
    final growType = json['growType'] as String?;
    return StoryLabDraft(
      seed: json['seed'] as String? ?? '',
      sparks: (json['sparks'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(WorldSpark.fromJson)
          .toList(),
      growType: growType == null || growType.isEmpty
          ? null
          : NoteType.fromStorage(growType),
      growFocus: json['growFocus'] as String? ?? '',
      growOptions: (json['growOptions'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(GrowOption.fromJson)
          .toList(),
      composer: json['composer'] as String? ?? '',
    );
  }
}
