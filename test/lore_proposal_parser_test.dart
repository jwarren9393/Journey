import 'package:flutter_test/flutter_test.dart';
import 'package:journey/core/ai/lore_proposal_parser.dart';
import 'package:journey/core/ai/models/lore_proposal.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

void main() {
  final now = DateTime(2026, 8, 22);
  final notes = [
    BookNote(
      id: 'n1',
      bookId: 'b1',
      type: NoteType.character,
      status: NoteStatus.canon,
      title: 'Mara',
      content: 'A scout with green eyes.',
      attachmentPath: '',
      loreKeywords: 'Mara',
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
      status: NoteStatus.draft,
      title: 'Old Pier',
      content: 'Wooden pier.',
      attachmentPath: '',
      loreKeywords: 'pier',
      loreAlwaysInclude: false,
      lorePriority: 3,
      sortOrder: 1,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  test('parses create, update, and retire proposals', () {
    const raw = '''
```json
[
  {
    "action": "create",
    "title": "River Guild",
    "type": "group",
    "status": "draft",
    "content": "Smugglers who control the pier docks.",
    "keywords": "River Guild, smugglers",
    "reason": "Named in brainstorm"
  },
  {
    "action": "update",
    "title": "Mara",
    "content": "A scout with hazel eyes and a limp.",
    "reason": "Eye color corrected"
  },
  {
    "action": "retire",
    "title": "Old Pier",
    "reason": "Replaced by Harbor Quay"
  },
  {
    "action": "link",
    "sourceTitle": "Mara",
    "targetTitle": "Old Pier",
    "relationshipType": "Ally",
    "description": "Uses the pier as a rendezvous",
    "reason": "Chapter implies alliance"
  }
]
```
''';

    final proposals = LoreProposalParser.parse(raw, notes: notes);

    expect(proposals, hasLength(4));
    expect(proposals[0].kind, LoreProposalKind.create);
    expect(proposals[1].kind, LoreProposalKind.update);
    expect(proposals[2].kind, LoreProposalKind.retire);
    expect(proposals[3].kind, LoreProposalKind.upsertRelationship);
    expect(proposals[3].relationshipType, 'Ally');
    expect(proposals[3].sourceNoteId, 'n1');
    expect(proposals[3].targetNoteId, 'n2');
  });

  test('skips update/retire when title does not match', () {
    const raw = '''
[
  {"action": "update", "title": "Unknown", "content": "x", "reason": "nope"},
  {"action": "create", "title": "New Place", "type": "location", "content": "A cove.", "reason": "ok"}
]
''';

    final proposals = LoreProposalParser.parse(raw, notes: notes);
    expect(proposals, hasLength(1));
    expect(proposals.single.kind, LoreProposalKind.create);
    expect(proposals.single.title, 'New Place');
  });
}
