import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/data/backup_service.dart';
import 'package:journey/core/preferences/app_preferences.dart';
import 'package:journey/core/preferences/app_preferences_repository.dart';
import 'package:journey/core/providers/app_providers.dart';

final appPreferencesRepositoryProvider = Provider<AppPreferencesRepository>(
  (ref) => AppPreferencesRepository(ref.watch(sharedPreferencesProvider)),
);

final appPreferencesProvider =
    AsyncNotifierProvider<AppPreferencesNotifier, AppPreferences>(
  AppPreferencesNotifier.new,
);

class AppPreferencesNotifier extends AsyncNotifier<AppPreferences> {
  @override
  Future<AppPreferences> build() {
    return ref.watch(appPreferencesRepositoryProvider).load();
  }

  Future<void> savePreferences(AppPreferences preferences) async {
    // Keep prior data visible while saving so appearance sliders don't flicker.
    state = AsyncData(preferences);
    await ref.read(appPreferencesRepositoryProvider).save(preferences);
  }

  Future<void> completeOnboarding() {
    final current = state.value ?? AppPreferences.defaults;
    return savePreferences(current.copyWith(onboardingCompleted: true));
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});
