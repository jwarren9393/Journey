import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:journey/core/providers/app_preferences_provider.dart';
import 'package:journey/features/books/presentation/pages/book_detail_page.dart';
import 'package:journey/features/books/presentation/pages/book_search_page.dart';
import 'package:journey/features/books/presentation/pages/note_editor_page.dart';
import 'package:journey/features/books/presentation/pages/story_lab_page.dart';
import 'package:journey/features/books/presentation/pages/library_page.dart';
import 'package:journey/features/editor/presentation/pages/editor_page.dart';
import 'package:journey/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:journey/features/settings/presentation/pages/settings_page.dart';
import 'package:journey/shared/widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);
  ref.listen(appPreferencesProvider, (_, _) {
    refreshListenable.value++;
  });
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: AppRoutes.books,
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingPage(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.books,
            name: 'books',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LibraryPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.books}/:bookId',
        name: 'book-detail',
        builder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          return BookDetailPage(bookId: bookId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.books}/:bookId/search',
        name: 'book-search',
        builder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          return BookSearchPage(bookId: bookId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.books}/:bookId/notes/:noteId',
        name: 'note-editor',
        builder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          final noteId = state.pathParameters['noteId']!;
          return NoteEditorPage(bookId: bookId, noteId: noteId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.books}/:bookId/story-lab',
        name: 'story-lab',
        builder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          final tab = state.uri.queryParameters['tab'];
          return StoryLabPage(
            bookId: bookId,
            initialTab: tab == 'brainstorm' ? 1 : 0,
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.books}/:bookId/chapters/:chapterId',
        name: 'editor',
        builder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          final chapterId = state.pathParameters['chapterId']!;
          return EditorPage(bookId: bookId, chapterId: chapterId);
        },
      ),
    ],
    redirect: (context, state) {
      final prefs = ref.read(appPreferencesProvider).value;
      final onOnboarding = state.matchedLocation == AppRoutes.onboarding;

      if (prefs != null && !prefs.onboardingCompleted && !onOnboarding) {
        return AppRoutes.onboarding;
      }
      if (prefs != null && prefs.onboardingCompleted && onOnboarding) {
        return AppRoutes.books;
      }
      if (state.uri.path == '/') {
        return AppRoutes.books;
      }
      return null;
    },
  );
});

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const books = '/books';
  static const settings = '/settings';

  static String bookDetail(String bookId) => '$books/$bookId';

  static String bookSearch(String bookId) => '$books/$bookId/search';

  static String noteEditor(String bookId, String noteId) =>
      '$books/$bookId/notes/$noteId';

  static String editor(String bookId, String chapterId) =>
      '$books/$bookId/chapters/$chapterId';

  static String storyLab(String bookId, {String? tab}) {
    final path = '$books/$bookId/story-lab';
    if (tab == null || tab.isEmpty) {
      return path;
    }
    return '$path?tab=$tab';
  }
}
