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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'vibe': vibe,
      'picture': picture,
      'wound': wound,
      'tone': tone,
      'canon': canon,
    };
  }

  factory WorldSpark.fromJson(Map<String, dynamic> json) {
    return WorldSpark(
      title: json['title'] as String? ?? '',
      vibe: json['vibe'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
      wound: json['wound'] as String? ?? '',
      tone: json['tone'] as String? ?? '',
      canon: (json['canon'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
    );
  }

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
