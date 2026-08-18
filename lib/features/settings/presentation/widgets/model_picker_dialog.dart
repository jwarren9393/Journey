import 'package:flutter/material.dart';
import 'package:journey/core/ai/models/ai_model_option.dart';
import 'package:journey/core/ai/nanogpt_model_filters.dart';

Future<String?> showGroupedModelPicker({
  required BuildContext context,
  required String title,
  required List<AiModelGroup> groups,
  String? selectedModelId,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: groups.isEmpty
              ? const Text('No models available. Check your API key and try again.')
              : ListView(
                  shrinkWrap: true,
                  children: [
                    for (final group in groups) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Text(
                          group.provider,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      for (final model in group.models)
                        ListTile(
                          title: Text(model.displayName),
                          subtitle: model.description == null
                              ? Text(model.id, style: Theme.of(context).textTheme.bodySmall)
                              : Text(model.description!),
                          selected: model.id == selectedModelId,
                          onTap: () => Navigator.of(context).pop(model.id),
                        ),
                    ],
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

Future<String?> showFlatModelPicker({
  required BuildContext context,
  required String title,
  required List<AiModelOption> models,
  String? selectedModelId,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final model in models)
                ListTile(
                  title: Text(model.displayName),
                  subtitle: Text(model.id),
                  selected: model.id == selectedModelId,
                  onTap: () => Navigator.of(context).pop(model.id),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

Future<NanoGptPickerResult?> showNanoGptModelPicker({
  required BuildContext context,
  required List<AiModelOption> models,
  String? selectedModelId,
  bool subscriptionOnly = false,
}) {
  return showDialog<NanoGptPickerResult>(
    context: context,
    builder: (context) {
      return _NanoGptModelPickerDialog(
        models: models,
        selectedModelId: selectedModelId,
        subscriptionOnly: subscriptionOnly,
      );
    },
  );
}

class NanoGptPickerResult {
  const NanoGptPickerResult({
    required this.modelId,
    required this.subscriptionOnly,
  });

  final String modelId;
  final bool subscriptionOnly;
}

class _NanoGptModelPickerDialog extends StatefulWidget {
  const _NanoGptModelPickerDialog({
    required this.models,
    required this.selectedModelId,
    required this.subscriptionOnly,
  });

  final List<AiModelOption> models;
  final String? selectedModelId;
  final bool subscriptionOnly;

  @override
  State<_NanoGptModelPickerDialog> createState() =>
      _NanoGptModelPickerDialogState();
}

class _NanoGptModelPickerDialogState extends State<_NanoGptModelPickerDialog> {
  final _queryController = TextEditingController();
  late bool _subscriptionOnly;
  String _query = '';
  String? _category;
  String? _capability;
  NanoGptModelSort _sort = NanoGptModelSort.name;

  @override
  void initState() {
    super.initState();
    _subscriptionOnly = widget.subscriptionOnly;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = NanoGptModelFilters.apply(
      widget.models,
      query: _query,
      subscriptionOnly: _subscriptionOnly,
      category: _category,
      capability: _capability,
      sort: _sort,
    );
    final categories = NanoGptModelFilters.categories(widget.models);
    final capabilities = NanoGptModelFilters.capabilities(widget.models);

    return AlertDialog(
      title: const Text('NanoGPT model'),
      content: SizedBox(
        width: 720,
        height: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchBar(
              controller: _queryController,
              hintText: 'Search models…',
              leading: const Icon(Icons.search),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Subscription models only'),
              subtitle: const Text('Hide pay-as-you-go models'),
              value: _subscriptionOnly,
              onChanged: (value) => setState(() => _subscriptionOnly = value),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DropdownButton<NanoGptModelSort>(
                  value: _sort,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sort = value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: NanoGptModelSort.name,
                      child: Text('Name'),
                    ),
                    DropdownMenuItem(
                      value: NanoGptModelSort.newest,
                      child: Text('Newest'),
                    ),
                    DropdownMenuItem(
                      value: NanoGptModelSort.context,
                      child: Text('Context'),
                    ),
                    DropdownMenuItem(
                      value: NanoGptModelSort.price,
                      child: Text('Price: low to high'),
                    ),
                    DropdownMenuItem(
                      value: NanoGptModelSort.tps,
                      child: Text('TPS'),
                    ),
                    DropdownMenuItem(
                      value: NanoGptModelSort.uptime,
                      child: Text('Uptime'),
                    ),
                  ],
                ),
                DropdownButton<String?>(
                  value: _category,
                  hint: const Text('All categories'),
                  onChanged: (value) => setState(() => _category = value),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All categories'),
                    ),
                    for (final category in categories)
                      DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                  ],
                ),
                DropdownButton<String?>(
                  value: _capability,
                  hint: const Text('Any capability'),
                  onChanged: (value) => setState(() => _capability = value),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Any capability'),
                    ),
                    for (final capability in capabilities)
                      DropdownMenuItem(
                        value: capability,
                        child: Text(capability.replaceAll('_', ' ')),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${filtered.length} models',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('Nothing matches these filters.'))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final model = filtered[index];
                        return _ModelCard(
                          model: model,
                          selected: model.id == widget.selectedModelId,
                          onTap: () => Navigator.of(context).pop(
                            NanoGptPickerResult(
                              modelId: model.id,
                              subscriptionOnly: _subscriptionOnly,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _ModelCard extends StatelessWidget {
  const _ModelCard({
    required this.model,
    required this.selected,
    required this.onTap,
  });

  final AiModelOption model;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stats = <String>[];
    if (model.contextLength != null) {
      stats.add('Context ${_formatCount(model.contextLength!)}');
    }
    if (model.maxOutputTokens != null) {
      stats.add('Max out ${_formatCount(model.maxOutputTokens!)}');
    }
    if (model.parameters != null) {
      stats.add(model.parameters!);
    }
    if (model.uptimePercent != null) {
      stats.add('Uptime ${model.uptimePercent!.round()}%');
    }
    if (model.tokensPerSecond != null) {
      stats.add('TPS ${model.tokensPerSecond!.toStringAsFixed(1)}');
    }
    if (model.timeToFirstTokenSeconds != null) {
      stats.add('TTFT ${model.timeToFirstTokenSeconds!.toStringAsFixed(1)}s');
    }
    if (model.promptPricePerMillion != null ||
        model.completionPricePerMillion != null) {
      stats.add(
        'In \$${_money(model.promptPricePerMillion)} / Out \$${_money(model.completionPricePerMillion)} per 1M',
      );
    }
    if (model.cacheReadPricePerMillion != null) {
      stats.add('Cache \$${_money(model.cacheReadPricePerMillion)} per 1M');
    }

    return Card(
      color: selected
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      model.displayName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (model.isAuto)
                    const Chip(label: Text('Auto'), visualDensity: VisualDensity.compact),
                  if (model.includedInSubscription)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Chip(
                        label: Text('Subscription'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
              Text(
                model.id,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (model.description != null) ...[
                const SizedBox(height: 6),
                Text(model.description!),
              ],
              if (stats.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final stat in stats)
                      Text(
                        stat,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                  ],
                ),
              ],
              if (model.enabledCapabilities.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final capability in model.enabledCapabilities)
                      Chip(
                        label: Text(capability.replaceAll('_', ' ')),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int value) {
    if (value >= 1000) {
      final thousands = value / 1000;
      return '${thousands.toStringAsFixed(thousands >= 10 ? 0 : 1)}K';
    }
    return '$value';
  }

  String _money(double? value) {
    if (value == null) {
      return '—';
    }
    if (value >= 10) {
      return value.toStringAsFixed(2);
    }
    return value.toStringAsFixed(3);
  }
}

String modelLabel({
  required List<AiModelOption> models,
  required String modelId,
}) {
  for (final model in models) {
    if (model.id == modelId) {
      return model.displayName;
    }
  }
  return modelId.isEmpty ? 'Select a model' : modelId;
}

String groupedModelLabel({
  required List<AiModelGroup> groups,
  required String modelId,
}) {
  for (final group in groups) {
    for (final model in group.models) {
      if (model.id == modelId) {
        return '${group.provider} · ${model.displayName}';
      }
    }
  }
  return modelId.isEmpty ? 'Select a model' : modelId;
}
