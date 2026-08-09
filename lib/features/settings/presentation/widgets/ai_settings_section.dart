import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_provider_config.dart';
import 'package:journey/core/ai/clients/google_gemini_client.dart';
import 'package:journey/core/ai/models/ai_model_option.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/core/utils/error_messages.dart';
import 'package:journey/features/settings/presentation/widgets/model_picker_dialog.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AiSettingsSection extends ConsumerStatefulWidget {
  const AiSettingsSection({super.key});

  @override
  ConsumerState<AiSettingsSection> createState() => _AiSettingsSectionState();
}

class _AiSettingsSectionState extends ConsumerState<AiSettingsSection> {
  final _googleApiKeyController = TextEditingController();
  final _nanoGptApiKeyController = TextEditingController();

  AiProvider _provider = AiProvider.none;
  bool _enabled = false;
  String _googleModel = 'gemini-2.5-flash';
  String _nanoGptModel = '';
  bool _initialized = false;

  @override
  void dispose() {
    _googleApiKeyController.dispose();
    _nanoGptApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(aiSettingsProvider);
    final googleModelsAsync = ref.watch(
      googleModelsProvider(_googleApiKeyController.text.trim()),
    );
    final nanoGptGroupsAsync = ref.watch(
      nanoGptModelGroupsProvider(_nanoGptApiKeyController.text.trim()),
    );

    ref.listen(aiSettingsProvider, (previous, next) {
      next.whenData((config) {
        if (_initialized) {
          return;
        }
        _provider = config.provider;
        _enabled = config.enabled;
        _googleModel = config.googleModel;
        _nanoGptModel = config.nanoGptModel;
        _googleApiKeyController.text = config.googleApiKey;
        _nanoGptApiKeyController.text = config.nanoGptApiKey;
        _initialized = true;
      });
    });

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState.fromError(
        error: error,
        onRetry: () => ref.invalidate(aiSettingsProvider),
      ),
      data: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'AI Assistant',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Journey supports Google Gemini (via AI Studio) and NanoGPT. '
            'Your Gemini app subscription is separate from API access — use AI Studio for an API key.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.7,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Enable AI assistant'),
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<AiProvider>(
            initialValue: _provider,
            decoration: const InputDecoration(
              labelText: 'Active provider',
              border: OutlineInputBorder(),
            ),
            items: AiProvider.values
                .map(
                  (provider) => DropdownMenuItem(
                    value: provider,
                    child: Text(_providerLabel(provider)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _provider = value);
              }
            },
          ),
          const SizedBox(height: 24),
          _sectionHeader(context, 'Google Gemini (AI Studio)'),
          const SizedBox(height: 8),
          Text(
            'Get a free API key at aistudio.google.com. This uses the Gemini API, not your Gemini consumer app login directly.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: () => _openUrl('https://aistudio.google.com/apikey'),
                child: const Text('Open AI Studio'),
              ),
              TextButton(
                onPressed: () => _openUrl(
                  'https://ai.google.dev/gemini-api/docs/api-key',
                ),
                child: const Text('API key docs'),
              ),
            ],
          ),
          TextField(
            controller: _googleApiKeyController,
            decoration: const InputDecoration(
              labelText: 'Google API key',
              border: OutlineInputBorder(),
              helperText: 'Stored locally on this device.',
            ),
            obscureText: true,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          googleModelsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => _modelSelector(
              label: groupedModelLabel(
                groups: [],
                modelId: _googleModel,
              ),
              onTap: () => _pickGoogleModel(GoogleGeminiClient.defaultModels),
            ),
            data: (models) => _modelSelector(
              label: modelLabel(models: models, modelId: _googleModel),
              onTap: () => _pickGoogleModel(models),
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader(context, 'NanoGPT'),
          const SizedBox(height: 8),
          Text(
            'Use your NanoGPT API key from nano-gpt.com/api. Models are loaded from your subscription catalog.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _openUrl('https://nano-gpt.com/api'),
            child: const Text('Open NanoGPT API keys'),
          ),
          TextField(
            controller: _nanoGptApiKeyController,
            decoration: const InputDecoration(
              labelText: 'NanoGPT API key',
              border: OutlineInputBorder(),
              helperText: 'Stored locally on this device.',
            ),
            obscureText: true,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: nanoGptGroupsAsync.when(
                  loading: () => _modelSelector(
                    label: groupedModelLabel(
                      groups: const [],
                      modelId: _nanoGptModel,
                    ),
                    enabled: false,
                  ),
                  error: (error, _) => _modelSelector(
                    label: 'Could not load models',
                    subtitle: userFacingErrorMessage(error),
                    onTap: _refreshNanoGptModels,
                  ),
                  data: (groups) => _modelSelector(
                    label: groupedModelLabel(
                      groups: groups,
                      modelId: _nanoGptModel,
                    ),
                    onTap: () => _pickNanoGptModel(groups),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Refresh NanoGPT models',
                onPressed: _nanoGptApiKeyController.text.trim().isEmpty
                    ? null
                    : _refreshNanoGptModels,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            child: const Text('Save settings'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _modelSelector({
    required String label,
    String? subtitle,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return OutlinedButton(
      onPressed: enabled ? onTap : null,
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickGoogleModel(List<AiModelOption> models) async {
    final selected = await showFlatModelPicker(
      context: context,
      title: 'Google model',
      models: models,
      selectedModelId: _googleModel,
    );
    if (selected != null) {
      setState(() => _googleModel = selected);
    }
  }

  Future<void> _pickNanoGptModel(List<AiModelGroup> groups) async {
    final selected = await showGroupedModelPicker(
      context: context,
      title: 'NanoGPT subscription model',
      groups: groups,
      selectedModelId: _nanoGptModel,
    );
    if (selected != null) {
      setState(() => _nanoGptModel = selected);
    }
  }

  void _refreshNanoGptModels() {
    ref.invalidate(
      nanoGptModelGroupsProvider(_nanoGptApiKeyController.text.trim()),
    );
  }

  Future<void> _save() async {
    final config = AiProviderConfig(
      provider: _provider,
      enabled: _enabled,
      googleApiKey: _googleApiKeyController.text.trim(),
      googleModel: _googleModel,
      nanoGptApiKey: _nanoGptApiKeyController.text.trim(),
      nanoGptModel: _nanoGptModel,
    );

    if (config.enabled &&
        config.provider != AiProvider.none &&
        !config.isConfigured) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add the API key and model for your selected provider.'),
        ),
      );
      return;
    }

    await ref.read(aiSettingsProvider.notifier).save(config);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      await Clipboard.setData(ClipboardData(text: url));
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied link: $url')),
      );
    }
  }

  String _providerLabel(AiProvider provider) {
    return switch (provider) {
      AiProvider.none => 'None',
      AiProvider.google => 'Google Gemini (AI Studio)',
      AiProvider.nanoGpt => 'NanoGPT',
    };
  }
}
