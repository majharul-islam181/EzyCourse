import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_journal.dart';
import '../../domain/entities/coaching_program_submission.dart';
import 'feed_card_shared.dart';

class JournalFeedCard extends StatefulWidget {
  final CoachingFeed feed;

  const JournalFeedCard({required this.feed, super.key});

  @override
  State<JournalFeedCard> createState() => _JournalFeedCardState();
}

class _JournalFeedCardState extends State<JournalFeedCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _journalAnswer);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _journalAnswer {
    for (final CoachingProgramSubmission submission
        in widget.feed.submissions) {
      if (submission.answer != null) {
        return submission.answer!;
      }
    }
    return '';
  }

  @override
  Widget build(final BuildContext context) {
    final CoachingJournal? journal = widget.feed.journal;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int characterLimit = journal?.characterLimit ?? 2000;
    final bool isUpdate = widget.feed.hasSubmission;

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
          controller: _controller,
          minLines: 2,
          maxLines: 5,
          maxLength: characterLimit,
          onChanged: (_) => setState(() {}),
          decoration: feedInputDecoration(
            context,
            hintText: 'Write your journal entry',
          ).copyWith(counterText: ''),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_controller.text.length}/$characterLimit',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
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
        FeedCommentButton(commentCount: widget.feed.commentCount),
      ],
    );
  }
}
