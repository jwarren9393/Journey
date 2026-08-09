import 'package:flutter/material.dart';
import 'package:journey/core/utils/error_messages.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    super.key,
  });

  factory ErrorState.fromError({
    required Object error,
    VoidCallback? onRetry,
    IconData icon = Icons.error_outline,
  }) {
    return ErrorState(
      message: userFacingErrorMessage(error),
      onRetry: onRetry,
      icon: icon,
    );
  }

  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 56,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: 0.7,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void showErrorSnackBar(BuildContext context, Object error) {
  showAppSnackBar(context, userFacingErrorMessage(error));
}
