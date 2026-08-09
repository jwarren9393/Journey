import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/ai_provider_config.dart';
import 'package:journey/core/ai/clients/google_gemini_client.dart';
import 'package:journey/core/ai/clients/nanogpt_client.dart';
import 'package:journey/core/ai/models/extracted_entity.dart';
import 'package:journey/core/ai/extracted_entity_parser.dart';
import 'package:journey/core/ai/note_context_service.dart';
import 'package:journey/core/ai/pacing_label_parser.dart';
import 'package:journey/core/ai/prompt_templates.dart';
import 'package:journey/core/utils/error_messages.dart';

abstract interface class AiService {
  Future<AiResult> run({
    required AiAction action,
    required AiContext context,
    required AiProviderConfig config,
  });
}

class JourneyAiService implements AiService {
  const JourneyAiService({
    GoogleGeminiClient? googleClient,
    NanoGptClient? nanoGptClient,
  })  : _googleClient = googleClient ?? const GoogleGeminiClient(),
        _nanoGptClient = nanoGptClient ?? const NanoGptClient();

  final GoogleGeminiClient _googleClient;
  final NanoGptClient _nanoGptClient;

  @override
  Future<AiResult> run({
    required AiAction action,
    required AiContext context,
    required AiProviderConfig config,
  }) async {
    if (!config.enabled) {
      return AiResult(
        action: action,
        text: 'Enable the AI assistant in Settings to use this feature.',
      );
    }

    if (!config.isConfigured) {
      return AiResult(
        action: action,
        text:
            'AI is not fully configured. Add your API key and model in Settings.',
      );
    }

    final prompt = PromptTemplates.forAction(action, context);
    final systemInstruction = PromptTemplates.systemInstructionFor(action);

    try {
      final text = switch (config.provider) {
        AiProvider.google => await _googleClient.complete(
            apiKey: config.googleApiKey,
            model: config.googleModel,
            systemInstruction: systemInstruction,
            prompt: prompt,
          ),
        AiProvider.nanoGpt => await _nanoGptClient.complete(
            apiKey: config.nanoGptApiKey,
            model: config.nanoGptModel,
            systemInstruction: systemInstruction,
            prompt: prompt,
          ),
        AiProvider.none => throw const AiServiceException(
            'Select Google or NanoGPT in Settings.',
          ),
      };

      final extractedEntities = action == AiAction.extractEntities
          ? ExtractedEntityParser.parse(
              text,
              existingNoteTitles: NoteContextService.existingNoteTitles(
                context.notes,
              ),
            )
          : const <ExtractedEntity>[];

      final pacingLabels = action == AiAction.pacingHeatmap
          ? PacingLabelParser.parse(text, context.recentChapters)
          : const <String, String>{};

      return AiResult(
        text: text,
        action: action,
        extractedEntities: extractedEntities,
        pacingLabels: pacingLabels,
      );
    } on GoogleGeminiException catch (error) {
      throw AiServiceException('Google Gemini: ${error.message}');
    } on NanoGptException catch (error) {
      throw AiServiceException('NanoGPT: ${error.message}');
    } catch (error) {
      if (error is AiServiceException) {
        rethrow;
      }
      throw AiServiceException(userFacingErrorMessage(error));
    }
  }
}

class AiServiceException implements Exception {
  const AiServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
