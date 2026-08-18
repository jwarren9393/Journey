import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/models/extracted_entity.dart';
import 'package:journey/core/utils/error_messages.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/shared/widgets/error_state.dart';

Future<void> showExtractEntitiesSheet({
  required BuildContext context,
  required String bookId,
  required Future<AiResult> resultFuture,
  void Function(String noteId)? onNoteCreated,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _ExtractEntitiesSheet(
        bookId: bookId,
        resultFuture: resultFuture,
        onNoteCreated: onNoteCreated,
      );
    },
  );
}

class _ExtractEntitiesSheet extends ConsumerStatefulWidget {
  const _ExtractEntitiesSheet({
    required this.bookId,
    required this.resultFuture,
    this.onNoteCreated,
  });

  final String bookId;
  final Future<AiResult> resultFuture;
  final void Function(String noteId)? onNoteCreated;

  @override
  ConsumerState<_ExtractEntitiesSheet> createState() =>
      _ExtractEntitiesSheetState();
}

class _ExtractEntitiesSheetState extends ConsumerState<_ExtractEntitiesSheet> {
  final _createdNames = <String>{};
  final _creatingNames = <String>{};

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
              'Discover entities',
              style: Theme.of(context).textTheme.titleMedium,
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        userFacingErrorMessage(snapshot.error!),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
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

                final result = snapshot.data!;
                final entities = result.extractedEntities;

                if (entities.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'No new characters, places, or items were found. '
                        'Try again after adding more manuscript text.',
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: entities.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final entity = entities[index];
                          return _EntityCard(
                            entity: entity,
                            isCreated: _createdNames.contains(entity.name),
                            isCreating: _creatingNames.contains(entity.name),
                            onCreate: () => _createNote(entity),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Done'),
                      ),
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

  Future<void> _createNote(ExtractedEntity entity) async {
    if (_createdNames.contains(entity.name) ||
        _creatingNames.contains(entity.name)) {
      return;
    }

    setState(() => _creatingNames.add(entity.name));

    try {
      final note = await ref.notes.create(
        bookId: widget.bookId,
        type: entity.suggestedType,
        title: entity.name,
        content: entity.description,
        loreKeywords: entity.name,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _creatingNames.remove(entity.name);
        _createdNames.add(entity.name);
      });

      widget.onNoteCreated?.call(note.id);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() => _creatingNames.remove(entity.name));
      showErrorSnackBar(context, error);
    }
  }
}

class _EntityCard extends StatelessWidget {
  const _EntityCard({
    required this.entity,
    required this.isCreated,
    required this.isCreating,
    required this.onCreate,
  });

  final ExtractedEntity entity;
  final bool isCreated;
  final bool isCreating;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entity.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  entity.suggestedType.label,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            if (entity.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(entity.description),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: isCreated
                  ? const Text('Note created')
                  : FilledButton.tonal(
                      onPressed: isCreating ? null : onCreate,
                      child: isCreating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Create note'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
