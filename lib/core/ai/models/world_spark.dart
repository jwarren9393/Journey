class WorldSpark {
  const WorldSpark({
    required this.title,
    required this.vibe,
    required this.picture,
    required this.wound,
    required this.tone,
    required this.canon,
  });

  final String title;
  final String vibe;
  final String picture;
  final String wound;
  final String tone;
  final List<String> canon;

  String get canonBullets => canon
      .map((line) => line.trim().startsWith('-') ? line.trim() : '- ${line.trim()}')
      .where((line) => line.length > 2)
      .join('\n');

  String toNoteBody() {
    final buffer = StringBuffer()
      ..writeln(vibe.trim())
      ..writeln()
      ..writeln(picture.trim());
    if (wound.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('The wound: ${wound.trim()}');
    }
    if (tone.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Tone: ${tone.trim()}');
    }
    if (canon.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Canon:')
        ..writeln(canonBullets);
    }
    return buffer.toString().trim();
  }
}
