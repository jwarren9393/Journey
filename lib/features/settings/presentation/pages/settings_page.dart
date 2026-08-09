import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/features/settings/presentation/widgets/ai_settings_section.dart';
import 'package:journey/features/settings/presentation/widgets/appearance_settings_section.dart';
import 'package:journey/features/settings/presentation/widgets/backup_settings_section.dart';
import 'package:journey/features/settings/presentation/widgets/keyboard_shortcuts_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [
            IconButton(
              tooltip: 'Keyboard shortcuts',
              onPressed: () => KeyboardShortcutsDialog.show(context),
              icon: const Icon(Icons.keyboard_outlined),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Appearance'),
              Tab(text: 'Backup'),
              Tab(text: 'AI'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AppearanceSettingsSection(),
            BackupSettingsSection(),
            AiSettingsSection(),
          ],
        ),
      ),
    );
  }
}
