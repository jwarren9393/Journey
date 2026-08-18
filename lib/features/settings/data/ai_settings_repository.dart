import 'package:journey/core/ai/ai_provider_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiSettingsRepository {
  AiSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _providerNameKey = 'ai_provider_name';
  static const _enabledKey = 'ai_enabled';
  static const _googleApiKeyKey = 'google_api_key';
  static const _googleModelKey = 'google_model';
  static const _nanoGptApiKeyKey = 'nanogpt_api_key';
  static const _nanoGptModelKey = 'nanogpt_model';
  static const _nanoGptSubscriptionOnlyKey = 'nanogpt_subscription_only';

  // Legacy keys from Phase 0.5
  static const _legacyProviderKey = 'ai_provider';
  static const _legacyApiKeyKey = 'ai_api_key';
  static const _legacyModelKey = 'ai_model';

  Future<AiProviderConfig> load() async {
    final enabled = _prefs.getBool(_enabledKey) ?? false;
    var googleApiKey = _prefs.getString(_googleApiKeyKey) ?? '';
    var googleModel = _prefs.getString(_googleModelKey) ?? 'gemini-2.5-flash';
    var nanoGptApiKey = _prefs.getString(_nanoGptApiKeyKey) ?? '';
    var nanoGptModel = _prefs.getString(_nanoGptModelKey) ?? '';
    if (nanoGptModel.trim().isEmpty) {
      nanoGptModel = 'auto-model';
    }
    final nanoGptSubscriptionOnly =
        _prefs.getBool(_nanoGptSubscriptionOnlyKey) ?? false;

    final providerName = _prefs.getString(_providerNameKey);
    if (providerName != null) {
      return AiProviderConfig(
        provider: _parseProvider(providerName),
        enabled: enabled,
        googleApiKey: googleApiKey,
        googleModel: googleModel,
        nanoGptApiKey: nanoGptApiKey,
        nanoGptModel: nanoGptModel,
        nanoGptSubscriptionOnly: nanoGptSubscriptionOnly,
      );
    }

    final legacyKey = _prefs.getString(_legacyApiKeyKey) ?? '';
    final legacyModel = _prefs.getString(_legacyModelKey) ?? '';
    final legacyIndex = _prefs.getInt(_legacyProviderKey);

    var provider = AiProvider.none;
    if (legacyIndex == 3) {
      provider = AiProvider.google;
      googleApiKey = legacyKey;
      if (legacyModel.isNotEmpty) {
        googleModel = legacyModel;
      }
    }

    return AiProviderConfig(
      provider: provider,
      enabled: enabled,
      googleApiKey: googleApiKey,
      googleModel: googleModel,
      nanoGptApiKey: nanoGptApiKey,
      nanoGptModel: nanoGptModel,
      nanoGptSubscriptionOnly: nanoGptSubscriptionOnly,
    );
  }

  Future<void> save(AiProviderConfig config) async {
    await _prefs.setString(_providerNameKey, config.provider.name);
    await _prefs.setBool(_enabledKey, config.enabled);
    await _prefs.setString(_googleApiKeyKey, config.googleApiKey);
    await _prefs.setString(_googleModelKey, config.googleModel);
    await _prefs.setString(_nanoGptApiKeyKey, config.nanoGptApiKey);
    await _prefs.setString(_nanoGptModelKey, config.nanoGptModel);
    await _prefs.setBool(
      _nanoGptSubscriptionOnlyKey,
      config.nanoGptSubscriptionOnly,
    );
  }

  AiProvider _parseProvider(String value) {
    return AiProvider.values.firstWhere(
      (provider) => provider.name == value,
      orElse: () => AiProvider.none,
    );
  }
}
