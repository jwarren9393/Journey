import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:journey/core/ai/models/ai_model_option.dart';
import 'package:journey/core/ai/models/nanogpt_account.dart';
import 'package:journey/core/ai/nanogpt_model_filters.dart';

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

  Future<List<AiModelOption>> listModels(String apiKey) async {
    final all = await _fetchModelList('$baseUrl/v1/models?detailed=true', apiKey);
    var subscription = <AiModelOption>[];
    try {
      subscription = await _fetchModelList(
        '$baseUrl/subscription/v1/models?detailed=true',
        apiKey,
      );
    } catch (_) {
      // Catalog still usable without the subscription-only list.
    }

    final subscriptionIds = {
      for (final model in subscription) model.id,
    };

    final byId = <String, AiModelOption>{};
    for (final model in all) {
      byId[model.id] = model.copyWith(
        includedInSubscription: subscriptionIds.contains(model.id) || model.isAuto,
      );
    }
    for (final model in subscription) {
      byId.putIfAbsent(
        model.id,
        () => model.copyWith(includedInSubscription: true),
      );
    }

    final models = byId.values.toList();
    if (!models.any((model) => model.id == NanoGptModelFilters.autoModelId)) {
      models.insert(0, NanoGptModelFilters.autoModel);
    }

    return models;
  }

  Future<NanoGptAccount> fetchAccount(String apiKey) async {
    Map<String, dynamic>? usage;
    Map<String, dynamic>? balance;
    Object? usageError;
    Object? balanceError;

    try {
      usage = await _getJson('$baseUrl/subscription/v1/usage', apiKey);
    } catch (error) {
      usageError = error;
    }
    try {
      balance = await _getJson(
        '$baseUrl/check-balance',
        apiKey,
        method: 'POST',
      );
    } catch (error) {
      balanceError = error;
    }

    if (usage == null && balance == null) {
      final error = usageError ?? balanceError;
      if (error is NanoGptException) {
        throw error;
      }
      throw const NanoGptException('Could not load NanoGPT usage.');
    }
    final usageJson = usage ?? const <String, dynamic>{};
    final balanceJson = balance ?? const <String, dynamic>{};
    final daily = _asMap(usageJson['daily']);
    final weekly = _asMap(usageJson['weekly']);
    final monthly = _asMap(usageJson['monthly']);
    final limits = _asMap(usageJson['limits']);

    return NanoGptAccount(
      usdBalance: _readString(balanceJson['usd_balance']),
      nanoBalance: _readString(balanceJson['nano_balance']),
      subscriptionActive: usageJson['active'] == true,
      subscriptionState: _readString(usageJson['state']),
      dailyUsed: _readInt(daily['used']),
      dailyRemaining: _readInt(daily['remaining']),
      dailyLimit: _readInt(limits['daily']) ?? _readInt(daily['limit']),
      dailyResetAt: _readDate(daily['resetAt']),
      weeklyUsed: _readInt(weekly['used']),
      weeklyRemaining: _readInt(weekly['remaining']),
      weeklyLimit: _readInt(limits['weekly']) ?? _readInt(weekly['limit']),
      weeklyResetAt: _readDate(weekly['resetAt']),
      monthlyUsed: _readInt(monthly['used']),
      monthlyRemaining: _readInt(monthly['remaining']),
      monthlyLimit: _readInt(limits['monthly']) ?? _readInt(monthly['limit']),
      monthlyResetAt: _readDate(monthly['resetAt']),
    );
  }

  Future<List<AiModelOption>> _fetchModelList(String url, String apiKey) async {
    final json = await _getJson(url, apiKey);
    if (json == null) {
      return const [];
    }
    final data = (json['data'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>();
    return data.map(mapModel).toList();
  }

  Future<Map<String, dynamic>?> _getJson(
    String url,
    String apiKey, {
    String method = 'GET',
  }) async {
    final uri = Uri.parse(url);
    final headers = {'Authorization': 'Bearer $apiKey', 'x-api-key': apiKey};
    final response = method == 'POST'
        ? await http.post(uri, headers: headers)
        : await http.get(uri, headers: headers);

    if (response.statusCode == 401) {
      throw const NanoGptException('Invalid NanoGPT API key.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }
    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  static AiModelOption mapModel(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final ownedBy = json['owned_by'] as String? ?? _providerFromId(id);
    final name = json['name'] as String? ?? _displayNameFromId(id);
    final stats = _asMap(json['stats']);
    final pricing = _asMap(json['pricing']);
    final capabilities = _readCapabilities(json['capabilities']);
    final isAuto = id == NanoGptModelFilters.autoModelId ||
        id.startsWith('auto-model');

    return AiModelOption(
      id: id,
      displayName: isAuto ? (name == id ? 'Auto' : name) : name,
      provider: isAuto ? 'NanoGPT' : _formatProviderName(ownedBy),
      description: _readString(json['description']),
      category: _readString(json['category']),
      contextLength: _readInt(json['context_length'] ?? json['context']),
      maxOutputTokens: _readInt(
        json['max_output_tokens'] ?? json['max_output'],
      ),
      parameters: _readString(json['parameters'] ?? json['params']),
      created: _readDate(json['created'] ?? json['date_added']),
      uptimePercent: _readDouble(
        json['uptime'] ?? json['uptime_percent'] ?? stats['uptime'],
      ),
      tokensPerSecond: _readDouble(
        json['tps'] ?? json['tokens_per_second'] ?? stats['tps'],
      ),
      timeToFirstTokenSeconds: _readDouble(
        json['ttft'] ?? json['time_to_first_token'] ?? stats['ttft'],
      ),
      promptPricePerMillion: _readDouble(pricing['prompt'] ?? json['input']),
      completionPricePerMillion: _readDouble(
        pricing['completion'] ?? json['output'],
      ),
      cacheReadPricePerMillion: _readCachePerMillion(pricing),
      includedInSubscription: _readSubscriptionIncluded(json),
      isAuto: isAuto,
      capabilities: capabilities,
    );
  }

  static bool _readSubscriptionIncluded(Map<String, dynamic> json) {
    if (json['included_in_subscription'] == true || json['subscription'] == true) {
      return true;
    }
    final subscription = _asMap(json['subscription']);
    return subscription['included'] == true;
  }

  static double? _readCachePerMillion(Map<String, dynamic> pricing) {
    final perMillion = _readDouble(
      pricing['cache'] ?? pricing['cache_read'] ?? pricing['cacheRead'],
    );
    if (perMillion != null) {
      return perMillion;
    }
    final per1k = _readDouble(pricing['cacheReadInputPer1kTokens']);
    if (per1k == null) {
      return null;
    }
    return per1k * 1000;
  }

  static Map<String, bool> _readCapabilities(Object? raw) {
    if (raw is! Map) {
      return const {};
    }
    final capabilities = <String, bool>{};
    raw.forEach((key, value) {
      if (key is String && value == true) {
        capabilities[key] = true;
      }
    });
    return capabilities;
  }

  static Map<String, dynamic> _asMap(Object? value) {
    return value is Map<String, dynamic> ? value : const {};
  }

  static String? _readString(Object? value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    if (value is String) {
      return int.tryParse(value.split('.').first);
    }
    return null;
  }

  static double? _readDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      final cleaned = value.replaceAll('%', '').trim();
      return double.tryParse(cleaned);
    }
    return null;
  }

  static DateTime? _readDate(Object? value) {
    if (value is int) {
      if (value > 1000000000000) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String _providerFromId(String id) {
    final slashIndex = id.indexOf('/');
    if (slashIndex <= 0) {
      return 'Other';
    }
    return id.substring(0, slashIndex);
  }

  static String _displayNameFromId(String id) {
    final slashIndex = id.indexOf('/');
    if (slashIndex < 0 || slashIndex >= id.length - 1) {
      return id;
    }
    return id.substring(slashIndex + 1).replaceAll('-', ' ');
  }

  static String _formatProviderName(String raw) {
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
