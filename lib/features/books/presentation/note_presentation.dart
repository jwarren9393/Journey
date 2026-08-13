import 'package:flutter/material.dart';
import 'package:journey/features/books/domain/models/note_status.dart';
import 'package:journey/features/books/domain/models/note_type.dart';

abstract final class NotePresentation {
  static IconData iconForType(NoteType type) {
    return switch (type) {
      NoteType.general => Icons.sticky_note_2_outlined,
      NoteType.research => Icons.link,
      NoteType.character => Icons.person_outline,
      NoteType.location => Icons.place_outlined,
      NoteType.plot => Icons.auto_graph_outlined,
      NoteType.item => Icons.inventory_2_outlined,
      NoteType.group => Icons.groups_outlined,
      NoteType.history => Icons.history_edu_outlined,
      NoteType.idea => Icons.lightbulb_outline,
    };
  }

  static Color statusColor(BuildContext context, NoteStatus status) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      NoteStatus.spark => scheme.tertiary,
      NoteStatus.draft => scheme.secondary,
      NoteStatus.canon => scheme.primary,
    };
  }
}
