import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/ai_provider_config.dart';
import 'package:journey/core/ai/clients/google_gemini_client.dart';
import 'package:journey/core/ai/clients/nanogpt_client.dart';
import 'package:journey/core/ai/continuity_fix_parser.dart';
import 'package:journey/core/ai/extracted_entity_parser.dart';
import 'package:journey/core/ai/grow_option_parser.dart';
import 'package:journey/core/ai/lore_proposal_parser.dart';
import 'package:journey/core/ai/models/continuity_fix.dart';
import 'package:journey/core/ai/models/extracted_entity.dart';
import 'package:journey/core/ai/models/grow_option.dart';
import 'package:journey/core/ai/models/lore_proposal.dart';
import 'package:journey/core/ai/models/world_spark.dart';
import 'package:journey/core/ai/world_spark_parser.dart';
import 'package:journey/core/ai/note_context_service.dart';
import 'package:journey/core/ai/pacing_label_parser.dart';
import 'package:journey/core/ai/prompt_templates.dart';
import 'package:journey/core/ai/variants_parser.dart';
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

  static const _variantActions = {
    AiAction.rephrase,
    AiAction.expand,
    AiAction.sensoryEnhance,
    AiAction.showDontTell,
  };

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

      final extractedEntities = action == AiAction.extractEntities ||
              action == AiAction.storyLabGlossary
          ? ExtractedEntityParser.parse(
              text,
              existingNoteTitles: NoteContextService.existingNoteTitles(
                context.notes,
              ),
            )
          : <ExtractedEntity>[];

      final pacingLabels = action == AiAction.pacingHeatmap
          ? PacingLabelParser.parse(text, context.recentChapters)
          : <String, String>{};

      final continuityFixes = action == AiAction.fixContinuity
          ? ContinuityFixParser.parse(text, notes: context.notes)
          : <ContinuityFix>[];

      final loreProposals = action == AiAction.promoteToLore ||
              action == AiAction.deepenNote ||
              action == AiAction.evolveWorldState
          ? LoreProposalParser.parse(
              text,
              notes: context.notes,
              relationships: context.relationships,
            )
          : <LoreProposal>[];

      final worldSparks = action == AiAction.foundationsSparks
          ? WorldSparkParser.parse(text)
          : <WorldSpark>[];

      final growOptions = action == AiAction.foundationsGrow
          ? GrowOptionParser.parse(text)
          : <GrowOption>[];

      final variants = _variantActions.contains(action) ||
              (action == AiAction.showDontTell && context.requestVariants)
          ? VariantsParser.parse(text)
          : <String>[];

      final displayText = variants.length > 1 ? variants.first : text;

      return AiResult(
        text: displayText,
        action: action,
        extractedEntities: extractedEntities,
        pacingLabels: pacingLabels,
        variants: variants,
        continuityFixes: continuityFixes,
        worldSparks: worldSparks,
        growOptions: growOptions,
        loreProposals: loreProposals,
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
