import 'package:flutter/material.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/utils/error_messages.dart';

Future<void> showAiResultSheet({
  required BuildContext context,
  required AiAction action,
  required Future<AiResult> resultFuture,
  void Function(String text)? onInsert,
  void Function(String text)? onReplace,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _AiResultSheet(
        action: action,
        resultFuture: resultFuture,
        onInsert: onInsert,
        onReplace: onReplace,
      );
    },
  );
}

class _AiResultSheet extends StatelessWidget {
  const _AiResultSheet({
    required this.action,
    required this.resultFuture,
    required this.onInsert,
    this.onReplace,
  });

  final AiAction action;
  final Future<AiResult> resultFuture;
  final void Function(String text)? onInsert;
  final void Function(String text)? onReplace;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _actionLabel(action),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FutureBuilder<AiResult>(
              future: resultFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        userFacingErrorMessage(snapshot.error!),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  );
                }

                final result = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                      ),
                      child: SingleChildScrollView(
                        child: SelectableText(result.text),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (onInsert != null || onReplace != null)
                      Row(
                        children: [
                          if (onReplace != null)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  onReplace!(result.text);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Replace'),
                              ),
                            ),
                          if (onReplace != null) const SizedBox(width: 8),
                          if (onInsert != null)
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  onInsert!(result.text);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  onReplace == null ? 'Insert' : 'Append',
                                ),
                              ),
                            ),
                        ],
                      )
                    else
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _actionLabel(AiAction action) {
    return switch (action) {
      AiAction.continueWriting => 'Continue writing',
      AiAction.rephrase => 'Rephrase',
      AiAction.expand => 'Expand',
      AiAction.tighten => 'Tighten',
      AiAction.summarizeChapter => 'Chapter summary',
      AiAction.recapBook => 'Story recap',
      AiAction.sensoryEnhance => 'Sensory enhance',
      AiAction.showDontTell => "Show, don't tell",
      AiAction.toneVoiceMeter => 'Tone & voice meter',
      AiAction.continuityCheck => 'Continuity check',
      AiAction.extractEntities => 'Discover entities',
      AiAction.askWorldBible => 'Ask the world bible',
      AiAction.pacingHeatmap => 'Pacing heatmap',
      AiAction.plotBridge => 'Plot bridge',
      AiAction.blurbPitchGenerator => 'Blurb & pitch',
    };
  }
}
