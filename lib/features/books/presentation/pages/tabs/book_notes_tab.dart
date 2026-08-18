import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/ai/ai_book_actions.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/note_search.dart';
import 'package:journey/features/books/presentation/note_presentation.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/tag_providers.dart';
import 'package:journey/shared/widgets/empty_state.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/text_input_dialog.dart';

class BookNotesTab extends ConsumerStatefulWidget {
  const BookNotesTab({required this.bookId, super.key});

  final String bookId;

  @override
  ConsumerState<BookNotesTab> createState() => _BookNotesTabState();
}

class _BookNotesTabState extends ConsumerState<BookNotesTab> {
  final _queryController = TextEditingController();
  String _query = '';
  NoteType? _type;
  NoteStatus? _status;
  String? _tagId;
  NoteSort _sort = NoteSort.updatedDesc;

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

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All types'),
                    selected: _type == null,
                    onSelected: (_) => setState(() => _type = null),
                  ),
                  const SizedBox(width: 8),
                  for (final type in NoteType.values) ...[
                    FilterChip(
                      label: Text(type.label),
                      selected: _type == type,
                      onSelected: (_) => setState(() => _type = type),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All statuses'),
                    selected: _status == null,
                    onSelected: (_) => setState(() => _status = null),
                  ),
                  const SizedBox(width: 8),
                  for (final status in NoteStatus.values) ...[
                    FilterChip(
                      label: Text(status.label),
                      selected: _status == status,
                      onSelected: (_) => setState(() => _status = status),
                    ),
                    const SizedBox(width: 8),
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
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _discoverEntities,
                    icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                    label: const Text('Discover entities'),
                  ),
                ],
              ),
            ),
            tagsAsync.maybeWhen(
              data: (tags) {
                if (tags.isEmpty) {
                  return const SizedBox.shrink();
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All tags'),
                        selected: _tagId == null,
                        onSelected: (_) => setState(() => _tagId = null),
                      ),
                      const SizedBox(width: 8),
                      for (final tag in tags) ...[
                        FilterChip(
                          label: Text(tag.name),
                          selected: _tagId == tag.id,
                          onSelected: (_) => setState(() => _tagId = tag.id),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            Expanded(
              child: notesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorState.fromError(
                  error: error,
                  onRetry: () => ref.invalidate(
                    notesStreamProvider(NotesQuery(bookId: widget.bookId)),
                  ),
                ),
                data: (notes) {
                  final filtered = NoteSearch.filter(
                    notes,
                    query: _query,
                    type: _type,
                    status: _status,
                    tagId: _tagId,
                    sort: _sort,
                  );

                  if (notes.isEmpty) {
                    return EmptyState(
                      icon: Icons.sticky_note_2_outlined,
                      title: 'No notes yet',
                      message:
                          'Start from scratch in Foundations, or jot down characters, places, groups, and history here.',
                      action: FilledButton.icon(
                        onPressed: () => context.push(
                          AppRoutes.storyLab(widget.bookId),
                        ),
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Start from scratch'),
                      ),
                    );
                  }

                  if (filtered.isEmpty) {
                    return const EmptyState(
                      icon: Icons.filter_alt_off_outlined,
                      title: 'Nothing matches',
                      message: 'Try another search, type, status, or tag.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final note = filtered[index];
                      return _NoteCard(
                        note: note,
                        onOpen: () => context.push(
                          AppRoutes.noteEditor(widget.bookId, note.id),
                        ),
                        onDelete: () => _deleteNote(note.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: _showCreateNoteMenu,
            icon: const Icon(Icons.add),
            label: const Text('New note'),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateNoteMenu() async {
    final type = await showDialog<NoteType>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('New note'),
        children: [
          for (final noteType in NoteType.values)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(noteType),
              child: Text(noteType.label),
            ),
        ],
      ),
    );
    if (type != null) {
      await _createNote(type);
    }
  }

  Future<void> _createNote(NoteType type) async {
    final title = await showTextInputDialog(
      context: context,
      title: 'New ${type.label.toLowerCase()} note',
      label: 'Title',
    );
    if (title == null || !mounted) {
      return;
    }

    try {
      final note = await ref.notes.create(
        bookId: widget.bookId,
        type: type,
        title: title,
        loreKeywords: title,
        status: NoteStatus.draft,
      );
      if (!mounted) {
        return;
      }
      context.push(AppRoutes.noteEditor(widget.bookId, note.id));
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _discoverEntities() async {
    final book = await ref.books.getById(widget.bookId);
    final chapters = await ref.read(
      chaptersStreamProvider(widget.bookId).future,
    );
    if (!mounted) {
      return;
    }

    final recent = AiBookActions.recentChapters(chapters);
    await AiBookActions.runExtractEntities(
      context: context,
      ref: ref,
      bookId: widget.bookId,
      chapters: recent,
      book: book,
    );
  }

  Future<void> _deleteNote(String noteId) async {
    try {
      await ref.notes.delete(noteId);
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.onOpen,
    required this.onDelete,
  });

  final BookNote note;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(NotePresentation.iconForType(note.type)),
        title: Text(note.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${note.type.label} · ${note.status.label}'),
            if (note.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  note.tags.map((tag) => tag.name).join(', '),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            if (note.hasAttachment)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text('Has attachment'),
              ),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
        onTap: onOpen,
      ),
    );
  }
}
