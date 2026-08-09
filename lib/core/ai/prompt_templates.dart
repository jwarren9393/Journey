import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/note_context_service.dart';
import 'package:journey/core/ai/variants_parser.dart';
import 'package:journey/features/books/domain/models/chapter.dart';
import 'package:journey/features/books/domain/models/story_lab_message.dart';

abstract final class PromptTemplates {
  static const systemInstruction = '''
You are a thoughtful writing assistant embedded in Journey, a book-writing app.
Help the author improve their fiction prose. Match the existing voice, tense, and point of view.
Do not add meta commentary, labels, or markdown unless asked. Return only the requested writing output.
''';

  static String systemInstructionFor(AiAction action) {
    return switch (action) {
      AiAction.continuityCheck => '''
You are a continuity editor for a fiction manuscript.
Compare chapter prose against the author's worldbuilding notes and flag subtle contradictions.
Be specific, cite the note when relevant, and stay concise. Do not rewrite the prose.
''',
      AiAction.fixContinuity => '''
You are a continuity editor for a fiction manuscript.
Propose note updates to resolve contradictions between chapter prose and worldbuilding notes.
Return only a valid JSON array. No markdown or commentary outside the JSON.
''',
      AiAction.askWorldBible => '''
You are a worldbuilding reference assistant for Journey.
Answer only from the provided notes. If the notes do not contain the answer, say so clearly.
Do not invent facts. Keep answers concise and practical for a writer at the keyboard.
''',
      AiAction.extractEntities => '''
You are an entity discovery assistant for Journey.
Return only a valid JSON array. No markdown, commentary, or code fences.
''',
      AiAction.pacingHeatmap => '''
You are a story structure analyst for Journey.
Return only a valid JSON array. No markdown, commentary, or code fences.
''',
      AiAction.plotBridge => '''
You are a plot-structure assistant for Journey.
Suggest brief bridge ideas only — not prose. Be practical and specific.
''',
      AiAction.blurbPitchGenerator => '''
You are a publishing copywriter helping an author polish marketing materials for their book.
Write compelling, honest copy grounded in the provided summary and outlines. Do not invent major plot twists.
''',
      AiAction.updateCanonSummary => '''
You are a continuity archivist for Journey.
Summarize established story facts as clinical bullet points. No prose voice, metaphors, or RP style.
Revise the existing canon summary when provided; do not repeat unchanged facts unnecessarily.
''',
      AiAction.scenePaths => '''
You are a scene-brainstorm assistant for Journey.
Suggest brief beat ideas for what could happen next in a scene — not drafted prose.
''',
      AiAction.storyLabBrainstorm => '''
You are a creative brainstorming partner in Journey's Story Lab.
Help the author explore ideas, world details, and plot possibilities.
Do not write finished manuscript prose. Do not claim to save anything — the author decides what to keep.
''',
      AiAction.storyLabSceneIdeas => '''
You are a scene-idea generator for Journey's Story Lab.
Suggest short scene starters the author could develop. Ideas only, not full scenes.
''',
      AiAction.storyLabGlossary => '''
You are a glossary extractor for Journey's Story Lab.
Return only a valid JSON array. No markdown or commentary outside the JSON.
''',
      AiAction.storyLabSummarize => '''
You are a Story Lab archivist for Journey.
Fold brainstorm messages into a concise world-summary in clinical bullet points.
No RP voice or metaphors.
''',
      _ => systemInstruction,
    };
  }

