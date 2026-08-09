import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/utils/debouncer.dart';
import 'package:journey/features/books/domain/models/book_note.dart';
import 'package:journey/features/books/domain/models/book_tag.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/tag_providers.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  const NoteEditorPage({
    required this.bookId,
    required this.noteId,
    super.key,
  });

  final String bookId;
  final String noteId;

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _loreKeywordsController = TextEditingController();
  final _debouncer = Debouncer();

  String? _loadedNoteId;
  NoteType _type = NoteType.general;
  String _attachmentPath = '';
  bool _loreAlwaysInclude = false;
  int _lorePriority = 5;
  List<BookTag> _selectedTags = [];
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  bool _saveFailed = false;

  @override
  void dispose() {
    _debouncer.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _loreKeywordsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(noteProvider(widget.noteId));
    final tagsAsync = ref.watch(tagsStreamProvider(widget.bookId));

    return noteAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorState.fromError(
          error: error,
          onRetry: () => ref.invalidate(noteProvider(widget.noteId)),
        ),
      ),
      data: (note) {
        if (note == null) {
          return const Scaffold(
            body: ErrorState(
              message: 'This note could not be found.',
              icon: Icons.sticky_note_2_outlined,
            ),
          );
        }

        if (_loadedNoteId != note.id) {
          _loadedNoteId = note.id;
          _titleController.text = note.title;
          _contentController.text = note.content;
          _loreKeywordsController.text = note.loreKeywords;
          _type = note.type;
          _attachmentPath = note.attachmentPath;
          _loreAlwaysInclude = note.loreAlwaysInclude;
          _lorePriority = note.lorePriority;
          _selectedTags = List.of(note.tags);
          _hasUnsavedChanges = false;
          _saveFailed = false;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Note'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(child: _saveStatusWidget()),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => _markDirty(note),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<NoteType>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: NoteType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _type = value);
                  _markDirty(note);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                minLines: 10,
                maxLines: null,
                onChanged: (_) => _markDirty(note),
              ),
              const SizedBox(height: 16),
              Text(
                'AI lore triggers',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Used only when you run an AI action — never automatically.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _loreKeywordsController,
                decoration: const InputDecoration(
                  labelText: 'Keywords (comma-separated)',
                  border: OutlineInputBorder(),
                  hintText: 'Marcus, Silver Oak',
                ),
                onChanged: (_) => _markDirty(note),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Always include in AI context'),
                subtitle: const Text('Within token budget when AI runs'),
                value: _loreAlwaysInclude,
                onChanged: (value) {
                  setState(() => _loreAlwaysInclude = value);
                  _markDirty(note);
                },
              ),
              Slider(
                value: _lorePriority.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: 'Priority $_lorePriority',
                onChanged: (value) {
                  setState(() => _lorePriority = value.round());
                  _markDirty(note);
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Priority: $_lorePriority (higher = included first)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 16),
              Text('Tags', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in _selectedTags)
                    InputChip(
                      label: Text(tag.name),
                      onDeleted: () {
                        setState(() {
                          _selectedTags.removeWhere((item) => item.id == tag.id);
                        });
                        _markDirty(note);
                      },
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: const Text('Add tag'),
                    onPressed: () => _addTag(
                      note,
                      tagsAsync.asData?.value ?? [],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Attachment', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              if (_attachmentPath.isNotEmpty)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.attach_file),
                  title: Text(_fileName(_attachmentPath)),
                  trailing: IconButton(
                    tooltip: 'Remove attachment',
                    onPressed: () {
                      setState(() => _attachmentPath = '');
                      _markDirty(note);
                    },
                    icon: const Icon(Icons.close),
                  ),
                  onTap: _openAttachment,
                ),
              OutlinedButton.icon(
                onPressed: () => _pickAttachment(note),
                icon: const Icon(Icons.upload_file),
                label: Text(
                  _attachmentPath.isEmpty ? 'Attach a file' : 'Replace attachment',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _saveStatusWidget() {
    if (_isSaving) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (_saveFailed) {
      return Text(
        'Save failed',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }
    if (_hasUnsavedChanges) {
      return const Text('Unsaved');
    }
    return const Text('Saved');
  }

  void _markDirty(BookNote note) {
    setState(() {
      _hasUnsavedChanges = true;
      _saveFailed = false;
    });
    _debouncer.run(() => _save(note));
  }

  Future<void> _save(BookNote note) async {
    setState(() {
      _isSaving = true;
      _saveFailed = false;
    });

    try {
      final updated = await ref.notes.update(
        note.copyWith(
          title: _titleController.text,
          content: _contentController.text,
          type: _type,
          attachmentPath: _attachmentPath,
          loreKeywords: _loreKeywordsController.text,
          loreAlwaysInclude: _loreAlwaysInclude,
          lorePriority: _lorePriority,
        ),
      );
      await ref.tags.setTagsForNote(
        noteId: updated.id,
        tagIds: _selectedTags.map((tag) => tag.id).toList(),
      );
      ref.invalidate(noteProvider(widget.noteId));

      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
        _hasUnsavedChanges = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
        _hasUnsavedChanges = true;
        _saveFailed = true;
      });
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _addTag(BookNote note, List<BookTag> existingTags) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Tag name',
                ),
              ),
              if (existingTags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Existing',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final tag in existingTags)
                      ActionChip(
                        label: Text(tag.name),
                        onPressed: () =>
                            Navigator.of(context).pop(tag.name),
                      ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (name == null || name.trim().isEmpty) {
      return;
    }

    try {
      final tag = await ref.tags.getOrCreate(
        bookId: widget.bookId,
        name: name.trim(),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        if (!_selectedTags.any((item) => item.id == tag.id)) {
          _selectedTags.add(tag);
        }
      });
      _markDirty(note);
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _pickAttachment(BookNote note) async {
    final result = await FilePicker.pickFiles();
    final path = result?.files.single.path;
    if (path == null) {
      return;
    }

    setState(() => _attachmentPath = path);
    _markDirty(note);
  }

  Future<void> _openAttachment() async {
    if (_attachmentPath.isEmpty) {
      return;
    }

    final uri = Uri.file(_attachmentPath);
    final launched = await launchUrl(uri);
    if (!launched && mounted) {
      showErrorSnackBar(context, 'Could not open attachment.');
    }
  }

  String _fileName(String path) {
  return path.split(Platform.pathSeparator).last;
  }
}
