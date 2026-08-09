import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:journey/core/ai/models/ai_model_option.dart';

class NanoGptClient {
  const NanoGptClient();

  static const baseUrl = 'https://nano-gpt.com/api';

  Future<String> complete({
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String prompt,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/chat/completions');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'system', 'content': systemInstruction},
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw NanoGptException(_errorMessage(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = body['choices'] as List<dynamic>?;
    final message = choices?.first as Map<String, dynamic>?;
    final content = (message?['message'] as Map<String, dynamic>?)?['content'];

    if (content is! String || content.trim().isEmpty) {
      throw const NanoGptException('NanoGPT returned an empty response.');
    }

    return content.trim();
  }

  Future<List<AiModelGroup>> listSubscriptionModels(String apiKey) async {
    final uri = Uri.parse('$baseUrl/subscription/v1/models?detailed=true');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode == 401) {
      throw const NanoGptException('Invalid NanoGPT API key.');
    }

    if (response.statusCode != 200) {
      throw NanoGptException(_errorMessage(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (body['data'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    final models = data.map(_mapModel).toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    return _groupModels(models);
  }

  AiModelOption _mapModel(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final ownedBy = json['owned_by'] as String? ?? _providerFromId(id);
    final name = json['name'] as String? ?? _displayNameFromId(id);

    return AiModelOption(
      id: id,
      displayName: name,
      provider: _formatProviderName(ownedBy),
      description: json['description'] as String?,
    );
  }

  List<AiModelGroup> _groupModels(List<AiModelOption> models) {
    final grouped = <String, List<AiModelOption>>{};
    for (final model in models) {
      grouped.putIfAbsent(model.provider, () => []).add(model);
    }

    final groups = grouped.entries
        .map(
          (entry) => AiModelGroup(
            provider: entry.key,
            models: entry.value,
          ),
        )
        .toList()
      ..sort((a, b) => a.provider.compareTo(b.provider));

    return groups;
  }

  String _providerFromId(String id) {
    final slashIndex = id.indexOf('/');
    if (slashIndex <= 0) {
      return 'Other';
    }
    return id.substring(0, slashIndex);
  }

  String _displayNameFromId(String id) {
    final slashIndex = id.indexOf('/');
    if (slashIndex < 0 || slashIndex >= id.length - 1) {
      return id;
    }
    return id.substring(slashIndex + 1).replaceAll('-', ' ');
  }

  String _formatProviderName(String raw) {
    return switch (raw.toLowerCase()) {
      'openai' => 'OpenAI',
      'anthropic' => 'Anthropic',
      'google' => 'Google',
      'meta' => 'Meta',
      'x-ai' => 'xAI',
      'deepseek' => 'DeepSeek',
      'qwen' => 'Qwen',
      'moonshotai' => 'Moonshot',
      'z-ai' || 'zai-org' => 'Zhipu',
      _ => raw
          .split(RegExp(r'[-_]'))
          .where((part) => part.isNotEmpty)
          .map(
            (part) => part[0].toUpperCase() + part.substring(1).toLowerCase(),
          )
          .join(' '),
    };
  }

  String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final error = body['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }
      final message = body['message'] as String?;
      if (message != null && message.isNotEmpty) {
        return message;
      }
    } catch (_) {
      // Fall through to generic message.
    }

    return 'NanoGPT request failed (${response.statusCode}).';
  }
}

class NanoGptException implements Exception {
  const NanoGptException(this.message);

  final String message;

  @override
  String toString() => message;
}
