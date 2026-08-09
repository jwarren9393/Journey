enum NoteType {
  general,
  research,
  character,
  location,
  plot;

  String get label => switch (this) {
        NoteType.general => 'General',
        NoteType.research => 'Research',
        NoteType.character => 'Character',
        NoteType.location => 'Place',
        NoteType.plot => 'Plot',
      };

  String get storageValue => name;

  static NoteType fromStorage(String value) {
    return NoteType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => NoteType.general,
    );
  }
}
