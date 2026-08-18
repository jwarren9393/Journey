import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/models/continuity_fix.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/core/utils/error_messages.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';

Future<void> showContinuityFixSheet({
  required BuildContext context,
  required String bookId,
  required Future<AiResult> resultFuture,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _ContinuityFixSheet(
        bookId: bookId,
        resultFuture: resultFuture,
      );
    },
  );
}

class _ContinuityFixSheet extends ConsumerStatefulWidget {
  const _ContinuityFixSheet({
    required this.bookId,
    required this.resultFuture,
  });

  final String bookId;
  final Future<AiResult> resultFuture;

  @override
  ConsumerState<_ContinuityFixSheet> createState() =>
      _ContinuityFixSheetState();
}

class _ContinuityFixSheetState extends ConsumerState<_ContinuityFixSheet> {
  final _selected = <String>{};
  bool _isApplying = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Fix continuity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Review proposed note updates before applying. Nothing changes until you confirm.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            FutureBuilder<AiResult>(
              future: widget.resultFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Text(
                    userFacingErrorMessage(snapshot.error!),
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  );
                }

                final fixes = snapshot.data!.continuityFixes;
                if (fixes.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        snapshot.data!.text.trim().isEmpty
                            ? 'No fixes suggested — your notes look consistent.'
                            : snapshot.data!.text,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  );
                }

                if (_selected.isEmpty) {
                  _selected.addAll(fixes.map((fix) => fix.noteId));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: fixes.length,
                        separatorBuilder: (_, _) => const Divider(height: 20),
                        itemBuilder: (context, index) {
                          final fix = fixes[index];
                          return _FixTile(
                            fix: fix,
                            selected: _selected.contains(fix.noteId),
                            onChanged: (selected) {
                              setState(() {
                                if (selected) {
                                  _selected.add(fix.noteId);
                                } else {
                                  _selected.remove(fix.noteId);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isApplying
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: _isApplying || _selected.isEmpty
                                ? null
                                : () => _applyFixes(fixes),
                            child: _isApplying
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text('Apply (${_selected.length})'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applyFixes(List<ContinuityFix> fixes) async {
    setState(() => _isApplying = true);

    try {
      final noteRepo = ref.read(noteRepositoryProvider);
      for (final fix in fixes) {
        if (!_selected.contains(fix.noteId)) {
          continue;
        }

        final note = await noteRepo.getById(fix.noteId);
        if (note == null) {
          continue;
        }

        await noteRepo.update(note.copyWith(content: fix.proposedContent));
      }

      ref.invalidate(notesStreamProvider(NotesQuery(bookId: widget.bookId)));

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Note updates applied.')),
        );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(userFacingErrorMessage(error))),
        );
    } finally {
      if (mounted) {
        setState(() => _isApplying = false);
      }
    }
  }
}

class _FixTile extends StatelessWidget {
  const _FixTile({
    required this.fix,
    required this.selected,
    required this.onChanged,
  });

  final ContinuityFix fix;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: selected,
          onChanged: (value) => onChanged(value ?? false),
          title: Text(fix.noteTitle),
          subtitle: Text(fix.reason),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 4),
        Text(
          'Proposed note body:',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        SelectableText(fix.proposedContent),
      ],
    );
  }
}