  static String forAction(AiAction action, AiContext context) {
    final bookPrefix = _bookContextPrefix(context);

    return switch (action) {
      AiAction.continueWriting =>
        '$bookPrefix${_continueWriting(context)}',
      AiAction.rephrase =>
        '$bookPrefix${_rephrase(context)}',
      AiAction.expand =>
        '$bookPrefix${_expand(context)}',
      AiAction.tighten =>
        '$bookPrefix${_tighten(context)}',
      AiAction.summarizeChapter =>
        '$bookPrefix${_summarizeChapter(context)}',
      AiAction.recapBook =>
        '$bookPrefix${_recapBook(context)}',
      AiAction.sensoryEnhance =>
        '$bookPrefix${_sensoryEnhance(context)}',
      AiAction.showDontTell =>
        '$bookPrefix${_showDontTell(context)}',
      AiAction.toneVoiceMeter =>
        '$bookPrefix${_toneVoiceMeter(context)}',
      AiAction.continuityCheck =>
        '$bookPrefix${_continuityCheck(context)}',
      AiAction.fixContinuity =>
        '$bookPrefix${_fixContinuity(context)}',
      AiAction.extractEntities =>
        '$bookPrefix${_extractEntities(context)}',
      AiAction.askWorldBible =>
        '$bookPrefix${_askWorldBible(context)}',
      AiAction.pacingHeatmap =>
        '$bookPrefix${_pacingHeatmap(context)}',
      AiAction.plotBridge =>
        '$bookPrefix${_plotBridge(context)}',
      AiAction.blurbPitchGenerator =>
        '$bookPrefix${_blurbPitchGenerator(context)}',
      AiAction.updateCanonSummary =>
        '$bookPrefix${_updateCanonSummary(context)}',
      AiAction.scenePaths =>
        '$bookPrefix${_scenePaths(context)}',
      AiAction.storyLabBrainstorm =>
        '$bookPrefix${_storyLabBrainstorm(context)}',
      AiAction.storyLabSceneIdeas =>
        '$bookPrefix${_storyLabSceneIdeas(context)}',
      AiAction.storyLabGlossary =>
        '$bookPrefix${_storyLabGlossary(context)}',
      AiAction.storyLabSummarize =>
        '$bookPrefix${_storyLabSummarize(context)}',
    };
  }

  static String _bookContextPrefix(AiContext context) {
    final book = context.book;
    if (book == null) {
      return '';
    }

    return NoteContextService.formatBookContext(
      authorsNote: book.authorsNote,
      canonSummary: book.canonSummary,
    );
  }

  static String _variantInstruction(AiContext context) {
    if (!context.requestVariants) {
      return '';
    }

    final count = context.variantCount.clamp(2, 4);
    return 'Provide exactly $count distinct alternatives separated by '
        '"${VariantsParser.separator}" on its own line. '
        'No numbering or labels — only the rewritten text for each variant.\n\n';
  }

  static String _continueWriting(AiContext context) {
    final source = context.selectedText?.trim();
    if (source != null && source.isNotEmpty) {
      return 'Continue the following passage in the same voice and tense. '
          'Write the next paragraph only:\n\n$source';
    }

    final chapterContent = context.chapter?.content.trim() ?? '';
    if (chapterContent.isEmpty) {
      return 'Write an opening paragraph for this chapter. '
          'Chapter title: "${context.chapter?.title ?? 'Untitled'}".';
    }

    final tail = chapterContent.length > 2500
        ? chapterContent.substring(chapterContent.length - 2500)
        : chapterContent;

    return 'Continue the following passage in the same voice and tense. '
        'Write the next paragraph only:\n\n$tail';
  }

  static String _rephrase(AiContext context) {
    return '${_variantInstruction(context)}'
        'Rephrase the following while preserving meaning and voice:\n\n'
        '${context.selectedText ?? ''}';
  }

  static String _expand(AiContext context) {
    return '${_variantInstruction(context)}'
        'Expand the following with more sensory detail while keeping the same voice:\n\n'
        '${context.selectedText ?? ''}';
  }

  static String _tighten(AiContext context) {
    return 'Tighten the following, removing redundancy while preserving voice:\n\n'
        '${context.selectedText ?? ''}';
  }

