import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journey/core/ai/ai_provider_config.dart';
import 'package:journey/core/ai/clients/google_gemini_client.dart';
import 'package:journey/core/ai/models/ai_model_option.dart';
import 'package:journey/core/ai/models/nanogpt_account.dart';
import 'package:journey/core/ai/nanogpt_model_filters.dart';
import 'package:journey/core/providers/app_providers.dart';
import 'package:journey/core/utils/debouncer.dart';
import 'package:journey/core/utils/error_messages.dart';
import 'package:journey/features/settings/presentation/widgets/model_picker_dialog.dart';
import 'package:journey/shared/widgets/error_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AiSettingsSection extends ConsumerStatefulWidget {
  const AiSettingsSection({super.key});

  @override
  ConsumerState<AiSettingsSection> createState() => _AiSettingsSectionState();
}

class _AiSettingsSectionState extends ConsumerState<AiSettingsSection>
    with AutomaticKeepAliveClientMixin {
  final _googleApiKeyController = TextEditingController();
  final _nanoGptApiKeyController = TextEditingController();
  final _saveDebouncer = Debouncer(duration: const Duration(milliseconds: 400));

  AiProvider _provider = AiProvider.none;
  bool _enabled = false;
  String _googleModel = 'gemini-2.5-flash';
  String _nanoGptModel = NanoGptModelFilters.autoModelId;
  bool _nanoGptSubscriptionOnly = false;
  bool _initialized = false;
  bool _dirty = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void deactivate() {
    if (_initialized && _dirty) {
      _persist();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _saveDebouncer.dispose();
    _googleApiKeyController.dispose();
    _nanoGptApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final settingsAsync = ref.watch(aiSettingsProvider);
    final googleModelsAsync = ref.watch(
      googleModelsProvider(_googleApiKeyController.text.trim()),
    );
    final nanoGptModelsAsync = ref.watch(
      nanoGptModelsProvider(_nanoGptApiKeyController.text.trim()),
    );
    final nanoGptAccountAsync = ref.watch(
      nanoGptAccountProvider(_nanoGptApiKeyController.text.trim()),
    );

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState.fromError(
        error: error,
        onRetry: () => ref.invalidate(aiSettingsProvider),
      ),
      data: (config) {
        _hydrate(config);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'AI Assistant',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Journey supports Google Gemini (via AI Studio) and NanoGPT. '
              'Keys and the selected model are saved on this device as you change them.',
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
              onChanged: (value) => _setEnabled(value),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<AiProvider>(
              key: ValueKey(_provider),
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
                  _setProvider(value);
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
              onChanged: (_) => _scheduleSave(),
            ),
            const SizedBox(height: 12),
            googleModelsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => _modelSelector(
                label: modelLabel(models: const [], modelId: _googleModel),
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
              'Use your NanoGPT API key from nano-gpt.com/api. Auto lets NanoGPT pick a model. Remaining subscription allowance and pay-as-you-go balance show below after the key is saved.',
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
              onChanged: (_) {
                setState(() {});
                _scheduleSave();
              },
            ),
            const SizedBox(height: 12),
            nanoGptAccountAsync.when(
              loading: _nanoGptApiKeyController.text.trim().isEmpty
                  ? () => const SizedBox.shrink()
                  : () => const LinearProgressIndicator(),
              error: (error, _) => Text(
                'Could not load NanoGPT usage: ${userFacingErrorMessage(error)}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (account) => account == null
                  ? const SizedBox.shrink()
                  : _NanoGptUsageCard(
                      account: account,
                      onRefresh: _refreshNanoGpt,
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: nanoGptModelsAsync.when(
                    loading: () => _modelSelector(
                      label: modelLabel(
                        models: const [NanoGptModelFilters.autoModel],
                        modelId: _nanoGptModel,
                      ),
                      enabled: false,
                    ),
                    error: (error, _) => _modelSelector(
                      label: 'Could not load models',
                      subtitle: userFacingErrorMessage(error),
                      onTap: _refreshNanoGpt,
                    ),
                    data: (models) => _modelSelector(
                      label: modelLabel(models: models, modelId: _nanoGptModel),
                      subtitle: _nanoGptSubscriptionOnly
                          ? 'Showing subscription models'
                          : null,
                      onTap: () => _pickNanoGptModel(models),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Refresh NanoGPT',
                  onPressed: _nanoGptApiKeyController.text.trim().isEmpty
                      ? null
                      : _refreshNanoGpt,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _hydrate(AiProviderConfig config) {
    if (_dirty) {
      return;
    }
    _provider = config.provider;
    _enabled = config.enabled;
    _googleModel = config.googleModel;
    _nanoGptModel = config.nanoGptModel.isEmpty
        ? NanoGptModelFilters.autoModelId
        : config.nanoGptModel;
    _nanoGptSubscriptionOnly = config.nanoGptSubscriptionOnly;
    if (_googleApiKeyController.text != config.googleApiKey) {
      _googleApiKeyController.text = config.googleApiKey;
    }
    if (_nanoGptApiKeyController.text != config.nanoGptApiKey) {
      _nanoGptApiKeyController.text = config.nanoGptApiKey;
    }
    _initialized = true;
    if (config.nanoGptModel.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_dirty) {
          _scheduleSave();
        }
      });
    }
  }

  void _setEnabled(bool value) {
    setState(() => _enabled = value);
    _scheduleSave();
  }

  void _setProvider(AiProvider value) {
    setState(() => _provider = value);
    _scheduleSave();
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
      _scheduleSave();
    }
  }

  Future<void> _pickNanoGptModel(List<AiModelOption> models) async {
    final selected = await showNanoGptModelPicker(
      context: context,
      models: models,
      selectedModelId: _nanoGptModel,
      subscriptionOnly: _nanoGptSubscriptionOnly,
    );
    if (selected != null) {
      setState(() {
        _nanoGptModel = selected.modelId;
        _nanoGptSubscriptionOnly = selected.subscriptionOnly;
      });
      _scheduleSave();
    }
  }

  void _refreshNanoGpt() {
    final key = _nanoGptApiKeyController.text.trim();
    ref.invalidate(nanoGptModelsProvider(key));
    ref.invalidate(nanoGptAccountProvider(key));
  }

  void _scheduleSave() {
    _dirty = true;
    _saveDebouncer.run(_persist);
  }

  Future<void> _persist() async {
    if (!_initialized) {
      return;
    }
    final config = AiProviderConfig(
      provider: _provider,
      enabled: _enabled,
      googleApiKey: _googleApiKeyController.text.trim(),
      googleModel: _googleModel,
      nanoGptApiKey: _nanoGptApiKeyController.text.trim(),
      nanoGptModel: _nanoGptModel,
      nanoGptSubscriptionOnly: _nanoGptSubscriptionOnly,
    );
    await ref.read(aiSettingsProvider.notifier).save(config);
    _dirty = false;
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

class _NanoGptUsageCard extends StatelessWidget {
  const _NanoGptUsageCard({
    required this.account,
    required this.onRefresh,
  });

  final NanoGptAccount account;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'NanoGPT credits',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh usage',
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            if (account.usdBalance != null)
              Text('Pay-as-you-go balance: \$${account.usdBalance}'),
            if (account.subscriptionState != null)
              Text(
                'Subscription: ${account.subscriptionActive ? 'active' : account.subscriptionState}',
              ),
            if (account.dailyRemaining != null) ...[
              const SizedBox(height: 8),
              Text(
                'Remaining today: ${account.dailyRemaining}'
                '${account.dailyLimit != null ? ' / ${account.dailyLimit}' : ''}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (account.dailyResetAt != null)
                Text('Resets ${_formatReset(account.dailyResetAt!)}'),
            ],
            if (account.weeklyRemaining != null) ...[
              const SizedBox(height: 8),
              Text(
                'Remaining this week: ${account.weeklyRemaining}'
                '${account.weeklyLimit != null ? ' / ${account.weeklyLimit}' : ''}',
              ),
              if (account.weeklyResetAt != null)
                Text('Resets ${_formatReset(account.weeklyResetAt!)}'),
            ],
            if (account.monthlyRemaining != null) ...[
              const SizedBox(height: 4),
              Text(
                'Remaining this billing period: ${account.monthlyRemaining}'
                '${account.monthlyLimit != null ? ' / ${account.monthlyLimit}' : ''}',
              ),
              if (account.monthlyResetAt != null)
                Text('Resets ${_formatReset(account.monthlyResetAt!)}'),
            ],
            if (!account.hasSubscriptionWindow && account.usdBalance == null)
              const Text('No usage information for this key yet.'),
          ],
        ),
      ),
    );
  }

  String _formatReset(DateTime time) {
    final local = time.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$month/$day $hour:$minute';
  }
}
