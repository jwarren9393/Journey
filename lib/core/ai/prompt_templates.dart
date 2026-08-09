import 'package:journey/core/ai/ai_context.dart';
import 'package:journey/core/ai/note_context_service.dart';
import 'package:journey/features/books/domain/models/chapter.dart';

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
      _ => systemInstruction,
    };
  }

  static String forAction(AiAction action, AiContext context) {
    return switch (action) {
      AiAction.continueWriting => _continueWriting(context),
      AiAction.rephrase =>
        'Rephrase the following while preserving meaning and voice:\n\n${context.selectedText ?? ''}',
      AiAction.expand =>
        'Expand the following with more sensory detail while keeping the same voice:\n\n${context.selectedText ?? ''}',
      AiAction.tighten =>
        'Tighten the following, removing redundancy while preserving voice:\n\n${context.selectedText ?? ''}',
      AiAction.summarizeChapter =>
        'Summarize this chapter in 2-3 sentences for the author:\n\n${context.chapter?.content ?? ''}',
      AiAction.recapBook =>
        'Recap where the reader left off in "${context.book?.title ?? 'this book'}". '
        'Latest chapter: "${context.chapter?.title ?? ''}". '
        'Write 2-4 sentences in plain language.\n\n${context.chapter?.content ?? ''}',
      AiAction.sensoryEnhance => _sensoryEnhance(context),
      AiAction.showDontTell => _showDontTell(context),
      AiAction.toneVoiceMeter => _toneVoiceMeter(context),
      AiAction.continuityCheck => _continuityCheck(context),
      AiAction.extractEntities => _extractEntities(context),
      AiAction.askWorldBible => _askWorldBible(context),
      AiAction.pacingHeatmap => _pacingHeatmap(context),
      AiAction.plotBridge => _plotBridge(context),
      AiAction.blurbPitchGenerator => _blurbPitchGenerator(context),
    };
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

    return 'Rewrite the following passage with richer $senseLabel while preserving '
        'meaning, voice, and tense. Return only the rewritten passage:\n\n'
        '${context.selectedText ?? ''}';
  }

  static String _showDontTell(AiContext context) {
    return 'The following is flat exposition that tells rather than shows. '
        'Provide 2-3 alternative versions that reveal the same meaning through '
        'action, body language, and sensory detail instead of stating it directly. '
        'Label each option as "Option 1:", "Option 2:", etc. Match the existing '
        'voice and tense:\n\n${context.selectedText ?? ''}';
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
