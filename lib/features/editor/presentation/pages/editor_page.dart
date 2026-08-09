import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_book_actions.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/preferences/app_preferences.dart';
import 'package:journey/core/providers/app_preferences_provider.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/core/utils/debouncer.dart';
import 'package:journey/features/books/domain/models/book.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/features/editor/presentation/widgets/editor_chapter_sidebar.dart';
import 'package:journey/features/editor/presentation/widgets/sensory_sense_dialog.dart';
import 'package:journey/features/editor/presentation/widgets/tone_voice_meter_dialog.dart';
import 'package:journey/shared/widgets/ai_result_sheet.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:journey/shared/widgets/text_input_dialog.dart';

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({
    required this.bookId,
    required this.chapterId,
    super.key,
  });

  final String bookId;
  final String chapterId;

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  static const _sidebarBreakpoint = 1100.0;

  final _controller = TextEditingController();
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();

  String? _loadedChapterId;
  String _chapterTitle = '';
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  bool _saveFailed = false;
  bool _focusMode = false;

  @override
  void dispose() {
    if (_focusMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    _debouncer.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapterAsync = ref.watch(chapterProvider(widget.chapterId));
    final bookAsync = ref.watch(bookProvider(widget.bookId));
    final prefs = ref.watch(appPreferencesProvider).value;

    return chapterAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorState.fromError(
          error: error,
          onRetry: () => ref.invalidate(chapterProvider(widget.chapterId)),
        ),
      ),
      data: (chapter) {
        if (chapter == null) {
          return const Scaffold(
            body: ErrorState(
              message: 'This chapter could not be found. It may have been deleted.',
              icon: Icons.article_outlined,
            ),
          );
        }

        if (_loadedChapterId != chapter.id) {
          _loadedChapterId = chapter.id;
          _chapterTitle = chapter.title;
          _controller.text = chapter.content;
          _hasUnsavedChanges = false;
          _saveFailed = false;
        } else if (_chapterTitle != chapter.title) {
          _chapterTitle = chapter.title;
        }

        if (_focusMode) {
          return _buildFocusScaffold(chapter, prefs);
        }

        final selectedText = _selectedText();
        final hasSelection = selectedText != null && selectedText.isNotEmpty;
        final editorScaffold = _buildEditorScaffold(
          chapter: chapter,
          bookAsync: bookAsync,
          hasSelection: hasSelection,
          selectedText: selectedText,
          prefs: prefs,
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            final showSidebar = constraints.maxWidth >= _sidebarBreakpoint;
            if (!showSidebar) {
              return editorScaffold;
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 260,
                  child: EditorChapterSidebar(
                    bookId: widget.bookId,
                    currentChapterId: widget.chapterId,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: editorScaffold),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEditorScaffold({
    required Chapter chapter,
    required AsyncValue<Book?> bookAsync,
    required bool hasSelection,
    required String? selectedText,
    required AppPreferences? prefs,
  }) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true, shift: true):
            () => _setFocusMode(true),
      },
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () => _renameChapter(chapter),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(_chapterTitle),
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Focus mode',
              onPressed: () => _setFocusMode(true),
              icon: const Icon(Icons.fullscreen),
            ),
            IconButton(
              tooltip: 'Rename chapter',
              onPressed: () => _renameChapter(chapter),
              icon: const Icon(Icons.drive_file_rename_outline),
            ),
            PopupMenuButton<AiAction>(
              tooltip: 'AI assistant',
              icon: const Icon(Icons.auto_awesome_outlined),
              onSelected: (action) => _onAiMenuSelected(
                action: action,
                chapter: chapter,
                book: bookAsync.asData?.value,
                hasSelection: hasSelection,
                selectedText: selectedText,
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: AiAction.continueWriting,
                  child: Text('Continue writing'),
                ),
                if (hasSelection) ...[
                  const PopupMenuItem(
                    value: AiAction.rephrase,
                    child: Text('Rephrase selection'),
                  ),
                  const PopupMenuItem(
                    value: AiAction.expand,
                    child: Text('Expand selection'),
                  ),
                  const PopupMenuItem(
                    value: AiAction.tighten,
                    child: Text('Tighten selection'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: AiAction.sensoryEnhance,
                    child: Text('Sensory enhance'),
                  ),
                  const PopupMenuItem(
                    value: AiAction.showDontTell,
                    child: Text("Show, don't tell"),
                  ),
                ],
                const PopupMenuItem(
                  value: AiAction.summarizeChapter,
                  child: Text('Summarize chapter'),
                ),
                const PopupMenuItem(
                  value: AiAction.toneVoiceMeter,
                  child: Text('Tone & voice meter'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: AiAction.continuityCheck,
                  child: Text('Check continuity'),
                ),
                const PopupMenuItem(
                  value: AiAction.askWorldBible,
                  child: Text('Ask the world bible'),
                ),
                const PopupMenuItem(
                  value: AiAction.extractEntities,
                  child: Text('Discover entities'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: _saveStatusWidget()),
            ),
          ],
        ),
        body: _buildEditorField(chapter, prefs: prefs),
      ),
    );
  }

  Widget _buildFocusScaffold(Chapter chapter, AppPreferences? prefs) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          _setFocusMode(false);
        },
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              _buildEditorField(
                chapter,
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                prefs: prefs,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: (prefs?.editorLineHeight ?? 1.8),
                  fontSize: (prefs?.editorFontSize ?? 18) + 2,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton.filledTonal(
                  tooltip: 'Exit focus mode',
                  onPressed: () => _setFocusMode(false),
                  icon: const Icon(Icons.fullscreen_exit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditorField(
    Chapter chapter, {
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    TextStyle? style,
    AppPreferences? prefs,
  }) {
    final editorStyle = style ??
        Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: prefs?.editorFontSize ?? 16,
          height: prefs?.editorLineHeight ?? 1.6,
        );

    return Padding(
      padding: padding,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          hintText: 'Start writing...',
          border: InputBorder.none,
        ),
        style: editorStyle,
        onChanged: (_) {
          setState(() {
            _hasUnsavedChanges = true;
            _saveFailed = false;
          });
          _debouncer.run(() => _save(chapter));
        },
      ),
    );
  }

  void _setFocusMode(bool enabled) {
    setState(() => _focusMode = enabled);
    SystemChrome.setEnabledSystemUIMode(
      enabled ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
    if (enabled) {
      _focusNode.requestFocus();
    }
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

  String? _selectedText() {
    final selection = _controller.selection;
    if (!selection.isValid || selection.isCollapsed) {
      return null;
    }
    return _controller.text.substring(selection.start, selection.end);
  }

  Future<void> _renameChapter(Chapter chapter) async {
    final title = await showTextInputDialog(
      context: context,
      title: 'Rename chapter',
      label: 'Title',
      initialValue: chapter.title,
      confirmLabel: 'Save',
    );
    if (title == null) {
      return;
    }

    try {
      final updated = await ref.chapters.update(
        chapter.copyWith(title: title),
      );
      if (!mounted) {
        return;
      }
      setState(() => _chapterTitle = updated.title);
      ref.invalidate(chapterProvider(widget.chapterId));
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _onAiMenuSelected({
    required AiAction action,
    required Chapter chapter,
    required Book? book,
    required bool hasSelection,
    required String? selectedText,
  }) async {
    final liveChapter = _liveChapter(chapter);

    switch (action) {
      case AiAction.sensoryEnhance:
        final sense = await showSensorySenseDialog(context);
        if (sense == null || !mounted) {
          return;
        }
        await _runAiAction(
          action: action,
          chapter: liveChapter,
          book: book,
          selectedText: selectedText,
          canReplace: true,
          sensorySense: sense,
        );
        return;
      case AiAction.toneVoiceMeter:
        await _runToneVoiceMeter(
          chapter: liveChapter,
          book: book,
        );
        return;
      case AiAction.continuityCheck:
        await AiBookActions.runContinuityCheck(
          context: context,
          ref: ref,
          bookId: widget.bookId,
          chapter: liveChapter,
          book: book,
        );
        return;
      case AiAction.askWorldBible:
        await AiBookActions.runAskWorldBible(
          context: context,
          ref: ref,
          bookId: widget.bookId,
          chapter: liveChapter,
          book: book,
        );
        return;
      case AiAction.extractEntities:
        await AiBookActions.runExtractEntities(
          context: context,
          ref: ref,
          bookId: widget.bookId,
          chapters: [liveChapter],
          book: book,
        );
        return;
      case AiAction.pacingHeatmap:
      case AiAction.plotBridge:
      case AiAction.blurbPitchGenerator:
        return;
      case AiAction.continueWriting:
      case AiAction.rephrase:
      case AiAction.expand:
      case AiAction.tighten:
      case AiAction.summarizeChapter:
      case AiAction.showDontTell:
      case AiAction.recapBook:
        await _runAiAction(
          action: action,
          chapter: liveChapter,
          book: book,
          selectedText: hasSelection ? selectedText : null,
          canReplace: hasSelection &&
              action != AiAction.showDontTell &&
              action != AiAction.continueWriting &&
              action != AiAction.summarizeChapter,
        );
        return;
    }
  }

  Chapter _liveChapter(Chapter chapter) {
    return chapter.copyWith(content: _controller.text);
  }

  Future<void> _runToneVoiceMeter({
    required Chapter chapter,
    required Book? book,
  }) async {
    final chapters = await ref.read(
      chaptersStreamProvider(widget.bookId).future,
    );
    if (!mounted) {
      return;
    }

    final config = await showToneVoiceMeterDialog(
      context: context,
      chapters: chapters,
      currentChapterId: widget.chapterId,
    );
    if (config == null || !mounted) {
      return;
    }

    await _runAiAction(
      action: AiAction.toneVoiceMeter,
      chapter: chapter,
      book: book,
      referenceChapter: config.referenceChapter,
      userPrompt: config.voicePersona,
      allowInsert: false,
    );
  }

  Future<void> _runAiAction({
    required AiAction action,
    required Chapter chapter,
    required Book? book,
    String? selectedText,
    bool canReplace = false,
    bool allowInsert = true,
    Chapter? referenceChapter,
    String? userPrompt,
    SensorySense sensorySense = SensorySense.auto,
  }) async {
    final aiContext = AiContext(
      selectedText: selectedText,
      chapter: chapter,
      book: book,
      referenceChapter: referenceChapter,
      userPrompt: userPrompt,
      sensorySense: sensorySense,
    );

    final runner = ref.read(aiActionRunnerProvider);
    final resultFuture = runner.run(action: action, context: aiContext);

    await showAiResultSheet(
      context: context,
      action: action,
      resultFuture: resultFuture,
      onInsert: allowInsert
          ? (text) {
              _insertText(text, replaceSelection: false);
              _debouncer.run(() => _save(chapter));
            }
          : null,
      onReplace: canReplace
          ? (text) {
              _insertText(text, replaceSelection: true);
              _debouncer.run(() => _save(chapter));
            }
          : null,
    );
  }

  void _insertText(String text, {required bool replaceSelection}) {
    final selection = _controller.selection;
    final value = _controller.text;

    if (replaceSelection && selection.isValid && !selection.isCollapsed) {
      final updated = value.replaceRange(selection.start, selection.end, text);
      _controller.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(offset: selection.start + text.length),
      );
    } else {
      final offset = selection.isValid ? selection.end : value.length;
      final prefix = offset > 0 && value[offset - 1] != '\n' ? '\n\n' : '';
      final updated = value.replaceRange(offset, offset, '$prefix$text');
      _controller.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(
          offset: offset + prefix.length + text.length,
        ),
      );
    }

    setState(() {
      _hasUnsavedChanges = true;
      _saveFailed = false;
    });
  }

  Future<void> _save(Chapter chapter) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = true;
      _saveFailed = false;
    });

    try {
      await ref.chapters.update(
        chapter.copyWith(content: _controller.text),
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _hasUnsavedChanges = false;
        _saveFailed = false;
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
}
