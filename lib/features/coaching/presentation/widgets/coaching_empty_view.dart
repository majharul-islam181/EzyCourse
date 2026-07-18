import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';

class CoachingEmptyView extends StatelessWidget {
  const CoachingEmptyView({super.key});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(context.spacing.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 72,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: context.spacing.md),
          Text(
            'No coaching programs found',
            textAlign: TextAlign.center,
            style: context.text.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
