enum NoteStatus {
  spark,
  draft,
  canon;

  String get label => switch (this) {
        NoteStatus.spark => 'Spark',
        NoteStatus.draft => 'Draft',
        NoteStatus.canon => 'Canon',
      };

  String get hint => switch (this) {
        NoteStatus.spark => 'A loose idea — not yet part of the world',
        NoteStatus.draft => 'Developing; used by AI when relevant',
        NoteStatus.canon => 'Locked as true for this book',
      };

  String get storageValue => name;

  static NoteStatus fromStorage(String value) {
    return NoteStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => NoteStatus.draft,
    );
  }
}
