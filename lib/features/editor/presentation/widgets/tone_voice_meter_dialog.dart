import 'package:flutter/material.dart';
import 'package:journey/features/books/domain/models/chapter.dart';

enum ToneVoiceReferenceMode { chapter, persona }

class ToneVoiceMeterConfig {
  const ToneVoiceMeterConfig.chapter(this.referenceChapter)
      : voicePersona = null,
        mode = ToneVoiceReferenceMode.chapter;

  const ToneVoiceMeterConfig.persona(this.voicePersona)
      : referenceChapter = null,
        mode = ToneVoiceReferenceMode.persona;

  final ToneVoiceReferenceMode mode;
  final Chapter? referenceChapter;
  final String? voicePersona;
}

Future<ToneVoiceMeterConfig?> showToneVoiceMeterDialog({
  required BuildContext context,
  required List<Chapter> chapters,
  required String currentChapterId,
}) {
  return showDialog<ToneVoiceMeterConfig>(
    context: context,
    builder: (context) {
      return _ToneVoiceMeterDialog(
        chapters: chapters,
        currentChapterId: currentChapterId,
      );
    },
  );
}

class _ToneVoiceMeterDialog extends StatefulWidget {
  const _ToneVoiceMeterDialog({
    required this.chapters,
    required this.currentChapterId,
  });

  final List<Chapter> chapters;
  final String currentChapterId;

  @override
  State<_ToneVoiceMeterDialog> createState() => _ToneVoiceMeterDialogState();
}

class _ToneVoiceMeterDialogState extends State<_ToneVoiceMeterDialog> {
  ToneVoiceReferenceMode _mode = ToneVoiceReferenceMode.chapter;
  String? _selectedChapterId;
  final _personaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final candidates = widget.chapters
        .where((chapter) => chapter.id != widget.currentChapterId)
        .toList();
    if (candidates.isNotEmpty) {
      _selectedChapterId = candidates.first.id;
    } else if (widget.chapters.isNotEmpty) {
      _selectedChapterId = widget.chapters.first.id;
    }
  }

  @override
  void dispose() {
    _personaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final referenceChapters = widget.chapters
        .where((chapter) => chapter.id != widget.currentChapterId)
        .toList();

    return AlertDialog(
      title: const Text('Tone & voice meter'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Compare this chapter against a reference scene or target voice.',
            ),
            const SizedBox(height: 16),
            SegmentedButton<ToneVoiceReferenceMode>(
              segments: const [
                ButtonSegment(
                  value: ToneVoiceReferenceMode.chapter,
                  label: Text('Reference chapter'),
                ),
                ButtonSegment(
                  value: ToneVoiceReferenceMode.persona,
                  label: Text('Voice description'),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) {
                setState(() => _mode = selection.first);
              },
            ),
            const SizedBox(height: 16),
            if (_mode == ToneVoiceReferenceMode.chapter) ...[
              if (referenceChapters.isEmpty)
                const Text(
                  'Add another chapter to this book to use as a reference.',
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedChapterId,
                  decoration: const InputDecoration(
                    labelText: 'Reference chapter',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final chapter in referenceChapters)
                      DropdownMenuItem(
                        value: chapter.id,
                        child: Text(chapter.title),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedChapterId = value);
                  },
                ),
            ] else
              TextField(
                controller: _personaController,
                autofocus: true,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Target voice',
                  hintText: 'e.g. lyrical historical fiction, restrained and formal',
                  border: OutlineInputBorder(),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => _submit(referenceChapters),
          child: const Text('Analyze'),
        ),
      ],
    );
  }

  void _submit(List<Chapter> referenceChapters) {
    if (_mode == ToneVoiceReferenceMode.persona) {
      final persona = _personaController.text.trim();
      if (persona.isEmpty) {
        return;
      }
      Navigator.of(context).pop(ToneVoiceMeterConfig.persona(persona));
      return;
    }

    if (referenceChapters.isEmpty || _selectedChapterId == null) {
      return;
    }

    final reference = referenceChapters.firstWhere(
      (chapter) => chapter.id == _selectedChapterId,
    );
    Navigator.of(context).pop(ToneVoiceMeterConfig.chapter(reference));
  }
}
