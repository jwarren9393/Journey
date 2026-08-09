import 'package:flutter/material.dart';

class PacingChip extends StatelessWidget {
  const PacingChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsForLabel(context, label);

    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: colors.foreground,
          fontSize: 12,
        ),
      ),
      backgroundColor: colors.background,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  _PacingColors _colorsForLabel(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    final normalized = label.toLowerCase();

    if (normalized.contains('action')) {
      return _PacingColors(scheme.errorContainer, scheme.onErrorContainer);
    }
    if (normalized.contains('dialogue')) {
      return _PacingColors(scheme.primaryContainer, scheme.onPrimaryContainer);
    }
    if (normalized.contains('exposition')) {
      return _PacingColors(scheme.tertiaryContainer, scheme.onTertiaryContainer);
    }
    if (normalized.contains('introspective')) {
      return _PacingColors(scheme.secondaryContainer, scheme.onSecondaryContainer);
    }
    if (normalized.contains('transition')) {
      return _PacingColors(scheme.surfaceContainerHighest, scheme.onSurfaceVariant);
    }

    return _PacingColors(scheme.surfaceContainerHigh, scheme.onSurface);
  }
}

class _PacingColors {
  const _PacingColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
