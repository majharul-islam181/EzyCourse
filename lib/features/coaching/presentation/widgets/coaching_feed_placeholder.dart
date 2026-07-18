import 'package:flutter/material.dart';

import '../../domain/entities/coaching_details_with_sessions.dart';

class CoachingFeedPlaceholder extends StatelessWidget {
  final CoachingDetailsWithSessions details;

  const CoachingFeedPlaceholder({required this.details, super.key});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Feed content for ${details.details.title} will appear here.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
