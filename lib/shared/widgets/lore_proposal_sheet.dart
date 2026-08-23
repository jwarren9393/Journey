import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/models/lore_proposal.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/core/theme/app_reading_style.dart';
import 'package:journey/core/utils/error_messages.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/note_relationship_providers.dart';

Future<bool> showLoreProposalSheet({
  required BuildContext context,
  required String bookId,
  required Future<AiResult> resultFuture,
  String title = 'Promote to lore',
  String subtitle =
      'Review creates, updates, and retires before anything changes.',
}) async {
  final applied = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _LoreProposalSheet(
        bookId: bookId,
        resultFuture: resultFuture,
        title: title,
        subtitle: subtitle,
      );
    },
  );
  return applied ?? false;
}

class _LoreProposalSheet extends ConsumerStatefulWidget {
  const _LoreProposalSheet({
    required this.bookId,
    required this.resultFuture,
    required this.title,
    required this.subtitle,
  });

  final String bookId;
  final Future<AiResult> resultFuture;
  final String title;
  final String subtitle;

  @override
  ConsumerState<_LoreProposalSheet> createState() => _LoreProposalSheetState();
}

class _LoreProposalSheetState extends ConsumerState<_LoreProposalSheet> {
  final _selected = <String>{};
  bool _isApplying = false;
  bool _defaultsReady = false;

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
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
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

                final proposals = snapshot.data!.loreProposals;
                if (proposals.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        snapshot.data!.text.trim().isEmpty
                            ? 'No lore changes suggested.'
                            : snapshot.data!.text,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  );
                }

                if (!_defaultsReady) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted || _defaultsReady) {
                      return;
                    }
                    setState(() {
                      _selected.addAll(proposals.map((p) => p.id));
                      _defaultsReady = true;
                    });
                  });
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
                        itemCount: proposals.length,
                        separatorBuilder: (_, _) => const Divider(height: 20),
                        itemBuilder: (context, index) {
                          final proposal = proposals[index];
                          return _ProposalTile(
                            proposal: proposal,
                            selected: _selected.contains(proposal.id),
                            onChanged: (selected) {
                              setState(() {
                                if (selected) {
                                  _selected.add(proposal.id);
                                } else {
                                  _selected.remove(proposal.id);
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
                                : () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: _isApplying || _selected.isEmpty
                                ? null
                                : () => _apply(proposals),
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

  Future<void> _apply(List<LoreProposal> proposals) async {
    setState(() => _isApplying = true);

    try {
      final noteRepo = ref.read(noteRepositoryProvider);
      final relRepo = ref.read(noteRelationshipRepositoryProvider);
      var created = 0;
      var updated = 0;
      var retired = 0;
      var linked = 0;
      var unlinked = 0;

      for (final proposal in proposals) {
        if (!_selected.contains(proposal.id)) {
          continue;
        }

        switch (proposal.kind) {
          case LoreProposalKind.create:
            await noteRepo.create(
              bookId: widget.bookId,
              type: proposal.type,
              title: proposal.title,
              content: proposal.content,
              loreKeywords: proposal.loreKeywords,
              status: proposal.status,
              chronologyOrder: proposal.chronologyOrder,
              era: proposal.era ?? '',
            );
            created++;
          case LoreProposalKind.update:
            final noteId = proposal.noteId;
            if (noteId == null) {
              continue;
            }
            final note = await noteRepo.getById(noteId);
            if (note == null) {
              continue;
            }
            await noteRepo.update(
              note.copyWith(
                content: proposal.content,
                type: proposal.type,
                status: proposal.status,
                loreKeywords: proposal.loreKeywords,
                chronologyOrder: proposal.chronologyOrder,
                era: proposal.era,
              ),
            );
            updated++;
          case LoreProposalKind.retire:
            final noteId = proposal.noteId;
            if (noteId == null) {
              continue;
            }
            final note = await noteRepo.getById(noteId);
            if (note == null) {
              continue;
            }
            await noteRepo.update(
              note.copyWith(
                type: NoteType.idea,
                status: NoteStatus.spark,
              ),
            );
            retired++;
          case LoreProposalKind.upsertRelationship:
            final sourceId = proposal.sourceNoteId;
            final targetId = proposal.targetNoteId;
            if (sourceId == null || targetId == null) {
              continue;
            }
            if (proposal.relationshipId != null) {
              final existing =
                  await relRepo.getById(proposal.relationshipId!);
              if (existing != null) {
                await relRepo.update(
                  existing.copyWith(
                    sourceNoteId: sourceId,
                    targetNoteId: targetId,
                    relationshipType: proposal.relationshipType,
                    description: proposal.relationshipDescription,
                  ),
                );
                linked++;
                continue;
              }
            }
            await relRepo.create(
              bookId: widget.bookId,
              sourceNoteId: sourceId,
              targetNoteId: targetId,
              relationshipType: proposal.relationshipType,
              description: proposal.relationshipDescription,
            );
            linked++;
          case LoreProposalKind.deleteRelationship:
            final relId = proposal.relationshipId;
            if (relId != null) {
              await relRepo.delete(relId);
              unlinked++;
            }
        }
      }

      ref.invalidate(notesStreamProvider(NotesQuery(bookId: widget.bookId)));
      ref.invalidate(noteRelationshipsByBookProvider(widget.bookId));

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);

      final parts = <String>[
        if (created > 0) '$created created',
        if (updated > 0) '$updated updated',
        if (retired > 0) '$retired retired',
        if (linked > 0) '$linked linked',
        if (unlinked > 0) '$unlinked unlinked',
      ];
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              parts.isEmpty
                  ? 'No changes applied.'
                  : 'Lore applied: ${parts.join(', ')}.',
            ),
          ),
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

class _ProposalTile extends StatelessWidget {
  const _ProposalTile({
    required this.proposal,
    required this.selected,
    required this.onChanged,
  });

  final LoreProposal proposal;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final kindColor = switch (proposal.kind) {
      LoreProposalKind.create => scheme.primary,
      LoreProposalKind.update => scheme.tertiary,
      LoreProposalKind.retire => scheme.error,
      LoreProposalKind.upsertRelationship => scheme.secondary,
      LoreProposalKind.deleteRelationship => scheme.error,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: selected,
          onChanged: (value) => onChanged(value ?? false),
          title: Text(proposal.title),
          subtitle: Text(proposal.reason),
          secondary: Chip(
            label: Text(proposal.kindLabel),
            visualDensity: VisualDensity.compact,
            side: BorderSide(color: kindColor.withValues(alpha: 0.4)),
            labelStyle: TextStyle(color: kindColor, fontSize: 12),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (proposal.isRelationship) ...[
          Text(
            '${proposal.relationshipType}'
            '${proposal.relationshipDescription.trim().isEmpty ? '' : ' — ${proposal.relationshipDescription}'}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (proposal.kind == LoreProposalKind.deleteRelationship)
            Text(
              'Will remove this link from the world bible.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ] else ...[
          Text(
            '${proposal.type.label} · ${proposal.status.label}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (proposal.kind == LoreProposalKind.retire) ...[
            const SizedBox(height: 4),
            Text(
              'Will demote to Idea / Spark (excluded from writing AI unless always-include).',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              proposal.kind == LoreProposalKind.create
                  ? 'New note body:'
                  : 'Proposed note body:',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            SelectableText(
              proposal.content,
              style: appReadingStyle(context),
            ),
          ],
        ],
      ],
    );
  }
}
