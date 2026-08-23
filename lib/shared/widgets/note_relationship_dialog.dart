import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/core/utils/error_messages.dart';
import 'package:journey/features/books/domain/models/note_relationship.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/note_relationship_providers.dart';
import 'package:journey/shared/widgets/error_state.dart';

Future<void> showNoteRelationshipDialog({
  required BuildContext context,
  required String bookId,
  String? fixedSourceNoteId,
  NoteRelationship? existing,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _NoteRelationshipDialog(
      bookId: bookId,
      fixedSourceNoteId: fixedSourceNoteId,
      existing: existing,
    ),
  );
}

class _NoteRelationshipDialog extends ConsumerStatefulWidget {
  const _NoteRelationshipDialog({
    required this.bookId,
    this.fixedSourceNoteId,
    this.existing,
  });

  final String bookId;
  final String? fixedSourceNoteId;
  final NoteRelationship? existing;

  @override
  ConsumerState<_NoteRelationshipDialog> createState() =>
      _NoteRelationshipDialogState();
}

class _NoteRelationshipDialogState
    extends ConsumerState<_NoteRelationshipDialog> {
  late String? _sourceId;
  late String? _targetId;
  late String _type;
  late final TextEditingController _typeController;
  late final TextEditingController _descriptionController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _sourceId = existing?.sourceNoteId ?? widget.fixedSourceNoteId;
    _targetId = existing?.targetNoteId;
    _type = existing?.relationshipType ?? RelationshipTypes.presets.first;
    _typeController = TextEditingController(text: _type);
    _descriptionController =
        TextEditingController(text: existing?.description ?? '');
  }

  @override
  void dispose() {
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(
      notesStreamProvider(NotesQuery(bookId: widget.bookId)),
    );

    return AlertDialog(
      title: Text(widget.existing == null ? 'Add relationship' : 'Edit relationship'),
      content: notesAsync.when(
        loading: () => const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Text(userFacingErrorMessage(error)),
        data: (notes) {
          if (notes.length < 2) {
            return const Text('Create at least two notes before linking them.');
          }

          return SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _sourceId,
                    decoration: const InputDecoration(
                      labelText: 'From note',
                      border: OutlineInputBorder(),
                    ),
                    items: notes
                        .map(
                          (note) => DropdownMenuItem(
                            value: note.id,
                            child: Text(note.title),
                          ),
                        )
                        .toList(),
                    onChanged: widget.fixedSourceNoteId != null
                        ? null
                        : (value) => setState(() => _sourceId = value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: RelationshipTypes.presets.contains(_type)
                        ? _type
                        : 'Other',
                    decoration: const InputDecoration(
                      labelText: 'Relationship',
                      border: OutlineInputBorder(),
                    ),
                    items: RelationshipTypes.presets
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _type = value;
                        if (value != 'Other') {
                          _typeController.text = value;
                        }
                      });
                    },
                  ),
                  if (_type == 'Other' ||
                      !RelationshipTypes.presets.contains(_typeController.text)) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _typeController,
                      decoration: const InputDecoration(
                        labelText: 'Custom type',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _targetId,
                    decoration: const InputDecoration(
                      labelText: 'To note',
                      border: OutlineInputBorder(),
                    ),
                    items: notes
                        .where((note) => note.id != _sourceId)
                        .map(
                          (note) => DropdownMenuItem(
                            value: note.id,
                            child: Text(note.title),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _targetId = value),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Context (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.existing == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final sourceId = _sourceId;
    final targetId = _targetId;
    final type = _typeController.text.trim().isEmpty
        ? _type
        : _typeController.text.trim();
    if (sourceId == null || targetId == null || type.isEmpty) {
      showAppSnackBar(context, 'Pick both notes and a relationship type.');
      return;
    }

    setState(() => _saving = true);
    try {
      final repo = ref.read(noteRelationshipRepositoryProvider);
      if (widget.existing == null) {
        await repo.create(
          bookId: widget.bookId,
          sourceNoteId: sourceId,
          targetNoteId: targetId,
          relationshipType: type,
          description: _descriptionController.text,
        );
      } else {
        await repo.update(
          widget.existing!.copyWith(
            sourceNoteId: sourceId,
            targetNoteId: targetId,
            relationshipType: type,
            description: _descriptionController.text,
          ),
        );
      }
      ref.invalidate(noteRelationshipsByBookProvider(widget.bookId));
      ref.invalidate(noteRelationshipsByNoteProvider(sourceId));
      ref.invalidate(noteRelationshipsByNoteProvider(targetId));
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

/// Compact list of relationships for a note or book.
class NoteRelationshipsList extends ConsumerWidget {
  const NoteRelationshipsList({
    required this.bookId,
    this.noteId,
    this.compact = false,
    super.key,
  });

  final String bookId;
  final String? noteId;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = noteId == null
        ? ref.watch(noteRelationshipsByBookProvider(bookId))
        : ref.watch(noteRelationshipsByNoteProvider(noteId!));

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Text(userFacingErrorMessage(error)),
      data: (relationships) {
        if (relationships.isEmpty) {
          return Text(
            compact
                ? 'No links yet.'
                : 'No relationships yet. Link characters, places, and factions here.',
            style: Theme.of(context).textTheme.bodySmall,
          );
        }

        return Column(
          children: [
            for (final rel in relationships)
              ListTile(
                dense: compact,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${rel.sourceNoteTitle} → ${rel.targetNoteTitle}',
                ),
                subtitle: Text(
                  rel.description.trim().isEmpty
                      ? rel.relationshipType
                      : '${rel.relationshipType} — ${rel.description}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => showNoteRelationshipDialog(
                        context: context,
                        bookId: bookId,
                        fixedSourceNoteId: noteId,
                        existing: rel,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.link_off),
                      onPressed: () async {
                        try {
                          await ref
                              .read(noteRelationshipRepositoryProvider)
                              .delete(rel.id);
                          ref.invalidate(
                            noteRelationshipsByBookProvider(bookId),
                          );
                        } catch (error) {
                          if (context.mounted) {
                            showErrorSnackBar(context, error);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
