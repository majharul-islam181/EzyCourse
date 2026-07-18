import 'package:flutter/material.dart';

import '../../domain/entities/coaching_feed.dart';
import 'feed_card_shared.dart';

class UnknownFeedCard extends StatelessWidget {
  final CoachingFeed feed;

  const UnknownFeedCard({required this.feed, super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FeedCardHeader(
          icon: Icons.article_outlined,
          title: 'Feed',
          label: 'Unknown',
        ),
        const SizedBox(height: 12),
        FeedCommentButton(commentCount: feed.commentCount),
      ],
    );
  }
}
