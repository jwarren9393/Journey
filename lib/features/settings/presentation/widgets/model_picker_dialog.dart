import 'package:flutter/material.dart';
import 'package:journey/core/ai/models/ai_model_option.dart';

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
