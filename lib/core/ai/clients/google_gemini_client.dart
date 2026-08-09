import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:journey/core/ai/models/ai_model_option.dart';

class GoogleGeminiClient {
  const GoogleGeminiClient();

  static const defaultModels = [
    AiModelOption(
      id: 'gemini-2.5-flash',
      displayName: 'Gemini 2.5 Flash',
      provider: 'Google',
    ),
    AiModelOption(
      id: 'gemini-2.5-pro',
      displayName: 'Gemini 2.5 Pro',
      provider: 'Google',
    ),
    AiModelOption(
      id: 'gemini-2.0-flash',
      displayName: 'Gemini 2.0 Flash',
      provider: 'Google',
    ),
    AiModelOption(
      id: 'gemini-2.0-flash-lite',
      displayName: 'Gemini 2.0 Flash Lite',
      provider: 'Google',
    ),
  ];

  Future<String> complete({
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String prompt,
  }) async {
    final generativeModel = GenerativeModel(
      model: model,
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
    );

    final response = await generativeModel.generateContent([Content.text(prompt)]);
    final text = response.text?.trim();

    if (text == null || text.isEmpty) {
      throw const GoogleGeminiException('Gemini returned an empty response.');
    }

    return text;
  }

  Future<List<AiModelOption>> listModels(String apiKey) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw GoogleGeminiException(
        'Failed to list Gemini models (${response.statusCode}).',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final models = (body['models'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .where((model) {
          final methods = model['supportedGenerationMethods'] as List<dynamic>?;
          return methods?.contains('generateContent') ?? false;
        })
        .map((model) {
          final name = model['name'] as String? ?? '';
          final id = name.replaceFirst('models/', '');
          final displayName = model['displayName'] as String? ?? id;
          return AiModelOption(
            id: id,
            displayName: displayName,
            provider: 'Google',
            description: model['description'] as String?,
          );
        })
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    if (models.isEmpty) {
      return defaultModels;
    }

    return models;
  }
}

class GoogleGeminiException implements Exception {
  const GoogleGeminiException(this.message);

  final String message;

  @override
  String toString() => message;
}
