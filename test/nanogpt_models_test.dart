import 'package:flutter_test/flutter_test.dart';
import 'package:journey/core/ai/clients/nanogpt_client.dart';
import 'package:journey/core/ai/nanogpt_model_filters.dart';

void main() {
  test('NanoGptClient.mapModel reads stats, pricing, and capabilities', () {
    final model = NanoGptClient.mapModel({
      'id': 'google/gemini-3.7-flash',
      'owned_by': 'google',
      'name': 'Gemini 3.7 Flash',
      'description': 'Frontier Flash model',
      'category': 'Roleplay',
      'context_length': 131072,
      'max_output_tokens': 32768,
      'parameters': '24B',
      'created': 1735689600,
      'uptime': 99,
      'tps': 22.4,
      'ttft': 3.5,
      'pricing': {'prompt': 0.11, 'completion': 0.14},
      'capabilities': {'vision': true, 'reasoning': false, 'tool_calling': true},
      'subscription': {'included': true},
    });

    expect(model.displayName, 'Gemini 3.7 Flash');
    expect(model.provider, 'Google');
    expect(model.category, 'Roleplay');
    expect(model.contextLength, 131072);
    expect(model.maxOutputTokens, 32768);
    expect(model.parameters, '24B');
    expect(model.uptimePercent, 99);
    expect(model.tokensPerSecond, 22.4);
    expect(model.timeToFirstTokenSeconds, 3.5);
    expect(model.promptPricePerMillion, 0.11);
    expect(model.enabledCapabilities, containsAll(['vision', 'tool_calling']));
    expect(model.enabledCapabilities, isNot(contains('reasoning')));
    expect(model.includedInSubscription, isTrue);
  });

  test('mapModel treats auto-model as NanoGPT Auto', () {
    final model = NanoGptClient.mapModel({
      'id': 'auto-model',
      'owned_by': 'nano-gpt',
      'name': 'auto-model',
    });

    expect(model.isAuto, isTrue);
    expect(model.displayName, 'Auto');
    expect(model.provider, 'NanoGPT');
  });

  test('filters keep Auto, honor subscription toggle, search, and sort', () {
    final paid = NanoGptClient.mapModel({
      'id': 'paid/model',
      'name': 'Paid Model',
      'owned_by': 'paid',
      'context_length': 8000,
    });
    final sub = NanoGptClient.mapModel({
      'id': 'sub/model',
      'name': 'Sub Model',
      'owned_by': 'sub',
      'context_length': 32000,
    }).copyWith(includedInSubscription: true);

    final filtered = NanoGptModelFilters.apply(
      [paid, sub, NanoGptModelFilters.autoModel],
      subscriptionOnly: true,
      sort: NanoGptModelSort.context,
    );

    expect(filtered.first.id, NanoGptModelFilters.autoModelId);
    expect(filtered.map((model) => model.id), ['auto-model', 'sub/model']);

    final searched = NanoGptModelFilters.apply(
      [paid, sub, NanoGptModelFilters.autoModel],
      query: 'paid',
    );
    expect(searched.single.id, 'paid/model');
  });
}
