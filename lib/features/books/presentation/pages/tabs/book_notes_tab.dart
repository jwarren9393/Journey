import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/ai/ai_book_actions.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
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
  NoteType? _filter;

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(
      notesStreamProvider(
        NotesQuery(bookId: widget.bookId, type: _filter),
      ),
    );

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _filter == null,
                    onSelected: (_) => setState(() => _filter = null),
                  ),
                  const SizedBox(width: 8),
                  for (final type in NoteType.values) ...[
                    FilterChip(
                      label: Text(type.label),
                      selected: _filter == type,
                      onSelected: (_) => setState(() => _filter = type),
                    ),
                    const SizedBox(width: 8),
                  ],
                  OutlinedButton.icon(
                    onPressed: _discoverEntities,
                    icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                    label: const Text('Discover entities'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: notesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorState.fromError(
                  error: error,
                  onRetry: () => ref.invalidate(
                    notesStreamProvider(
                      NotesQuery(bookId: widget.bookId, type: _filter),
                    ),
                  ),
                ),
                data: (notes) {
                  if (notes.isEmpty) {
                    return EmptyState(
                      icon: Icons.sticky_note_2_outlined,
                      title: 'No notes yet',
                      message: _filter == null
                          ? 'Jot down research, characters, places, or plot ideas.'
                          : 'No ${_filter!.label.toLowerCase()} notes yet.',
                      action: FilledButton.icon(
                        onPressed: () => _createNote(_filter ?? NoteType.general),
                        icon: const Icon(Icons.add),
                        label: const Text('New note'),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(_iconForType(note.type)),
                          title: Text(note.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.type.label),
                              if (note.tags.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    note.tags.map((tag) => tag.name).join(', '),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
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
                            onSelected: (value) async {
                              if (value == 'delete') {
                                await _deleteNote(note.id);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                          onTap: () => context.push(
                            AppRoutes.noteEditor(widget.bookId, note.id),
                          ),
                        ),
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
            onPressed: () => _showCreateNoteMenu(),
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

  IconData _iconForType(NoteType type) {
    return switch (type) {
      NoteType.general => Icons.sticky_note_2_outlined,
      NoteType.research => Icons.link,
      NoteType.character => Icons.person_outline,
      NoteType.location => Icons.place_outlined,
      NoteType.plot => Icons.auto_graph_outlined,
    };
  }
}
