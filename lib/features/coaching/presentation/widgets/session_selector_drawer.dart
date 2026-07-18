import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/coaching_details_with_sessions.dart';
import '../../domain/entities/coaching_session.dart';

class SessionSelectorDrawer extends StatelessWidget {
  final CoachingDetailsWithSessions details;
  final Set<int> expandedParentIds;
  final int? selectedSessionId;
  final ValueChanged<int> onToggleParent;
  final ValueChanged<CoachingSession> onSelectSession;

  const SessionSelectorDrawer({
    required this.details,
    required this.expandedParentIds,
    required this.selectedSessionId,
    required this.onToggleParent,
    required this.onSelectSession,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _DrawerHeader(details: details)),
        SliverList.builder(
          itemBuilder: (final BuildContext context, final int index) {
            final CoachingSession parent = details.parentSessions[index];
            final List<CoachingSession> children = details.childSessionsOf(
              parent.id,
            );
            final bool isExpanded = expandedParentIds.contains(parent.id);
            final bool isSelected = selectedSessionId == parent.id;
            final bool isCurrent =
                parent.id == details.currentSession.currentSessionParentId ||
                parent.id == details.currentSession.currentSessionId;

            return _ParentSessionTile(
              session: parent,
              children: children,
              isExpanded: isExpanded,
              isSelected: isSelected,
              isCurrent: isCurrent,
              selectedSessionId: selectedSessionId,
              currentSessionId: details.currentSession.currentSessionId,
              onToggle: () => onToggleParent(parent.id),
              onSelect: onSelectSession,
            );
          },
          itemCount: details.parentSessions.length,
        ),
      ],
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final CoachingDetailsWithSessions details;

  const _DrawerHeader({required this.details});

  @override
  Widget build(final BuildContext context) {
    final String? backgroundUrl =
        details.details.bannerImage ?? details.details.featureImage;

    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _NetworkImage(imageUrl: backgroundUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black45, Colors.black87],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: _NetworkImage(imageUrl: details.details.featureImage),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.details.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    shadows: const [
                      Shadow(color: Colors.black87, blurRadius: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${details.details.membersCount} members • '
                  '${_formatStartDate(details.details.startDate)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParentSessionTile extends StatelessWidget {
  final CoachingSession session;
  final List<CoachingSession> children;
  final bool isExpanded;
  final bool isSelected;
  final bool isCurrent;
  final int? selectedSessionId;
  final int? currentSessionId;
  final VoidCallback onToggle;
  final ValueChanged<CoachingSession> onSelect;

  const _ParentSessionTile({
    required this.session,
    required this.children,
    required this.isExpanded,
    required this.isSelected,
    required this.isCurrent,
    required this.selectedSessionId,
    required this.currentSessionId,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int completion = _completionPercentage(session, children);

    return Column(
      children: [
        Material(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          child: ListTile(
            onTap: () {
              onSelect(session);
              onToggle();
            },
            leading: CircleAvatar(
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.calendar_today_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            title: Text(session.sessionName),
            subtitle: session.sessionDate == null
                ? null
                : Text(_formatSessionDate(session.sessionDate)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Tag(
                  text: '$completion%',
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 6),
                  _Tag(
                    text: 'Current',
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ],
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0,
          child: ClipRect(
            child: Column(
              children: [
                for (int index = 0; index < children.length; index++)
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + (50 * index)),
                    builder:
                        (
                          final BuildContext context,
                          final double value,
                          final Widget? child,
                        ) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 8 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                    child: _ChildSessionTile(
                      session: children[index],
                      isSelected: selectedSessionId == children[index].id,
                      isCurrent: currentSessionId == children[index].id,
                      onTap: () => onSelect(children[index]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChildSessionTile extends StatelessWidget {
  final CoachingSession session;
  final bool isSelected;
  final bool isCurrent;
  final VoidCallback onTap;

  const _ChildSessionTile({
    required this.session,
    required this.isSelected,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color foregroundColor = session.isCompleted
        ? Colors.green
        : colorScheme.onSurfaceVariant;
    final Color backgroundColor = session.isCompleted
        ? Colors.green.withValues(alpha: 0.12)
        : isSelected
        ? colorScheme.primary.withValues(alpha: 0.1)
        : Colors.transparent;

    return Material(
      color: backgroundColor,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 48, right: 16),
        onTap: onTap,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: session.isCompleted
              ? Colors.green.withValues(alpha: 0.18)
              : colorScheme.surfaceContainerHighest,
          child: Icon(
            session.isCompleted ? Icons.check : Icons.calendar_today_outlined,
            size: 18,
            color: foregroundColor,
          ),
        ),
        title: Text(
          session.sessionName,
          style: TextStyle(color: foregroundColor),
        ),
        subtitle: session.sessionDate == null
            ? null
            : Text(
                _formatSessionDate(session.sessionDate),
                style: TextStyle(color: foregroundColor),
              ),
        trailing: isCurrent
            ? _Tag(
                text: 'Current',
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;

  const _Tag({
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: foregroundColor,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  final String? imageUrl;

  const _NetworkImage({required this.imageUrl});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return ColoredBox(
        color: colorScheme.surfaceContainerHighest,
        child: Icon(Icons.image_outlined, color: colorScheme.onSurfaceVariant),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (final BuildContext context, final String url) {
        return ColoredBox(
          color: colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator.adaptive()),
        );
      },
      errorWidget:
          (final BuildContext context, final String url, final Object error) {
            return ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.broken_image_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            );
          },
    );
  }
}

String _formatStartDate(final DateTime? date) {
  if (date == null) {
    return 'No start date';
  }

  return DateFormat('d MMM yyyy').format(date);
}

String _formatSessionDate(final DateTime? date) {
  if (date == null) {
    return '';
  }

  return DateFormat('EEE: d MMM').format(date);
}

int _completionPercentage(
  final CoachingSession parent,
  final List<CoachingSession> children,
) {
  if (children.isEmpty) {
    return parent.isCompleted ? 100 : 0;
  }

  final int completedCount = children
      .where((final CoachingSession session) => session.isCompleted)
      .length;

  return ((completedCount / children.length) * 100).round();
}
