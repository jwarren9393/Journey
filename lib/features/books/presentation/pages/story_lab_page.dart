import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/ai_context_builder.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/canon_pin_providers.dart';
import 'package:journey/features/books/presentation/providers/note_providers.dart';
import 'package:journey/features/books/presentation/providers/story_lab_providers.dart';
import 'package:journey/shared/widgets/ai_result_sheet.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/extract_entities_sheet.dart';

class StoryLabPage extends ConsumerStatefulWidget {
  const StoryLabPage({required this.bookId, super.key});

  final String bookId;

  @override
  ConsumerState<StoryLabPage> createState() => _StoryLabPageState();
}

class _StoryLabPageState extends ConsumerState<StoryLabPage> {
  final _composerController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _composerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookAsync = ref.watch(bookProvider(widget.bookId));
    final messagesAsync = ref.watch(storyLabMessagesStreamProvider(widget.bookId));
    final pinsAsync = ref.watch(canonPinsStreamProvider(widget.bookId));

    return Scaffold(
      appBar: AppBar(
        title: bookAsync.when(
          data: (book) => Text('Story Lab — ${book?.title ?? ''}'),
          loading: () => const Text('Story Lab'),
          error: (_, _) => const Text('Story Lab'),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'scene_ideas',
                child: Text('Generate scene ideas'),
              ),
              PopupMenuItem(
                value: 'glossary',
                child: Text('Extract glossary'),
              ),
              PopupMenuItem(
                value: 'summarize',
                child: Text('Summarize brainstorm'),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'clear',
                child: Text('Clear messages'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          pinsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (pins) {
              if (pins.isEmpty) {
                return const SizedBox.shrink();
              }
              return Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Canon pins',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: pins
                            .map(
                              (pin) => InputChip(
                                label: Text(
                                  pin.text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onDeleted: () => _deletePin(pin.id),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorState.fromError(
                error: error,
                onRetry: () => ref.invalidate(
                  storyLabMessagesStreamProvider(widget.bookId),
                ),
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'A sandbox for brainstorming. Nothing here touches your manuscript until you save it to notes or outline.\n\nType a message and tap Send — AI only runs when you ask.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message.role == StoryLabRole.user;
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: isUser
                            ? () => _pinMessage(message.content)
                            : null,
                        child: Card(
                          color: isUser
                              ? Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.5)
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.sizeOf(context).width * 0.85,
                              ),
                              child: Text(message.content),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _composerController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Brainstorm an idea…',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Send (runs AI)',
                    onPressed: _isSending ? null : _sendMessage,
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _composerController.text.trim();
    if (text.isEmpty || _isSending) {
      return;
    }

    setState(() => _isSending = true);
    _composerController.clear();

    try {
      final storyLabRepo = ref.read(storyLabRepositoryProvider);
      await storyLabRepo.addMessage(
        bookId: widget.bookId,
        role: StoryLabRole.user,
        content: text,
      );

      final book = await ref.books.getById(widget.bookId);
      if (book == null) {
        return;
      }

      final messages = await ref.read(
        storyLabMessagesStreamProvider(widget.bookId).future,
      );
      final pins = await ref.read(
        canonPinsStreamProvider(widget.bookId).future,
      );
      final notes = await ref.read(
        notesStreamProvider(NotesQuery(bookId: widget.bookId)).future,
      );

      final aiContext = AiContextBuilder.forStoryLab(
        book: book,
        messages: messages,
        canonPins: pins,
        allNotes: notes,
        userMessage: text,
      );

      final result = await ref.read(aiActionRunnerProvider).run(
            action: AiAction.storyLabBrainstorm,
            context: aiContext,
          );

      await storyLabRepo.addMessage(
        bookId: widget.bookId,
        role: StoryLabRole.assistant,
        content: result.text,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _pinMessage(String text) async {
    try {
      await ref.read(canonPinRepositoryProvider).create(
            bookId: widget.bookId,
            text: text,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Pinned as canon.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _deletePin(String id) async {
    try {
      await ref.read(canonPinRepositoryProvider).delete(id);
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _handleMenuAction(String action) async {
    switch (action) {
      case 'scene_ideas':
        await _runSceneIdeas();
      case 'glossary':
        await _runGlossary();
      case 'summarize':
        await _runSummarize();
      case 'clear':
        await _clearMessages();
    }
  }

  Future<void> _runSceneIdeas() async {
    try {
      final book = await ref.books.getById(widget.bookId);
      if (book == null || !mounted) {
        return;
      }

      final messages = await ref.read(
        storyLabMessagesStreamProvider(widget.bookId).future,
      );
      final pins = await ref.read(
        canonPinsStreamProvider(widget.bookId).future,
      );
      final notes = await ref.read(
        notesStreamProvider(NotesQuery(bookId: widget.bookId)).future,
      );

      final aiContext = AiContextBuilder.forStoryLab(
        book: book,
        messages: messages,
        canonPins: pins,
        allNotes: notes,
      );

      final resultFuture = ref.read(aiActionRunnerProvider).run(
            action: AiAction.storyLabSceneIdeas,
            context: aiContext,
          );

      if (!mounted) {
        return;
      }

      await showAiResultSheet(
        context: context,
        action: AiAction.storyLabSceneIdeas,
        resultFuture: resultFuture,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _runGlossary() async {
    try {
      final book = await ref.books.getById(widget.bookId);
      if (book == null || !mounted) {
        return;
      }

      final messages = await ref.read(
        storyLabMessagesStreamProvider(widget.bookId).future,
      );
      if (messages.isEmpty) {
        showAppSnackBar(context, 'Add some brainstorm messages first.');
        return;
      }

      final pins = await ref.read(
        canonPinsStreamProvider(widget.bookId).future,
      );
      final notes = await ref.read(
        notesStreamProvider(NotesQuery(bookId: widget.bookId)).future,
      );

      final aiContext = AiContextBuilder.forStoryLab(
        book: book,
        messages: messages,
        canonPins: pins,
        allNotes: notes,
      );

      final resultFuture = ref.read(aiActionRunnerProvider).run(
            action: AiAction.storyLabGlossary,
            context: aiContext,
          );

      if (!mounted) {
        return;
      }

      await showExtractEntitiesSheet(
        context: context,
        bookId: widget.bookId,
        resultFuture: resultFuture,
        onNoteCreated: (noteId) {
          if (context.mounted) {
            context.push('/books/${widget.bookId}/notes/$noteId');
          }
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _runSummarize() async {
    try {
      final book = await ref.books.getById(widget.bookId);
      if (book == null || !mounted) {
        return;
      }

      final messages = await ref.read(
        storyLabMessagesStreamProvider(widget.bookId).future,
      );
      if (messages.isEmpty) {
        showAppSnackBar(context, 'Add some brainstorm messages first.');
        return;
      }

      final pins = await ref.read(
        canonPinsStreamProvider(widget.bookId).future,
      );
      final notes = await ref.read(
        notesStreamProvider(NotesQuery(bookId: widget.bookId)).future,
      );

      final aiContext = AiContextBuilder.forStoryLab(
        book: book,
        messages: messages,
        canonPins: pins,
        allNotes: notes,
      );

      final resultFuture = ref.read(aiActionRunnerProvider).run(
            action: AiAction.storyLabSummarize,
            context: aiContext,
          );

      if (!mounted) {
        return;
      }

      await showAiResultSheet(
        context: context,
        action: AiAction.storyLabSummarize,
        resultFuture: resultFuture,
        replaceLabel: 'Save summary',
        onReplace: (text) async {
          await ref.books.update(book.copyWith(storyLabSummary: text));
          ref.invalidate(bookProvider(widget.bookId));
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _clearMessages() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear brainstorm?'),
        content: const Text(
          'This removes all Story Lab messages. Canon pins and the saved summary are kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await ref.read(storyLabRepositoryProvider).clearMessages(widget.bookId);
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }
}
