import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/app/router.dart';
import 'package:journey/core/constants/app_constants.dart';
import 'package:journey/core/preferences/app_preferences.dart';
import 'package:journey/core/providers/app_preferences_provider.dart';
import 'package:journey/core/theme/app_theme.dart';
import 'package:journey/features/settings/presentation/widgets/keyboard_shortcuts_dialog.dart';

class JourneyApp extends ConsumerWidget {
  const JourneyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final prefsAsync = ref.watch(appPreferencesProvider);
    final prefs = prefsAsync.value ?? AppPreferences.defaults;

    return Shortcuts(
      shortcuts: AppShortcuts.global,
      child: Actions(
        actions: {
          OpenSettingsIntent: CallbackAction<OpenSettingsIntent>(
            onInvoke: (_) {
              router.go(AppRoutes.settings);
              return null;
            },
          ),
          ShowShortcutsIntent: CallbackAction<ShowShortcutsIntent>(
            onInvoke: (_) {
              final context = router.routerDelegate.navigatorKey.currentContext;
              if (context != null) {
                KeyboardShortcutsDialog.show(context);
              }
              return null;
            },
          ),
        },
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: prefs.themeMode,
          routerConfig: router,
        ),
      ),
    );
  }
}
