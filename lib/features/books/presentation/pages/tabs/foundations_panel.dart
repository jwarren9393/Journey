import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/ai_context_builder.dart';
import 'package:journey/core/ai/models/grow_option.dart';
import 'package:journey/core/ai/models/world_spark.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/core/theme/app_reading_style.dart';
import 'package:journey/core/utils/debouncer.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';
import 'package:journey/features/books/domain/models/story_lab_draft.dart';
import 'package:journey/features/books/presentation/note_presentation.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/story_lab_providers.dart';
import 'package:journey/shared/widgets/ai_result_sheet.dart';
import 'package:journey/shared/widgets/error_state.dart';

class FoundationsPanel extends ConsumerStatefulWidget {
  const FoundationsPanel({required this.bookId, super.key});

  final String bookId;

  @override
  ConsumerState<FoundationsPanel> createState() => _FoundationsPanelState();
}

class _FoundationsPanelState extends ConsumerState<FoundationsPanel>
    with AutomaticKeepAliveClientMixin {
  final _seedController = TextEditingController();
  final _focusController = TextEditingController();
  final _saveDebouncer = Debouncer(duration: const Duration(milliseconds: 400));

  bool _loadingSparks = false;
  bool _loadingGrow = false;
  bool _hydrated = false;
  bool _dirty = false;
  List<WorldSpark> _sparks = const [];
  List<GrowOption> _growOptions = const [];
  NoteType? _growType;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void deactivate() {
    if (_hydrated && _dirty) {
      _persist();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _saveDebouncer.dispose();
    _seedController.dispose();
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bookAsync = ref.watch(bookProvider(widget.bookId));
    final draftAsync = ref.watch(storyLabDraftProvider(widget.bookId));

    if (bookAsync.isLoading || draftAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return bookAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState.fromError(
        error: error,
        onRetry: () => ref.invalidate(bookProvider(widget.bookId)),
      ),
      data: (book) {
        if (book == null) {
          return const ErrorState(
            message: 'This book could not be found.',
            icon: Icons.auto_stories_outlined,
          );
        }

        draftAsync.whenData(_hydrate);

        final hasPicture = book.description.trim().isNotEmpty ||
            book.canonSummary.trim().isNotEmpty;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              hasPicture
                  ? 'Your picture is the north star. Grow named pieces from it — keep what you like, leave the rest.'
                  : _sparks.isNotEmpty
                      ? 'You have ${_sparks.length == 1 ? 'a spark' : '${_sparks.length} sparks'} ready. Pick one as the picture, or generate more directions.'
                      : _seedController.text.trim().isNotEmpty
                          ? 'Your seed is saved. Generate sparks when you are ready, then pick a picture.'
                          : 'Starting from nothing is allowed. Generate a few whole pictures, pick one, then grow characters, places, and history from there.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            if (hasPicture) _PictureCard(book: book),
            if (hasPicture) const SizedBox(height: 16),
            _SparksSection(
              seedController: _seedController,
              loading: _loadingSparks,
              sparks: _sparks,
              onSeedChanged: (_) => _scheduleSave(),
              hasPicture: hasPicture,
              onGenerate: () => _generateSparks(book, moreLike: null),
              onKeepIdea: (spark) => _keepSparkAsIdea(book, spark),
              onCommit: (spark) => _commitPicture(book, spark),
              onMoreLike: (spark) => _generateSparks(book, moreLike: spark),
            ),
            if (hasPicture) ...[
              const SizedBox(height: 24),
              _GrowSection(
                focusController: _focusController,
                growType: _growType,
                loading: _loadingGrow,
                options: _growOptions,
                onTypeChanged: (type) {
                  setState(() => _growType = type);
                  _scheduleSave();
                },
                onFocusChanged: (_) => _scheduleSave(),
                onGrow: () => _grow(book),
                onKeep: (option, status) => _keepGrowOption(book, option, status),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => _openingScenes(book),
                icon: const Icon(Icons.movie_filter_outlined),
                label: const Text('Opening scene ideas'),
              ),
            ],
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  void _hydrate(StoryLabDraft draft) {
    if (_hydrated) {
      return;
    }
    _seedController.text = draft.seed;
    _focusController.text = draft.growFocus;
    _sparks = draft.sparks;
    _growOptions = draft.growOptions;
    _growType = draft.growType;
    _hydrated = true;
  }

  void _scheduleSave() {
    _dirty = true;
    _saveDebouncer.run(_persist);
  }

  Future<void> _persist() async {
    if (!_hydrated) {
      return;
    }
    _dirty = false;
    await ref.read(storyLabDraftProvider(widget.bookId).notifier).patch(
          (current) => current.copyWith(
            seed: _seedController.text,
            sparks: _sparks,
            growType: _growType,
            growFocus: _focusController.text,
            growOptions: _growOptions,
          ),
        );
  }

  Future<void> _generateSparks(Book book, {WorldSpark? moreLike}) async {
    setState(() {
      _loadingSparks = true;
      _error = null;
    });

    try {
      final notes = await ref.read(
        notesStreamProvider(NotesQuery(bookId: widget.bookId)).future,
      );
      final seedParts = <String>[
        if (_seedController.text.trim().isNotEmpty) _seedController.text.trim(),
        if (moreLike != null)
          'More like this title and mood, but a distinct world:\n'
              '${moreLike.title}\n${moreLike.vibe}\n${moreLike.picture}',
      ];

      final result = await ref.read(aiActionRunnerProvider).run(
            action: AiAction.foundationsSparks,
            context: AiContextBuilder.forFoundations(
              book: book,
              allNotes: notes,
              userPrompt: seedParts.isEmpty ? null : seedParts.join('\n\n'),
            ),
          );

      if (!mounted) {
        return;
      }
      setState(() {
        _sparks = result.worldSparks;
        if (_sparks.isEmpty) {
          _error = result.text.trim().isEmpty
              ? 'No sparks came back. Try again or add a vibe.'
              : 'Could not parse sparks. ${result.text.split('\n').first}';
        }
      });
      await _persist();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _loadingSparks = false);
      }
    }
  }

  Future<void> _commitPicture(Book book, WorldSpark spark) async {
    try {
      final authorsNote = book.authorsNote.trim().isEmpty && spark.tone.trim().isNotEmpty
          ? 'Tone: ${spark.tone.trim()}'
          : book.authorsNote;
      await ref.books.update(
        book.copyWith(
          description: spark.picture,
          canonSummary: spark.canonBullets,
          authorsNote: authorsNote,
        ),
      );
      ref.invalidate(bookProvider(widget.bookId));
      if (!mounted) {
        return;
      }
      showAppSnackBar(
        context,
        'This is the picture. Grow whatever you want from here.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _keepSparkAsIdea(Book book, WorldSpark spark) async {
    try {
      final note = await ref.notes.create(
        bookId: widget.bookId,
        type: NoteType.idea,
        title: spark.title,
        content: spark.toNoteBody(),
        loreKeywords: spark.title,
        status: NoteStatus.spark,
      );
      if (!mounted) {
        return;
      }
      showAppSnackBar(
        context,
        'Saved “${spark.title}” as an idea spark.',
        action: SnackBarAction(
          label: 'Open',
          onPressed: () => context.push(
            AppRoutes.noteEditor(widget.bookId, note.id),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _grow(Book book) async {
    setState(() {
      _loadingGrow = true;
      _error = null;
    });

    try {
      final notes = await ref.read(
        notesStreamProvider(NotesQuery(bookId: widget.bookId)).future,
      );
      final result = await ref.read(aiActionRunnerProvider).run(
            action: AiAction.foundationsGrow,
            context: AiContextBuilder.forFoundations(
              book: book,
              allNotes: notes,
              userPrompt: _focusController.text.trim().isEmpty
                  ? null
                  : _focusController.text.trim(),
              growType: _growType,
            ),
          );

      if (!mounted) {
        return;
      }
      setState(() {
        _growOptions = result.growOptions;
        if (_growOptions.isEmpty) {
          _error = 'No grow options came back. Try a different type or focus.';
        }
      });
      await _persist();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _loadingGrow = false);
      }
    }
  }

  Future<void> _keepGrowOption(
    Book book,
    GrowOption option,
    NoteStatus status,
  ) async {
    try {
      final note = await ref.notes.create(
        bookId: widget.bookId,
        type: option.type,
        title: option.name,
        content: option.description,
        loreKeywords: option.loreKeywords,
        status: status,
      );
      if (!mounted) {
        return;
      }
      showAppSnackBar(
        context,
        'Saved “${option.name}” as ${status.label.toLowerCase()}.',
        action: SnackBarAction(
          label: 'Open',
          onPressed: () => context.push(
            AppRoutes.noteEditor(widget.bookId, note.id),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _openingScenes(Book book) async {
    try {
      final notes = await ref.read(
        notesStreamProvider(NotesQuery(bookId: widget.bookId)).future,
      );
      final resultFuture = ref.read(aiActionRunnerProvider).run(
            action: AiAction.foundationsOpeningScenes,
            context: AiContextBuilder.forFoundations(
              book: book,
              allNotes: notes,
            ),
          );
      if (!mounted) {
        return;
      }
      await showAiResultSheet(
        context: context,
        action: AiAction.foundationsOpeningScenes,
        resultFuture: resultFuture,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }
}

class _PictureCard extends StatelessWidget {
  const _PictureCard({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The picture',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (book.description.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(book.description.trim()),
            ],
            if (book.canonSummary.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Canon',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(book.canonSummary.trim()),
            ],
            if (book.authorsNote.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Tone',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(book.authorsNote.trim()),
            ],
          ],
        ),
      ),
    );
  }
}

class _SparksSection extends StatelessWidget {
  const _SparksSection({
    required this.seedController,
    required this.loading,
    required this.sparks,
    required this.hasPicture,
    required this.onSeedChanged,
    required this.onGenerate,
    required this.onKeepIdea,
    required this.onCommit,
    required this.onMoreLike,
  });

  final TextEditingController seedController;
  final bool loading;
  final List<WorldSpark> sparks;
  final bool hasPicture;
  final ValueChanged<String> onSeedChanged;
  final VoidCallback onGenerate;
  final ValueChanged<WorldSpark> onKeepIdea;
  final ValueChanged<WorldSpark> onCommit;
  final ValueChanged<WorldSpark> onMoreLike;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          hasPicture ? 'Try another direction' : 'Sparks',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: seedController,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Optional vibe or seed',
            hintText: 'lonely grandeur, a city that forgets names, found family…',
            border: OutlineInputBorder(),
          ),
          onChanged: onSeedChanged,
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: loading ? null : onGenerate,
          icon: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_awesome),
          label: Text(
            loading
                ? 'Finding pictures…'
                : hasPicture
                    ? 'Generate new sparks'
                    : 'Surprise me',
          ),
        ),
        if (sparks.isNotEmpty) ...[
          const SizedBox(height: 16),
          for (final spark in sparks) ...[
            _SparkCard(
              spark: spark,
              commitLabel: hasPicture ? 'Replace the picture' : 'This is the one',
              onKeepIdea: () => onKeepIdea(spark),
              onCommit: () => onCommit(spark),
              onMoreLike: () => onMoreLike(spark),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _SparkCard extends StatelessWidget {
  const _SparkCard({
    required this.spark,
    required this.commitLabel,
    required this.onKeepIdea,
    required this.onCommit,
    required this.onMoreLike,
  });

  final WorldSpark spark;
  final String commitLabel;
  final VoidCallback onKeepIdea;
  final VoidCallback onCommit;
  final VoidCallback onMoreLike;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spark.title, style: Theme.of(context).textTheme.titleMedium),
            if (spark.vibe.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                spark.vibe,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 8),
            Text(spark.picture, style: appReadingStyle(context)),
            if (spark.wound.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'The wound: ${spark.wound}',
                style: appReadingStyle(context),
              ),
            ],
            if (spark.tone.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Tone: ${spark.tone}', style: appReadingStyle(context)),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: onCommit,
                  child: Text(commitLabel),
                ),
                OutlinedButton(
                  onPressed: onKeepIdea,
                  child: const Text('Keep as idea'),
                ),
                TextButton(
                  onPressed: onMoreLike,
                  child: const Text('More like this'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GrowSection extends StatelessWidget {
  const _GrowSection({
    required this.focusController,
    required this.growType,
    required this.loading,
    required this.options,
    required this.onTypeChanged,
    required this.onFocusChanged,
    required this.onGrow,
    required this.onKeep,
  });

  final TextEditingController focusController;
  final NoteType? growType;
  final bool loading;
  final List<GrowOption> options;
  final ValueChanged<NoteType?> onTypeChanged;
  final ValueChanged<String> onFocusChanged;
  final VoidCallback onGrow;
  final void Function(GrowOption option, NoteStatus status) onKeep;

  static const _growTypes = <NoteType?>[
    null,
    NoteType.character,
    NoteType.location,
    NoteType.group,
    NoteType.item,
    NoteType.history,
    NoteType.plot,
    NoteType.idea,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Grow from the picture',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'One named piece at a time. Keep it as a draft, or as a spark if you are still playing.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final type in _growTypes)
              ChoiceChip(
                label: Text(type?.label ?? 'Anything'),
                selected: growType == type,
                onSelected: (_) => onTypeChanged(type),
              ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: focusController,
          decoration: const InputDecoration(
            labelText: 'Optional focus',
            hintText: 'the ruling family, a forbidden relic, the war 20 years ago…',
            border: OutlineInputBorder(),
          ),
          onChanged: onFocusChanged,
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: loading ? null : onGrow,
          icon: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  NotePresentation.iconForType(growType ?? NoteType.idea),
                ),
          label: Text(loading ? 'Growing…' : 'Grow'),
        ),
        if (options.isNotEmpty) ...[
          const SizedBox(height: 16),
          for (final option in options) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(NotePresentation.iconForType(option.type)),
                      title: Text(option.name),
                      subtitle: Text(option.type.label),
                    ),
                    Text(
                      option.description,
                      style: appReadingStyle(context),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () => onKeep(option, NoteStatus.draft),
                          child: const Text('Keep as draft'),
                        ),
                        OutlinedButton(
                          onPressed: () => onKeep(option, NoteStatus.spark),
                          child: const Text('Keep as spark'),
                        ),
                        TextButton(
                          onPressed: () => onKeep(option, NoteStatus.canon),
                          child: const Text('Keep as canon'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}
