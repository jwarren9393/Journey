import 'package:journey/core/ai/nanogpt_model_filters.dart';

enum AiProvider {
  none,
  google,
  nanoGpt,
}

class AiProviderConfig {
  const AiProviderConfig({
    this.provider = AiProvider.none,
    this.enabled = false,
    this.googleApiKey = '',
    this.googleModel = 'gemini-2.5-flash',
    this.nanoGptApiKey = '',
    this.nanoGptModel = NanoGptModelFilters.autoModelId,
    this.nanoGptSubscriptionOnly = false,
  });

  final AiProvider provider;
  final bool enabled;
  final String googleApiKey;
  final String googleModel;
  final String nanoGptApiKey;
  final String nanoGptModel;
  final bool nanoGptSubscriptionOnly;

  String get activeApiKey => switch (provider) {
        AiProvider.google => googleApiKey,
        AiProvider.nanoGpt => nanoGptApiKey,
        AiProvider.none => '',
      };

  String get activeModel => switch (provider) {
        AiProvider.google => googleModel,
        AiProvider.nanoGpt => nanoGptModel,
        AiProvider.none => '',
      };

  bool get isConfigured =>
      enabled &&
      provider != AiProvider.none &&
      activeApiKey.trim().isNotEmpty &&
      activeModel.trim().isNotEmpty;

  AiProviderConfig copyWith({
    AiProvider? provider,
    bool? enabled,
    String? googleApiKey,
    String? googleModel,
    String? nanoGptApiKey,
    String? nanoGptModel,
    bool? nanoGptSubscriptionOnly,
  }) {
    return AiProviderConfig(
      provider: provider ?? this.provider,
      enabled: enabled ?? this.enabled,
      googleApiKey: googleApiKey ?? this.googleApiKey,
      googleModel: googleModel ?? this.googleModel,
      nanoGptApiKey: nanoGptApiKey ?? this.nanoGptApiKey,
      nanoGptModel: nanoGptModel ?? this.nanoGptModel,
      nanoGptSubscriptionOnly:
          nanoGptSubscriptionOnly ?? this.nanoGptSubscriptionOnly,
    );
  }
}
