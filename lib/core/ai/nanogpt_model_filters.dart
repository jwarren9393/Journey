import 'package:journey/core/ai/models/ai_model_option.dart';

enum NanoGptModelSort {
  name,
  newest,
  context,
  price,
  tps,
  uptime,
}

abstract final class NanoGptModelFilters {
  static const autoModelId = 'auto-model';

  static const autoModel = AiModelOption(
    id: autoModelId,
    displayName: 'Auto',
    provider: 'NanoGPT',
    description:
        'Lets NanoGPT choose a model for each request. Good when you do not want to pick one.',
    isAuto: true,
    includedInSubscription: true,
  );

  static List<AiModelOption> apply(
    Iterable<AiModelOption> models, {
    String query = '',
    bool subscriptionOnly = false,
    String? category,
    String? capability,
    NanoGptModelSort sort = NanoGptModelSort.name,
  }) {
    final needle = query.trim().toLowerCase();
    final filtered = models.where((model) {
      if (subscriptionOnly && !model.includedInSubscription && !model.isAuto) {
        return false;
      }
      if (category != null &&
          category.isNotEmpty &&
          (model.category ?? '').toLowerCase() != category.toLowerCase()) {
        return false;
      }
      if (capability != null && capability.isNotEmpty) {
        if (model.capabilities[capability] != true) {
          return false;
        }
      }
      if (needle.isEmpty) {
        return true;
      }
      return model.displayName.toLowerCase().contains(needle) ||
          model.id.toLowerCase().contains(needle) ||
          model.provider.toLowerCase().contains(needle) ||
          (model.description ?? '').toLowerCase().contains(needle) ||
          (model.category ?? '').toLowerCase().contains(needle);
    }).toList();

    filtered.sort((a, b) {
      if (a.isAuto != b.isAuto) {
        return a.isAuto ? -1 : 1;
      }
      switch (sort) {
        case NanoGptModelSort.name:
          return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
        case NanoGptModelSort.newest:
          return (b.created ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(a.created ?? DateTime.fromMillisecondsSinceEpoch(0));
        case NanoGptModelSort.context:
          return (b.contextLength ?? 0).compareTo(a.contextLength ?? 0);
        case NanoGptModelSort.price:
          return (a.promptPricePerMillion ?? 1e9)
              .compareTo(b.promptPricePerMillion ?? 1e9);
        case NanoGptModelSort.tps:
          return (b.tokensPerSecond ?? 0).compareTo(a.tokensPerSecond ?? 0);
        case NanoGptModelSort.uptime:
          return (b.uptimePercent ?? 0).compareTo(a.uptimePercent ?? 0);
      }
    });

    return filtered;
  }

  static List<String> categories(Iterable<AiModelOption> models) {
    final values = models
        .map((model) => model.category?.trim())
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return values;
  }

  static List<String> capabilities(Iterable<AiModelOption> models) {
    final values = <String>{};
    for (final model in models) {
      values.addAll(model.enabledCapabilities);
    }
    final list = values.toList()..sort();
    return list;
  }
}
