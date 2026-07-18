import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_journal.dart';
import '../../domain/entities/coaching_program_submission.dart';
import '../bloc/coaching_feed_bloc.dart';
import '../bloc/coaching_feed_event.dart';
import '../bloc/coaching_feed_state.dart';
import 'feed_card_shared.dart';

class JournalFeedCard extends StatelessWidget {
  final CoachingFeed feed;

  const JournalFeedCard({required this.feed, super.key});

  @override
  Widget build(final BuildContext context) {
    final CoachingJournal? journal = feed.journal;
    final int characterLimit = journal?.characterLimit ?? 2000;
    final bool isUpdate = feed.hasSubmission;
    final String initialAnswer = _journalAnswer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeedCardHeader(
          icon: Icons.edit_note_outlined,
          title: journal?.title ?? 'Journal',
          label: 'Journal',
        ),
        if (journal?.description != null) ...[
          const SizedBox(height: 12),
          Html(data: journal!.description),
        ],
        const SizedBox(height: 12),
        TextFormField(
          initialValue: initialAnswer,
          minLines: 2,
          maxLines: 5,
          maxLength: characterLimit,
          onChanged: (final String value) {
            context.read<CoachingFeedBloc>().add(
              CoachingJournalDraftChanged(feedId: feed.id, value: value),
            );
          },
          decoration: feedInputDecoration(
            context,
            hintText: 'Write your journal entry',
          ).copyWith(counterText: ''),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: BlocSelector<CoachingFeedBloc, CoachingFeedState, int>(
            selector: (final CoachingFeedState state) {
              return (state.journalDrafts[feed.id] ?? initialAnswer).length;
            },
            builder: (final BuildContext context, final int characterCount) {
              final ColorScheme colorScheme = Theme.of(context).colorScheme;

              return Text(
                '$characterCount/$characterLimit',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => showSubmissionInfo(context),
            child: Text(isUpdate ? 'Update' : 'Submit'),
          ),
        ),
        const SizedBox(height: 12),
        FeedCommentButton(commentCount: feed.commentCount),
      ],
    );
  }

  String get _journalAnswer {
    for (final CoachingProgramSubmission submission in feed.submissions) {
      if (submission.answer != null) {
        return submission.answer!;
      }
    }
    return '';
  }
}
