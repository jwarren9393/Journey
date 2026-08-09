import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/ai/ai_book_actions.dart';
import 'package:journey/core/ai/ai_export_actions.dart';
import 'package:journey/features/books/presentation/pages/tabs/book_chapters_tab.dart';
import 'package:journey/features/books/presentation/pages/tabs/book_notes_tab.dart';
import 'package:journey/features/books/presentation/pages/tabs/book_outline_tab.dart';
import 'package:journey/features/books/presentation/providers/book_providers.dart';
import 'package:journey/features/books/presentation/providers/chapter_providers.dart';
import 'package:journey/shared/widgets/text_input_dialog.dart';
import 'package:journey/shared/widgets/error_state.dart';

class BookDetailPage extends ConsumerStatefulWidget {
  const BookDetailPage({required this.bookId, super.key});

  final String bookId;

  @override
  ConsumerState<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends ConsumerState<BookDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookAsync = ref.watch(bookProvider(widget.bookId));

    return Scaffold(
      appBar: AppBar(
        title: bookAsync.when(
          data: (book) => Text(book?.title ?? 'Book'),
          loading: () => const Text('Loading...'),
          error: (_, _) => const Text('Book'),
        ),
        actions: [
          IconButton(
            tooltip: 'Search this book',
            onPressed: () => context.push(AppRoutes.bookSearch(widget.bookId)),
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<BookDetailMenuAction>(
            tooltip: 'More',
            onSelected: _handleMenuAction,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: BookDetailMenuAction.continuityCheck,
                child: Text('Check continuity'),
              ),
              PopupMenuItem(
                value: BookDetailMenuAction.askWorldBible,
                child: Text('Ask the world bible'),
              ),
              PopupMenuItem(
                value: BookDetailMenuAction.recap,
                child: Text('AI recap'),
              ),
              PopupMenuItem(
                value: BookDetailMenuAction.edit,
                child: Text('Edit book'),
              ),
              PopupMenuItem(
                value: BookDetailMenuAction.exportPlain,
                child: Text('Export as plain text'),
              ),
              PopupMenuItem(
                value: BookDetailMenuAction.exportMarkdown,
                child: Text('Export as Markdown'),
              ),
              PopupMenuItem(
                value: BookDetailMenuAction.blurbPitch,
                child: Text('Blurb & pitch'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chapters'),
            Tab(text: 'Outline'),
            Tab(text: 'Notes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BookChaptersTab(bookId: widget.bookId),
          BookOutlineTab(bookId: widget.bookId),
          BookNotesTab(bookId: widget.bookId),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget? _buildFab() {
    if (_tabController.index == 0) {
      return FloatingActionButton.extended(
        onPressed: _createChapter,
        icon: const Icon(Icons.add),
        label: const Text('New chapter'),
      );
    }
    return null;
  }

  Future<void> _createChapter() async {
    final title = await showTextInputDialog(
      context: context,
      title: 'New chapter',
      label: 'Title',
    );
    if (title == null || !mounted) {
      return;
    }

    try {
      final chapter = await ref.chapters.create(
        bookId: widget.bookId,
        title: title,
      );
      if (!mounted) {
        return;
      }
      context.push(AppRoutes.editor(widget.bookId, chapter.id));
    } catch (error) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(context, error);
    }
  }

  void _handleMenuAction(BookDetailMenuAction action) {
    switch (action) {
      case BookDetailMenuAction.continuityCheck:
        _runContinuityCheck();
      case BookDetailMenuAction.askWorldBible:
        AiBookActions.runAskWorldBible(
          context: context,
          ref: ref,
          bookId: widget.bookId,
        );
      case BookDetailMenuAction.recap:
        BookChaptersTab.showRecap(context, ref, widget.bookId);
      case BookDetailMenuAction.edit:
        BookChaptersTab.editBook(context, ref, widget.bookId);
      case BookDetailMenuAction.exportPlain:
        BookChaptersTab.exportBook(
          context,
          ref,
          widget.bookId,
          isMarkdown: false,
        );
      case BookDetailMenuAction.exportMarkdown:
        BookChaptersTab.exportBook(
          context,
          ref,
          widget.bookId,
          isMarkdown: true,
        );
      case BookDetailMenuAction.blurbPitch:
        AiExportActions.runBlurbPitchGenerator(
          context: context,
          ref: ref,
          bookId: widget.bookId,
        );
    }
  }

  Future<void> _runContinuityCheck() async {
    final book = await ref.books.getById(widget.bookId);
    final chapters = await ref.read(
      chaptersStreamProvider(widget.bookId).future,
    );
    if (!mounted) {
      return;
    }

    if (chapters.isEmpty) {
      showAppSnackBar(context, 'Add a chapter before checking continuity.');
      return;
    }

    final latestChapter = chapters.reduce(
      (current, next) =>
          next.updatedAt.isAfter(current.updatedAt) ? next : current,
    );

    await AiBookActions.runContinuityCheck(
      context: context,
      ref: ref,
      bookId: widget.bookId,
      chapter: latestChapter,
      book: book,
    );
  }
}

enum BookDetailMenuAction {
  continuityCheck,
  askWorldBible,
  recap,
  edit,
  exportPlain,
  exportMarkdown,
  blurbPitch,
}
