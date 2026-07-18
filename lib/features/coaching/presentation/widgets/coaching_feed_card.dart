import 'package:flutter/material.dart';

import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_feed_type.dart';
import 'journal_feed_card.dart';
import 'lesson_feed_card.dart';
import 'task_exercise_feed_card.dart';
import 'unknown_feed_card.dart';

class CoachingFeedCard extends StatelessWidget {
  final CoachingFeed feed;

  const CoachingFeedCard({required this.feed, super.key});

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: switch (feed.feedType) {
          CoachingFeedType.lesson => LessonFeedCard(feed: feed),
          CoachingFeedType.task => TaskExerciseFeedCard(feed: feed),
          CoachingFeedType.journal => JournalFeedCard(feed: feed),
          CoachingFeedType.unknown => UnknownFeedCard(feed: feed),
        },
      ),
    );
  }
}
