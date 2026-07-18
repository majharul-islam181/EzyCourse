import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/coaching_feed_bloc.dart';
import '../bloc/coaching_feed_event.dart';
import '../bloc/coaching_feed_state.dart';
import 'coaching_error_view.dart';
import 'coaching_feed_card.dart';

class CoachingFeedList extends StatelessWidget {
  const CoachingFeedList({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<CoachingFeedBloc, CoachingFeedState>(
      builder: (final BuildContext context, final CoachingFeedState state) {
        if (state.isInitial || state.isLoading) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        }

        if (state.isFailure && state.feeds.isEmpty) {
          return SliverToBoxAdapter(
            child: CoachingErrorView(
              message: state.errorMessage ?? 'Unable to load feeds.',
              onRetry: () => _retry(context, state),
            ),
          );
        }

        if (state.feeds.isEmpty) {
          return const SliverToBoxAdapter(child: _EmptyFeedView());
        }

        return SliverList.separated(
          itemBuilder: (final BuildContext context, final int index) {
            final bool isBottomLoader = index == state.feeds.length;

            if (isBottomLoader) {
              if (!state.isLoadingMore) {
                return const SizedBox.shrink();
              }

              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }

            return CoachingFeedCard(feed: state.feeds[index]);
          },
          separatorBuilder: (final BuildContext context, final int index) {
            return const SizedBox(height: 8);
          },
          itemCount: state.feeds.length + 1,
        );
      },
    );
  }

  void _retry(final BuildContext context, final CoachingFeedState state) {
    final int? programId = state.programId;
    final int? sessionId = state.sessionId;
    if (programId == null || sessionId == null) {
      return;
    }

    context.read<CoachingFeedBloc>().add(
      LoadCoachingFeeds(programId: programId, sessionId: sessionId),
    );
  }
}

class _EmptyFeedView extends StatelessWidget {
  const _EmptyFeedView();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.feed_outlined,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'No feeds found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
