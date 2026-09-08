import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          theme: AppTheme.light(
            background: prefs.backgroundPreset,
            accent: prefs.accentPreset,
          ),
          darkTheme: AppTheme.dark(
            background: prefs.backgroundPreset,
            accent: prefs.accentPreset,
          ),
          themeMode: prefs.themeMode,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            final systemScale = media.textScaler.scale(1.0);
            return _SystemBarsSync(
              child: MediaQuery(
                data: media.copyWith(
                  textScaler:
                      TextScaler.linear(systemScale * prefs.uiFontScale),
                ),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
          routerConfig: router,
        ),
      ),
    );
  }
}

/// Syncs the Android system UI overlay style (status/nav bar icons) with the
/// current theme brightness, and prevents content from sliding behind the
/// system navigation bar via [SafeArea].
class _SystemBarsSync extends StatefulWidget {
  const _SystemBarsSync({required this.child});

  final Widget child;

  @override
  State<_SystemBarsSync> createState() => _SystemBarsSyncState();
}

class _SystemBarsSyncState extends State<_SystemBarsSync> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final brightness = Theme.of(context).brightness;
      final iconBrightness = brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: iconBrightness,
          statusBarBrightness: brightness,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: iconBrightness,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Only pad the bottom (system navigation bar). AppBar handles the status
      // bar inset, and we don't want to interfere with that.
      top: false,
      bottom: true,
      child: widget.child,
    );
  }
}
