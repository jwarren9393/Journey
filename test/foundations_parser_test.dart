import 'package:flutter_test/flutter_test.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/grow_option_parser.dart';
import 'package:journey/core/ai/prompt_templates.dart';
import 'package:journey/core/ai/world_spark_parser.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

void main() {
  test('WorldSparkParser reads fenced JSON portraits', () {
    const raw = '''
```json
[
  {
    "title": "The Forgetting City",
    "vibe": "lonely grandeur",
    "picture": "A city that eats names.",
    "wound": "Nobody can be mourned.",
    "tone": "Quiet, close third person.",
    "canon": ["Names fade after seven days", "The river is older than the city"]
  }
]
```
''';

    final sparks = WorldSparkParser.parse(raw);
    expect(sparks, hasLength(1));
    expect(sparks.first.title, 'The Forgetting City');
    expect(sparks.first.canon, hasLength(2));
    expect(sparks.first.canonBullets, contains('- Names fade after seven days'));
  });

  test('GrowOptionParser maps group and item types', () {
    const raw = '''
[
  {"name": "House Veyra", "type": "family", "description": "A fading bloodline.", "keywords": "Veyra, the House"},
  {"name": "The Hollow Coin", "type": "item", "description": "A coin that remembers.", "keywords": "Hollow Coin"}
]
''';

    final options = GrowOptionParser.parse(raw);
    expect(options, hasLength(2));
    expect(options[0].type, NoteType.group);
    expect(options[1].type, NoteType.item);
    expect(options[0].loreKeywords, contains('House Veyra'));
  });

  test('PromptTemplates foundationsSparks asks for JSON portraits', () {
    final now = DateTime(2026);
    final prompt = PromptTemplates.forAction(
      AiAction.foundationsSparks,
      AiContext(
        book: Book(
          id: 'b1',
          title: 'Untitled',
          description: '',
          category: '',
          authorsNote: '',
          canonSummary: '',
          storyLabSummary: '',
          createdAt: now,
          updatedAt: now,
        ),
        userPrompt: 'lonely grandeur',
      ),
    );

    expect(prompt, contains('lonely grandeur'));
    expect(prompt, contains('"picture"'));
    expect(prompt, contains('JSON array'));
  });

  test('PromptTemplates foundationsGrow includes picture and type', () {
    final now = DateTime(2026);
    final prompt = PromptTemplates.forAction(
      AiAction.foundationsGrow,
      AiContext(
        book: Book(
          id: 'b1',
          title: 'Untitled',
          description: 'A city that forgets names.',
          category: '',
          authorsNote: '',
          canonSummary: '',
          storyLabSummary: '',
          createdAt: now,
          updatedAt: now,
        ),
        growType: NoteType.character,
      ),
    );

    expect(prompt, contains('A city that forgets names.'));
    expect(prompt, contains('character'));
  });
}
