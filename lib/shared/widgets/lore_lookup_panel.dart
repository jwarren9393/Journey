import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/book_tag.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/note_search.dart';
import 'package:journey/features/books/presentation/note_presentation.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/tag_providers.dart';
import 'package:journey/shared/widgets/error_state.dart';

Future<void> showLoreLookupSheet({
  required BuildContext context,
  required String bookId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.85,
        child: LoreLookupPanel(bookId: bookId),
      );
    },
  );
}

class LoreLookupPanel extends ConsumerStatefulWidget {
  const LoreLookupPanel({
    required this.bookId,
    this.embedded = false,
    super.key,
  });

  final String bookId;
  final bool embedded;

  @override
  ConsumerState<LoreLookupPanel> createState() => _LoreLookupPanelState();
}

class _LoreLookupPanelState extends ConsumerState<LoreLookupPanel> {
  final _queryController = TextEditingController();
  String _query = '';
  NoteType? _type;
  NoteStatus? _status;
  String? _tagId;
  NoteSort _sort = NoteSort.updatedDesc;
  BookNote? _selected;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(
      notesStreamProvider(NotesQuery(bookId: widget.bookId)),
    );
    final tagsAsync = ref.watch(tagsStreamProvider(widget.bookId));

    return Material(
      color: widget.embedded
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : Theme.of(context).colorScheme.surface,
      child: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState.fromError(
          error: error,
          onRetry: () => ref.invalidate(
            notesStreamProvider(NotesQuery(bookId: widget.bookId)),
          ),
        ),
        data: (notes) {
          final tags = tagsAsync.asData?.value ?? const <BookTag>[];
          final filtered = NoteSearch.filter(
            notes,
            query: _query,
            type: _type,
            status: _status,
            tagId: _tagId,
            sort: _sort,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Text(
                  widget.embedded ? 'Lore' : 'Look up lore',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: SearchBar(
                  controller: _queryController,
                  hintText: 'Search notes, tags, keywords…',
                  leading: const Icon(Icons.search),
                  trailing: _query.isEmpty
                      ? null
                      : [
                          IconButton(
                            tooltip: 'Clear',
                            onPressed: () {
                              _queryController.clear();
                              setState(() {
                                _query = '';
                                _selected = null;
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                  onChanged: (value) => setState(() {
                    _query = value;
                    _selected = null;
                  }),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All types'),
                      selected: _type == null,
                      onSelected: (_) => setState(() {
                        _type = null;
                        _selected = null;
                      }),
                    ),
                    const SizedBox(width: 6),
                    for (final type in NoteType.values) ...[
                      FilterChip(
                        label: Text(type.label),
                        selected: _type == type,
                        onSelected: (_) => setState(() {
                          _type = type;
                          _selected = null;
                        }),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All statuses'),
                      selected: _status == null,
                      onSelected: (_) => setState(() {
                        _status = null;
                        _selected = null;
                      }),
                    ),
                    const SizedBox(width: 6),
                    for (final status in NoteStatus.values) ...[
                      FilterChip(
                        label: Text(status.label),
                        selected: _status == status,
                        onSelected: (_) => setState(() {
                          _status = status;
                          _selected = null;
                        }),
                      ),
                      const SizedBox(width: 6),
                    ],
                    const SizedBox(width: 8),
                    DropdownButton<NoteSort>(
                      value: _sort,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _sort = value);
                      },
                      items: const [
                        DropdownMenuItem(
                          value: NoteSort.updatedDesc,
                          child: Text('Recent'),
                        ),
                        DropdownMenuItem(
                          value: NoteSort.titleAsc,
                          child: Text('Title'),
                        ),
                        DropdownMenuItem(
                          value: NoteSort.typeThenTitle,
                          child: Text('Type'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (tags.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All tags'),
                        selected: _tagId == null,
                        onSelected: (_) => setState(() {
                          _tagId = null;
                          _selected = null;
                        }),
                      ),
                      const SizedBox(width: 6),
                      for (final tag in tags) ...[
                        FilterChip(
                          label: Text(tag.name),
                          selected: _tagId == tag.id,
                          onSelected: (_) => setState(() {
                            _tagId = tag.id;
                            _selected = null;
                          }),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  '${filtered.length} of ${notes.length}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Expanded(
                child: _selected != null
                    ? _NoteDetail(
                        note: _selected!,
                        onBack: () => setState(() => _selected = null),
                        onEdit: () => context.push(
                          AppRoutes.noteEditor(widget.bookId, _selected!.id),
                        ),
                      )
                    : filtered.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'Nothing matches. Try another search or create a note.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final note = filtered[index];
                              return ListTile(
                                leading: Icon(
                                  NotePresentation.iconForType(note.type),
                                ),
                                title: Text(note.title),
                                subtitle: Text(
                                  [
                                    note.type.label,
                                    note.status.label,
                                    if (note.tags.isNotEmpty)
                                      note.tags
                                          .map((tag) => tag.name)
                                          .join(', '),
                                  ].join(' · '),
                                ),
                                onTap: () => setState(() => _selected = note),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoteDetail extends StatelessWidget {
  const _NoteDetail({
    required this.note,
    required this.onBack,
    required this.onEdit,
  });

  final BookNote note;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: IconButton(
            tooltip: 'Back to list',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(note.title),
          subtitle: Text('${note.type.label} · ${note.status.label}'),
          trailing: TextButton(
            onPressed: onEdit,
            child: const Text('Edit'),
          ),
        ),
        if (note.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 6,
              children: [
                for (final tag in note.tags) Chip(label: Text(tag.name)),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              note.content.trim().isEmpty
                  ? '(No details yet)'
                  : note.content,
            ),
          ),
        ),
      ],
    );
  }
}
