import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/ai_provider_config.dart';
import 'package:journey/core/ai/ai_service.dart';
import 'package:journey/core/ai/clients/google_gemini_client.dart';
import 'package:journey/core/ai/clients/nanogpt_client.dart';
import 'package:journey/core/ai/models/ai_model_option.dart';
import 'package:journey/core/ai/models/nanogpt_account.dart';
import 'package:journey/core/ai/nanogpt_model_filters.dart';
import 'package:journey/core/database/app_database.dart';
import 'package:journey/features/books/data/repositories/book_repository_impl.dart';
import 'package:journey/features/books/data/repositories/chapter_repository_impl.dart';
import 'package:journey/features/books/domain/repositories/book_repository.dart';
import 'package:journey/features/books/domain/repositories/chapter_repository.dart';
import 'package:journey/features/books/data/repositories/canon_pin_repository_impl.dart';
import 'package:journey/features/books/data/repositories/note_relationship_repository_impl.dart';
import 'package:journey/features/books/data/repositories/note_repository_impl.dart';
import 'package:journey/features/books/data/repositories/story_lab_repository_impl.dart';
import 'package:journey/features/books/domain/repositories/canon_pin_repository.dart';
import 'package:journey/features/books/domain/repositories/note_relationship_repository.dart';
import 'package:journey/features/books/domain/repositories/story_lab_repository.dart';
import 'package:journey/features/books/data/repositories/tag_repository_impl.dart';
import 'package:journey/features/books/domain/repositories/note_repository.dart';
import 'package:journey/features/books/domain/repositories/tag_repository.dart';
import 'package:journey/features/settings/data/ai_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl(ref.watch(databaseProvider));
});

final chapterRepositoryProvider = Provider<ChapterRepository>((ref) {
  return ChapterRepositoryImpl(ref.watch(databaseProvider));
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepositoryImpl(ref.watch(databaseProvider));
});

final noteRelationshipRepositoryProvider =
    Provider<NoteRelationshipRepository>((ref) {
  return NoteRelationshipRepositoryImpl(ref.watch(databaseProvider));
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepositoryImpl(ref.watch(databaseProvider));
});

final canonPinRepositoryProvider = Provider<CanonPinRepository>((ref) {
  return CanonPinRepositoryImpl(ref.watch(databaseProvider));
});

final storyLabRepositoryProvider = Provider<StoryLabRepository>((ref) {
  return StoryLabRepositoryImpl(ref.watch(databaseProvider));
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

final aiSettingsRepositoryProvider = Provider<AiSettingsRepository>((ref) {
  return AiSettingsRepository(ref.watch(sharedPreferencesProvider));
});

final aiSettingsProvider =
    AsyncNotifierProvider<AiSettingsNotifier, AiProviderConfig>(
  AiSettingsNotifier.new,
);

class AiSettingsNotifier extends AsyncNotifier<AiProviderConfig> {
  @override
  Future<AiProviderConfig> build() {
    return ref.watch(aiSettingsRepositoryProvider).load();
  }

  Future<void> save(AiProviderConfig config) async {
    await ref.read(aiSettingsRepositoryProvider).save(config);
    state = AsyncData(config);
  }
}

final googleGeminiClientProvider = Provider<GoogleGeminiClient>(
  (ref) => const GoogleGeminiClient(),
);

final nanoGptClientProvider = Provider<NanoGptClient>(
  (ref) => const NanoGptClient(),
);

final aiServiceProvider = Provider<AiService>(
  (ref) => JourneyAiService(
    googleClient: ref.watch(googleGeminiClientProvider),
    nanoGptClient: ref.watch(nanoGptClientProvider),
  ),
);

final googleModelsProvider = FutureProvider.family<List<AiModelOption>, String>(
  (ref, apiKey) async {
    if (apiKey.trim().isEmpty) {
      return GoogleGeminiClient.defaultModels;
    }

    return ref.watch(googleGeminiClientProvider).listModels(apiKey.trim());
  },
);

final nanoGptModelsProvider =
    FutureProvider.family<List<AiModelOption>, String>((ref, apiKey) async {
  if (apiKey.trim().isEmpty) {
    return [NanoGptModelFilters.autoModel];
  }

  return ref.watch(nanoGptClientProvider).listModels(apiKey.trim());
});

final nanoGptAccountProvider =
    FutureProvider.family<NanoGptAccount?, String>((ref, apiKey) async {
  if (apiKey.trim().isEmpty) {
    return null;
  }

  return ref.watch(nanoGptClientProvider).fetchAccount(apiKey.trim());
});

final aiActionRunnerProvider = Provider<AiActionRunner>((ref) {
  return AiActionRunner(ref);
});

class AiActionRunner {
  AiActionRunner(this._ref);

  final Ref _ref;

  Future<AiResult> run({
    required AiAction action,
    required AiContext context,
  }) async {
    final config = await _ref.read(aiSettingsProvider.future);
    return _ref.read(aiServiceProvider).run(
          action: action,
          context: context,
          config: config,
        );
  }
}