  static String _summarizeChapter(AiContext context) {
    return 'Summarize this chapter in 2-3 sentences for the author:\n\n'
        '${context.chapter?.content ?? ''}';
  }

  static String _recapBook(AiContext context) {
    return 'Recap where the reader left off in "${context.book?.title ?? 'this book'}". '
        'Latest chapter: "${context.chapter?.title ?? ''}". '
        'Write 2-4 sentences in plain language.\n\n${context.chapter?.content ?? ''}';
  }

  static String _sensoryEnhance(AiContext context) {
    final senseLabel = switch (context.sensorySense) {
      SensorySense.auto =>
        'the most fitting sensory channel (sight, sound, smell, touch, or taste)',
      SensorySense.sight => 'sight and visual detail',
      SensorySense.sound => 'sound and auditory detail',
      SensorySense.smell => 'smell and scent',
      SensorySense.touch => 'touch and physical sensation',
      SensorySense.taste => 'taste',
    };

    return '${_variantInstruction(context)}'
        'Rewrite the following passage with richer $senseLabel while preserving '
        'meaning, voice, and tense. Return only the rewritten passage:\n\n'
        '${context.selectedText ?? ''}';
  }

  static String _showDontTell(AiContext context) {
    final count = context.requestVariants ? context.variantCount.clamp(2, 4) : 3;
    return 'The following is flat exposition that tells rather than shows. '
        'Provide $count alternative versions that reveal the same meaning through '
        'action, body language, and sensory detail instead of stating it directly. '
        'Separate each version with "${VariantsParser.separator}" on its own line. '
        'Match the existing voice and tense:\n\n${context.selectedText ?? ''}';
  }

  static String _toneVoiceMeter(AiContext context) {
    final currentContent = context.chapter?.content.trim() ?? '';
    final referenceBlock = _referenceBlock(context);

    return 'Analyze the writing voice of the REFERENCE below, then compare the '
        'CURRENT CHAPTER passage to it.\n\n'
        '$referenceBlock\n\n'
        'CURRENT CHAPTER ("${context.chapter?.title ?? 'Untitled'}"):\n'
        '$currentContent\n\n'
        'Provide a brief analysis in 3-6 sentences. Note pacing differences, '
        'vocabulary drift, tone mismatches, or anachronisms. Be specific but '
        'concise. Do not rewrite the text.';
  }

  static String _continuityCheck(AiContext context) {
    final notesBlock = NoteContextService.formatNotesForPrompt(context.notes);
    final chapterContent = context.chapter?.content.trim() ?? '';

    return 'Review the CURRENT CHAPTER against the WORLDBUILDING NOTES. '
        'Flag subtle contradictions in character details, locations, timeline, '
        'or physical descriptions. If nothing conflicts, say so briefly.\n\n'
        'WORLDBUILDING NOTES:\n$notesBlock\n\n'
        'CURRENT CHAPTER ("${context.chapter?.title ?? 'Untitled'}"):\n'
        '$chapterContent';
  }

  static String _fixContinuity(AiContext context) {
    final notesBlock = NoteContextService.formatNotesForPrompt(context.notes);
    final chapterContent = context.chapter?.content.trim() ?? '';

    return 'Review the CURRENT CHAPTER against the WORLDBUILDING NOTES. '
        'For each contradiction, propose an updated note body that resolves it.\n\n'
        'WORLDBUILDING NOTES:\n$notesBlock\n\n'
        'CURRENT CHAPTER ("${context.chapter?.title ?? 'Untitled'}"):\n'
        '$chapterContent\n\n'
        'Return a JSON array. Each object must have:\n'
        '- "noteTitle": exact note title from the list above\n'
        '- "proposedContent": full revised note body text\n'
        '- "reason": one sentence explaining the fix\n\n'
        'Return only the JSON array. If no fixes are needed, return [].';
  }

