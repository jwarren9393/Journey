class AiModelOption {
  const AiModelOption({
    required this.id,
    required this.displayName,
    required this.provider,
    this.description,
    this.category,
    this.contextLength,
    this.maxOutputTokens,
    this.parameters,
    this.created,
    this.uptimePercent,
    this.tokensPerSecond,
    this.timeToFirstTokenSeconds,
    this.promptPricePerMillion,
    this.completionPricePerMillion,
    this.cacheReadPricePerMillion,
    this.includedInSubscription = false,
    this.isAuto = false,
    this.capabilities = const {},
  });

  final String id;
  final String displayName;
  final String provider;
  final String? description;
  final String? category;
  final int? contextLength;
  final int? maxOutputTokens;
  final String? parameters;
  final DateTime? created;
  final double? uptimePercent;
  final double? tokensPerSecond;
  final double? timeToFirstTokenSeconds;
  final double? promptPricePerMillion;
  final double? completionPricePerMillion;
  final double? cacheReadPricePerMillion;
  final bool includedInSubscription;
  final bool isAuto;
  final Map<String, bool> capabilities;

  List<String> get enabledCapabilities => capabilities.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  AiModelOption copyWith({
    bool? includedInSubscription,
  }) {
    return AiModelOption(
      id: id,
      displayName: displayName,
      provider: provider,
      description: description,
      category: category,
      contextLength: contextLength,
      maxOutputTokens: maxOutputTokens,
      parameters: parameters,
      created: created,
      uptimePercent: uptimePercent,
      tokensPerSecond: tokensPerSecond,
      timeToFirstTokenSeconds: timeToFirstTokenSeconds,
      promptPricePerMillion: promptPricePerMillion,
      completionPricePerMillion: completionPricePerMillion,
      cacheReadPricePerMillion: cacheReadPricePerMillion,
      includedInSubscription: includedInSubscription ?? this.includedInSubscription,
      isAuto: isAuto,
      capabilities: capabilities,
    );
  }
}

class AiModelGroup {
  const AiModelGroup({
    required this.provider,
    required this.models,
  });

  final String provider;
  final List<AiModelOption> models;
}
