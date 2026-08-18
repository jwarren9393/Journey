import 'package:flutter_test/flutter_test.dart';
import 'package:journey/core/ai/models/grow_option.dart';
import 'package:journey/core/ai/models/world_spark.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/models/story_lab_draft.dart';

void main() {
  test('StoryLabDraft round-trips sparks, grow options, and prompts', () {
    const spark = WorldSpark(
      title: 'The Forgetting City',
      vibe: 'lonely grandeur',
      picture: 'A city that eats names.',
      wound: 'Nobody can be mourned.',
      tone: 'Quiet.',
      canon: ['Names fade'],
    );
    const option = GrowOption(
      name: 'House Veyra',
      type: NoteType.group,
      description: 'A fading bloodline.',
      keywords: 'Veyra',
    );

    const draft = StoryLabDraft(
      seed: 'lonely grandeur',
      sparks: [spark],
      growType: NoteType.character,
      growFocus: 'the ruling family',
      growOptions: [option],
      composer: 'what if the river remembers?',
    );

    final restored = StoryLabDraft.decode(draft.encode());
    expect(restored.seed, 'lonely grandeur');
    expect(restored.sparks.single.title, 'The Forgetting City');
    expect(restored.sparks.single.canon, ['Names fade']);
    expect(restored.growType, NoteType.character);
    expect(restored.growFocus, 'the ruling family');
    expect(restored.growOptions.single.name, 'House Veyra');
    expect(restored.growOptions.single.type, NoteType.group);
    expect(restored.composer, 'what if the river remembers?');
  });

  test('StoryLabDraft.decode treats empty and invalid JSON as empty', () {
    expect(StoryLabDraft.decode('').seed, isEmpty);
    expect(StoryLabDraft.decode('not json').sparks, isEmpty);
  });
}