  static String _extractEntities(AiContext context) {
    final existingTitles = NoteContextService.existingNoteTitles(context.notes);
    final existingList = existingTitles.isEmpty
        ? '(none)'
        : existingTitles.join(', ');
    final manuscript = _formatChaptersForPrompt(context.recentChapters);

    return 'Scan the MANUSCRIPT EXCERPTS below for newly introduced proper nouns: '
        'characters, places, and notable items. Skip names already in EXISTING NOTES.\n\n'
        'EXISTING NOTES:\n$existingList\n\n'
        'MANUSCRIPT EXCERPTS:\n$manuscript\n\n'
        'Return a JSON array of up to 8 discoveries. Each object must have:\n'
        '- "name": string\n'
        '- "type": "character" | "location" | "general"\n'
        '- "description": one sentence pulled from or summarizing the manuscript\n\n'
        'Return only the JSON array.';
  }

  static String _askWorldBible(AiContext context) {
    final notesBlock = NoteContextService.formatNotesForPrompt(context.notes);
    final question = context.userPrompt?.trim() ?? '';

    return "Answer the author's question using only the WORLDBUILDING NOTES below.\n\n"
        'QUESTION:\n$question\n\n'
        'WORLDBUILDING NOTES:\n$notesBlock';
  }

  static String _pacingHeatmap(AiContext context) {
    final chaptersBlock = _formatChaptersForPacing(context.recentChapters);

    return 'Analyze the pacing and dominant scene type of each chapter below using '
        'its OUTLINE SUMMARY and optional BODY EXCERPT.\n\n'
        'Assign exactly ONE label per chapter from:\n'
        'High Action, Dialogue Heavy, Exposition, Introspective, Mixed, Transition\n\n'
        '$chaptersBlock\n\n'
        'Return a JSON array. Each object must have:\n'
        '- "title": chapter title (exact match)\n'
        '- "label": one of the labels above\n\n'
        'Return only the JSON array.';
  }

  static String _plotBridge(AiContext context) {
    final before = context.plotBridgeBefore;
    final target = context.plotBridgeTarget;
    final after = context.plotBridgeAfter;

    final beforeExcerpt = _excerpt(before?.content ?? '', maxLength: 1500);
    final targetOutline = target?.outlineSummary.trim().isEmpty ?? true
        ? '(no outline yet)'
        : target!.outlineSummary.trim();
    final afterOutline = after?.outlineSummary.trim().isEmpty ?? true
        ? '(no outline yet)'
        : after!.outlineSummary.trim();

    return 'Help bridge a plot gap between two chapters. Suggest exactly 3 short '
        'bridge concepts for the TARGET chapter — idea sparks only, not prose.\n\n'
        'CHAPTER N ("${before?.title ?? 'Previous'}"):\n'
        '$beforeExcerpt\n\n'
        'TARGET CHAPTER N+1 ("${target?.title ?? 'Bridge chapter'}"):\n'
        'Outline: $targetOutline\n\n'
        'CHAPTER N+2 ("${after?.title ?? 'Next'}"):\n'
        'Outline: $afterOutline\n\n'
        'Label the concepts as "1.", "2.", and "3." with one sentence each.';
  }

  static String _blurbPitchGenerator(AiContext context) {
    final book = context.book;
    final description = book?.description.trim().isEmpty ?? true
        ? '(no book description yet)'
        : book!.description.trim();
    final outlines = _formatChapterOutlines(context.recentChapters);

    return 'Draft marketing materials for this book using the BOOK SUMMARY and CHAPTER '
        'OUTLINES below. Stay faithful to what is provided.\n\n'
        'BOOK: "${book?.title ?? 'Untitled'}"\n'
        'SUMMARY:\n$description\n\n'
        'CHAPTER OUTLINES:\n$outlines\n\n'
        'Provide these sections with the exact headings below:\n\n'
        'TAGLINE:\n(one compelling line)\n\n'
        'HOOK:\n(1-2 sentences)\n\n'
        'BACK-COVER BLURB:\n(2-3 short paragraphs)\n\n'
        'QUERY PITCH:\n(2-3 paragraphs for a literary agent; mention genre and tone)';
  }

