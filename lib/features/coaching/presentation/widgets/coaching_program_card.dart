import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';
import '../../domain/entities/coaching_program.dart';

class CoachingProgramCard extends StatelessWidget {
  final CoachingProgram program;
  final VoidCallback? onTap;

  const CoachingProgramCard({required this.program, this.onTap, super.key});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: context.radius.card),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: program.cover ?? program.thumbnail ?? '',
                    fit: BoxFit.cover,
                    placeholder: (final context, final url) {
                      return ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    },
                    errorWidget: (final context, final url, final error) {
                      return ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                  const _ImageGradientOverlay(),
                  Positioned(
                    left: context.spacing.cardPadding,
                    right: context.spacing.cardPadding,
                    bottom: context.spacing.cardPadding,
                    child: Text(
                      program.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.spacing.cardPadding),
              child: Row(
                children: [
                  Icon(
                    Icons.group_outlined,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: context.spacing.xs),
                  Expanded(
                    child: Text(
                      '${program.totalMembers} members',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(width: context.spacing.sm),
                  _StatusBadge(status: program.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageGradientOverlay extends StatelessWidget {
  const _ImageGradientOverlay();

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.72)],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isActive = status.toUpperCase() == 'ACTIVE';
    final Color badgeColor = isActive
        ? context.colors.success
        : colorScheme.error;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: context.radius.round,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.sm,
          vertical: context.spacing.xs,
        ),
        child: Text(
          status,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.labelSmall?.copyWith(
            color: badgeColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
