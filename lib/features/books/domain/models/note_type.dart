enum NoteType {
  general,
  research,
  character,
  location,
  plot,
  item,
  group,
  history,
  idea;

  String get label => switch (this) {
        NoteType.general => 'General',
        NoteType.research => 'Research',
        NoteType.character => 'Character',
        NoteType.location => 'Place',
        NoteType.plot => 'Plot',
        NoteType.item => 'Item',
        NoteType.group => 'Group',
        NoteType.history => 'History',
        NoteType.idea => 'Idea',
      };

  String get storageValue => name;

  bool get isWorldbuilding => switch (this) {
        NoteType.character ||
        NoteType.location ||
        NoteType.plot ||
        NoteType.item ||
        NoteType.group ||
        NoteType.history =>
          true,
        _ => false,
      };

  static NoteType fromStorage(String value) {
    return NoteType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => NoteType.general,
    );
  }
}