  static String _updateCanonSummary(AiContext context) {
    final book = context.book;
    final existing = book?.canonSummary.trim().isEmpty ?? true
        ? '(no canon summary yet)'
        : book!.canonSummary.trim();
    final manuscript = _formatChaptersForPrompt(context.recentChapters);
    final focus = context.chapter;

    final focusBlock = focus != null
        ? 'FOCUS CHAPTER ("${focus.title}"):\n${_excerpt(focus.content, maxLength: 4000)}\n\n'
        : '';

    return 'Update the CANON SUMMARY with clinical bullet facts from the manuscript below. '
        'Include character states, relationships, timeline events, secrets, and open threads. '
        'Revise stale facts when the manuscript contradicts them.\n\n'
        'EXISTING CANON SUMMARY:\n$existing\n\n'
        '$focusBlock'
        'MANUSCRIPT TO FOLD IN:\n$manuscript\n\n'
        'Return only the updated canon summary as bullet points (use "- " prefix).';
  }

  static String _scenePaths(AiContext context) {
    final selected = context.selectedText?.trim();
    final chapterTail = _excerpt(context.chapter?.content ?? '', maxLength: 2000);
    final sceneText = selected?.isNotEmpty == true ? selected! : chapterTail;

    return 'At this point in the scene, suggest exactly 6 brief beat ideas for what '
        'could happen next. One sentence each. Ideas only — not prose.\n\n'
        'SCENE CONTEXT:\n$sceneText\n\n'
        'Label as "1." through "6."';
  }

  static String _storyLabBrainstorm(AiContext context) {
    final pins = _formatCanonPins(context);
    final notes = NoteContextService.formatNotesForPrompt(context.notes);
    final history = _formatStoryLabHistory(context.storyLabMessages);
    final message = context.userPrompt?.trim() ?? '';

    return 'Brainstorm with the author in Story Lab. Respond helpfully to their message.\n\n'
        '${pins.isNotEmpty ? 'CANON PINS:\n$pins\n\n' : ''}'
        '${notes.isNotEmpty ? 'RELEVANT NOTES:\n$notes\n\n' : ''}'
        '${history.isNotEmpty ? 'RECENT BRAINSTORM:\n$history\n\n' : ''}'
        "AUTHOR'S MESSAGE:\n$message";
  }

  static String _storyLabSceneIdeas(AiContext context) {
    final pins = _formatCanonPins(context);
    final summary = context.book?.storyLabSummary.trim().isEmpty ?? true
        ? ''
        : 'STORY LAB SUMMARY:\n${context.book!.storyLabSummary.trim()}\n\n';

    return 'Generate 6 short scene starter ideas for this book project. '
        'One sentence each, labeled "1." through "6." Ideas only.\n\n'
        '$summary${pins.isNotEmpty ? 'CANON PINS:\n$pins\n\n' : ''}';
  }

  static String _storyLabGlossary(AiContext context) {
    final history = _formatStoryLabHistory(context.storyLabMessages);
    final summary = context.book?.storyLabSummary.trim() ?? '';

    return 'Extract proper nouns and terms from the Story Lab context below. '
        'Skip common words.\n\n'
        'STORY LAB SUMMARY:\n${summary.isEmpty ? '(none)' : summary}\n\n'
        'BRAINSTORM MESSAGES:\n$history\n\n'
        'Return a JSON array of up to 12 entries. Each object:\n'
        '- "name": string\n'
        '- "type": "character" | "location" | "general"\n'
        '- "description": one sentence definition\n\n'
        'Return only the JSON array.';
  }

