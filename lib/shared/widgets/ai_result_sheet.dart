import 'package:flutter/material.dart';
import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/utils/error_messages.dart';

Future<void> showAiResultSheet({
  required BuildContext context,
  required AiAction action,
  required Future<AiResult> resultFuture,
  void Function(String text)? onInsert,
  void Function(String text)? onReplace,
  String? replaceLabel,
  String? insertLabel,
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
        replaceLabel: replaceLabel,
        insertLabel: insertLabel,
      );
    },
  );
}

class _AiResultSheet extends StatefulWidget {
  const _AiResultSheet({
    required this.action,
    required this.resultFuture,
    required this.onInsert,
    required this.onReplace,
    this.replaceLabel,
    this.insertLabel,
  });

  final AiAction action;
  final Future<AiResult> resultFuture;
  final void Function(String text)? onInsert;
  final void Function(String text)? onReplace;
  final String? replaceLabel;
  final String? insertLabel;

  @override
  State<_AiResultSheet> createState() => _AiResultSheetState();
}

class _AiResultSheetState extends State<_AiResultSheet> {
  int _variantIndex = 0;

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
              _actionLabel(widget.action),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FutureBuilder<AiResult>(
              future: widget.resultFuture,
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
                final variants = result.variants.length > 1
                    ? result.variants
                    : [result.text];
                final currentText = variants[_variantIndex.clamp(
                  0,
                  variants.length - 1,
                )];
                final hasVariants = variants.length > 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasVariants)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'Previous variant',
                            onPressed: _variantIndex > 0
                                ? () => setState(() => _variantIndex--)
                                : null,
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Text('${_variantIndex + 1} / ${variants.length}'),
                          IconButton(
                            tooltip: 'Next variant',
                            onPressed: _variantIndex < variants.length - 1
                                ? () => setState(() => _variantIndex++)
                                : null,
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                      ),
                      child: SingleChildScrollView(
                        child: SelectableText(currentText),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.onInsert != null || widget.onReplace != null)
                      Row(
                        children: [
                          if (widget.onReplace != null)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  widget.onReplace!(currentText);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  widget.replaceLabel ??
                                      (widget.onInsert == null
                                          ? 'Apply'
                                          : 'Replace'),
                                ),
                              ),
                            ),
                          if (widget.onReplace != null &&
                              widget.onInsert != null)
                            const SizedBox(width: 8),
                          if (widget.onInsert != null)
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  widget.onInsert!(currentText);
                                  Navigator.of(context).pop();
                                },
                                child: Text(widget.insertLabel ?? 'Append'),
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
      AiAction.fixContinuity => 'Fix continuity',
      AiAction.extractEntities => 'Discover entities',
      AiAction.askWorldBible => 'Ask the world bible',
      AiAction.pacingHeatmap => 'Pacing heatmap',
      AiAction.plotBridge => 'Plot bridge',
      AiAction.blurbPitchGenerator => 'Blurb & pitch',
      AiAction.updateCanonSummary => 'Update canon summary',
      AiAction.scenePaths => 'Scene paths',
      AiAction.storyLabBrainstorm => 'Story Lab',
      AiAction.storyLabSceneIdeas => 'Scene ideas',
      AiAction.storyLabGlossary => 'Glossary',
      AiAction.storyLabSummarize => 'Summarize brainstorm',
    };
  }
}
