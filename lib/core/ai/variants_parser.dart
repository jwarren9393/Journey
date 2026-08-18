abstract final class VariantsParser {
  static const separator = '---VARIANT---';

  static List<String> parse(String raw) {
    final parts = raw.split(separator);
    final variants = parts
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (variants.length > 1) {
      return variants;
    }

    final numbered = RegExp(
      r'(?:^|\n)Option\s+\d+:\s*',
      multiLine: true,
    ).allMatches(raw);

    if (numbered.length >= 2) {
      final options = <String>[];
      final splits = raw.split(RegExp(r'(?:^|\n)Option\s+\d+:\s*', multiLine: true));
      for (final split in splits) {
        final trimmed = split.trim();
        if (trimmed.isNotEmpty) {
          options.add(trimmed);
        }
      }
      if (options.length >= 2) {
        return options;
      }
    }

    return variants.isEmpty ? [raw.trim()] : variants;
  }
}