  static String _storyLabSummarize(AiContext context) {
    final existing = context.book?.storyLabSummary.trim().isEmpty ?? true
        ? '(no summary yet)'
        : context.book!.storyLabSummary.trim();
    final history = _formatStoryLabHistory(context.storyLabMessages);
    final pins = _formatCanonPins(context);

    return 'Fold the Story Lab brainstorm into a concise bullet summary. '
        'Clinical facts only — no RP voice.\n\n'
        'EXISTING SUMMARY:\n$existing\n\n'
        '${pins.isNotEmpty ? 'CANON PINS:\n$pins\n\n' : ''}'
        'MESSAGES TO FOLD:\n$history\n\n'
        'Return only the updated summary as bullet points (use "- " prefix).';
  }

  static String _formatCanonPins(AiContext context) {
    if (context.canonPins.isEmpty) {
      return '';
    }
    return context.canonPins.map((pin) => '- ${pin.text}').join('\n');
  }

  static String _formatStoryLabHistory(List<StoryLabMessage> messages) {
    if (messages.isEmpty) {
      return '(no messages yet)';
    }

    final recent = messages.length > 20
        ? messages.sublist(messages.length - 20)
        : messages;

    return recent
        .map(
          (message) => message.role == StoryLabRole.user
              ? 'Author: ${message.content}'
              : 'Assistant: ${message.content}',
        )
        .join('\n');
  }

  static String _formatChaptersForPacing(List<Chapter> chapters) {
    if (chapters.isEmpty) {
      return '(No chapters provided.)';
    }

    final buffer = StringBuffer();
    for (final chapter in chapters) {
      final outline = chapter.outlineSummary.trim().isEmpty
          ? '(no outline yet)'
          : chapter.outlineSummary.trim();
      final excerpt = _excerpt(chapter.content, maxLength: 500);

      buffer.writeln('--- ${chapter.title} ---');
      buffer.writeln('Outline: $outline');
      if (excerpt.isNotEmpty) {
        buffer.writeln('Excerpt: $excerpt');
      }
      buffer.writeln();
    }

    return buffer.toString().trim();
  }

  static String _formatChapterOutlines(List<Chapter> chapters) {
    if (chapters.isEmpty) {
      return '(No chapters provided.)';
    }

    final buffer = StringBuffer();
    for (final chapter in chapters) {
      final outline = chapter.outlineSummary.trim().isEmpty
          ? '(no outline yet)'
          : chapter.outlineSummary.trim();
      buffer.writeln('- ${chapter.title}: $outline');
    }
    return buffer.toString().trim();
  }

  static String _excerpt(String content, {required int maxLength}) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    if (trimmed.length <= maxLength) {
      return trimmed;
    }
    return trimmed.substring(trimmed.length - maxLength);
  }

  static String _referenceBlock(AiContext context) {
    final persona = context.userPrompt?.trim();
    if (persona != null && persona.isNotEmpty) {
      return 'REFERENCE (target voice/persona):\n$persona';
    }

    final reference = context.referenceChapter;
    if (reference != null) {
      final content = reference.content.trim();
      final excerpt = content.length > 2500
          ? content.substring(content.length - 2500)
          : content;
      return 'REFERENCE CHAPTER ("${reference.title}"):\n$excerpt';
    }

    return 'REFERENCE: (none provided — compare against a neutral literary fiction voice)';
  }

  static String _formatChaptersForPrompt(List<Chapter> chapters) {
    if (chapters.isEmpty) {
      return '(No manuscript text provided.)';
    }

    final buffer = StringBuffer();
    for (final chapter in chapters) {
      final content = chapter.content.trim();
      if (content.isEmpty) {
        continue;
      }
      final excerpt = content.length > 3000
          ? content.substring(content.length - 3000)
          : content;
      buffer.writeln('--- ${chapter.title} ---');
      buffer.writeln(excerpt);
      buffer.writeln();
    }

    final result = buffer.toString().trim();
    return result.isEmpty ? '(No manuscript text provided.)' : result;
  }
}
