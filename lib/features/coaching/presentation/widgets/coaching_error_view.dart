import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';

class CoachingErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CoachingErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(context.spacing.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: colorScheme.error),
          SizedBox(height: context.spacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.md),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
