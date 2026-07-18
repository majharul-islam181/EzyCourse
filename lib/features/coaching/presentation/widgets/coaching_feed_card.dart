import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/custom_snakbar.dart';
import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_feed_type.dart';
import '../../domain/entities/coaching_journal.dart';
import '../../domain/entities/coaching_lesson.dart';
import '../../domain/entities/coaching_program_submission.dart';
import '../../domain/entities/coaching_task_exercise.dart';
import '../../domain/entities/coaching_tracker.dart';
import '../../domain/entities/coaching_upload_file.dart';

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
          CoachingFeedType.lesson => _LessonFeedCard(feed: feed),
          CoachingFeedType.task => _TaskFeedCard(feed: feed),
          CoachingFeedType.journal => _JournalFeedCard(feed: feed),
          CoachingFeedType.unknown => _UnknownFeedCard(feed: feed),
        },
      ),
    );
  }
}

class _LessonFeedCard extends StatelessWidget {
  final CoachingFeed feed;

  const _LessonFeedCard({required this.feed});

  @override
  Widget build(final BuildContext context) {
    final CoachingLesson? lesson = feed.lesson;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FeedHeader(
          icon: _lessonIcon(lesson?.type),
          title: lesson?.title ?? 'Lesson',
          label: _lessonLabel(lesson?.type),
        ),
        const SizedBox(height: 12),
        _LessonContent(lesson: lesson),
        const SizedBox(height: 12),
        _CommentButton(commentCount: feed.commentCount),
      ],
    );
  }
}

class _TaskFeedCard extends StatelessWidget {
  final CoachingFeed feed;

  const _TaskFeedCard({required this.feed});

  @override
  Widget build(final BuildContext context) {
    final CoachingTaskExercise? task = feed.taskExercise;
    final bool isUpdate = feed.hasSubmission;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FeedHeader(
          icon: Icons.assignment_outlined,
          title: task?.title ?? 'Task',
          label: task?.type ?? 'Task/Exercise',
        ),
        if (task?.description != null) ...[
          const SizedBox(height: 12),
          Html(data: task!.description),
        ],
        if (feed.tracker != null) ...[
          const SizedBox(height: 12),
          _TrackerForm(tracker: feed.tracker!, submissions: feed.submissions),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showSubmissionInfo(context),
            child: Text(isUpdate ? 'Update' : 'Submit'),
          ),
        ),
        const SizedBox(height: 12),
        _CommentButton(commentCount: feed.commentCount),
      ],
    );
  }
}

class _JournalFeedCard extends StatefulWidget {
  final CoachingFeed feed;

  const _JournalFeedCard({required this.feed});

  @override
  State<_JournalFeedCard> createState() => _JournalFeedCardState();
}

class _JournalFeedCardState extends State<_JournalFeedCard> {
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
        _FeedHeader(
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
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surfaceContainer,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
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
            onPressed: () => _showSubmissionInfo(context),
            child: Text(isUpdate ? 'Update' : 'Submit'),
          ),
        ),
        const SizedBox(height: 12),
        _CommentButton(commentCount: widget.feed.commentCount),
      ],
    );
  }
}

class _UnknownFeedCard extends StatelessWidget {
  final CoachingFeed feed;

  const _UnknownFeedCard({required this.feed});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FeedHeader(
          icon: Icons.article_outlined,
          title: 'Feed',
          label: 'Unknown',
        ),
        const SizedBox(height: 12),
        _CommentButton(commentCount: feed.commentCount),
      ],
    );
  }
}

class _FeedHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String label;

  const _FeedHeader({
    required this.icon,
    required this.title,
    required this.label,
  });

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: colorScheme.onPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  final CoachingLesson? lesson;

  const _LessonContent({required this.lesson});

  @override
  Widget build(final BuildContext context) {
    return switch (lesson?.type) {
      CoachingLessonType.video => _VideoLessonContent(lesson: lesson),
      CoachingLessonType.audio => _AudioLessonContent(lesson: lesson),
      CoachingLessonType.pdf ||
      CoachingLessonType.ppt ||
      CoachingLessonType.download => _FileLessonContent(lesson: lesson),
      CoachingLessonType.text => Html(
        data: lesson?.textDescription ?? lesson?.description ?? '',
      ),
      CoachingLessonType.unknown ||
      null => Html(data: lesson?.description ?? lesson?.textDescription ?? ''),
    };
  }
}

class _VideoLessonContent extends StatelessWidget {
  final CoachingLesson? lesson;

  const _VideoLessonContent({required this.lesson});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CoachingUploadFile? file = _firstUploadFile(lesson);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isImageFile(file))
              CachedNetworkImage(imageUrl: file!.fileLink!, fit: BoxFit.cover)
            else
              ColoredBox(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.video_library_outlined,
                  color: colorScheme.onSurfaceVariant,
                  size: 48,
                ),
              ),
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () => _openLink(context, file?.fileLink),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.primary,
                  child: Icon(
                    Icons.play_arrow,
                    color: colorScheme.onPrimary,
                    size: 34,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioLessonContent extends StatelessWidget {
  final CoachingLesson? lesson;

  const _AudioLessonContent({required this.lesson});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CoachingUploadFile? file = _firstUploadFile(lesson);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              onPressed: () => _openLink(context, file?.fileLink),
              icon: Icon(
                Icons.play_circle_fill,
                color: colorScheme.primary,
                size: 36,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LinearProgressIndicator(
                value: 0,
                color: colorScheme.primary,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.graphic_eq, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _FileLessonContent extends StatelessWidget {
  final CoachingLesson? lesson;

  const _FileLessonContent({required this.lesson});

  @override
  Widget build(final BuildContext context) {
    final CoachingUploadFile? file = _firstUploadFile(lesson);

    return OutlinedButton.icon(
      onPressed: () => _openLink(context, file?.fileLink),
      icon: Icon(_lessonIcon(lesson?.type)),
      label: Text(file?.originalName ?? _lessonLabel(lesson?.type)),
    );
  }
}

class _TrackerForm extends StatelessWidget {
  final CoachingTracker tracker;
  final List<CoachingProgramSubmission> submissions;

  const _TrackerForm({required this.tracker, required this.submissions});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tracker.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (int index = 0; index < tracker.inputs.length; index++) ...[
          if (index > 0) const Divider(),
          _TrackerInputField(
            input: tracker.inputs[index],
            submission: _submissionForInput(tracker.inputs[index]),
          ),
        ],
      ],
    );
  }

  CoachingProgramSubmission? _submissionForInput(
    final CoachingTrackerInput input,
  ) {
    for (final CoachingProgramSubmission submission in submissions) {
      if (submission.trackerSubitemId == input.trackerSubitemId) {
        return submission;
      }
    }
    return null;
  }
}

class _TrackerInputField extends StatelessWidget {
  final CoachingTrackerInput input;
  final CoachingProgramSubmission? submission;

  const _TrackerInputField({required this.input, this.submission});

  @override
  Widget build(final BuildContext context) {
    return switch (input.type) {
      TrackerInputType.number => _NumberTrackerInput(
        input: input,
        submission: submission,
      ),
      TrackerInputType.duration => _DurationTrackerInput(
        input: input,
        submission: submission,
      ),
      TrackerInputType.question => _QuestionTrackerInput(
        input: input,
        submission: submission,
      ),
      TrackerInputType.selectOne => _SelectOneTrackerInput(
        input: input,
        submission: submission,
      ),
      TrackerInputType.unknown => _QuestionTrackerInput(
        input: input,
        submission: submission,
      ),
    };
  }
}

class _NumberTrackerInput extends StatelessWidget {
  final CoachingTrackerInput input;
  final CoachingProgramSubmission? submission;

  const _NumberTrackerInput({required this.input, this.submission});

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      initialValue: submission?.value?.toString() ?? '',
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(context, input.label).copyWith(
        suffixText: input.unit,
        helperText: input.goal == null
            ? null
            : 'Goal: ${input.goal}${input.unit == null ? '' : ' ${input.unit}'}',
      ),
    );
  }
}

class _DurationTrackerInput extends StatelessWidget {
  final CoachingTrackerInput input;
  final CoachingProgramSubmission? submission;

  const _DurationTrackerInput({required this.input, this.submission});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(input.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _TimePickerField(
                label: 'Start',
                initialValue: submission?.durationStart ?? input.startTime,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: _TimePickerField(label: 'End', initialValue: null)),
          ],
        ),
      ],
    );
  }
}

class _QuestionTrackerInput extends StatelessWidget {
  final CoachingTrackerInput input;
  final CoachingProgramSubmission? submission;

  const _QuestionTrackerInput({required this.input, this.submission});

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      initialValue: submission?.answer ?? '',
      minLines: 2,
      maxLines: 4,
      decoration: _inputDecoration(context, input.label),
    );
  }
}

class _SelectOneTrackerInput extends StatelessWidget {
  final CoachingTrackerInput input;
  final CoachingProgramSubmission? submission;

  const _SelectOneTrackerInput({required this.input, this.submission});

  @override
  Widget build(final BuildContext context) {
    final String? rawSelectedValue =
        submission?.answer ?? submission?.value?.toString();
    final String? selectedValue = input.options.contains(rawSelectedValue)
        ? rawSelectedValue
        : null;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: input.options
          .map(
            (final option) =>
                DropdownMenuItem<String>(value: option, child: Text(option)),
          )
          .toList(),
      onChanged: (_) {},
      decoration: _inputDecoration(context, input.label),
    );
  }
}

class _TimePickerField extends StatefulWidget {
  final String label;
  final String? initialValue;

  const _TimePickerField({required this.label, this.initialValue});

  @override
  State<_TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<_TimePickerField> {
  late final TextEditingController _controller;
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _controller,
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _time ?? TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            _time = picked;
            _controller.text = picked.format(context);
          });
        }
      },
      decoration: _inputDecoration(
        context,
        widget.label,
      ).copyWith(prefixIcon: const Icon(Icons.timer_outlined)),
    );
  }
}

class _CommentButton extends StatelessWidget {
  final int commentCount;

  const _CommentButton({required this.commentCount});

  @override
  Widget build(final BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.mode_comment_outlined),
      label: Text('$commentCount comments'),
    );
  }
}

InputDecoration _inputDecoration(
  final BuildContext context,
  final String label,
) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: colorScheme.surfaceContainer,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );
}

IconData _lessonIcon(final CoachingLessonType? type) {
  return switch (type) {
    CoachingLessonType.video => Icons.play_circle_outline,
    CoachingLessonType.audio => Icons.headphones_outlined,
    CoachingLessonType.pdf => Icons.picture_as_pdf_outlined,
    CoachingLessonType.ppt => Icons.slideshow_outlined,
    CoachingLessonType.download => Icons.download_outlined,
    CoachingLessonType.text => Icons.article_outlined,
    CoachingLessonType.unknown || null => Icons.school_outlined,
  };
}

String _lessonLabel(final CoachingLessonType? type) {
  return switch (type) {
    CoachingLessonType.video => 'Video',
    CoachingLessonType.audio => 'Audio',
    CoachingLessonType.pdf => 'PDF',
    CoachingLessonType.ppt => 'PPT',
    CoachingLessonType.download => 'Download',
    CoachingLessonType.text => 'Text',
    CoachingLessonType.unknown || null => 'Lesson',
  };
}

CoachingUploadFile? _firstUploadFile(final CoachingLesson? lesson) {
  if (lesson == null || lesson.uploadFiles.isEmpty) {
    return null;
  }

  return lesson.uploadFiles.first;
}

bool _isImageFile(final CoachingUploadFile? file) {
  final String? fileType = file?.fileType?.toLowerCase();
  final String? fileLink = file?.fileLink?.toLowerCase();

  return fileType == 'image' ||
      fileLink?.endsWith('.jpg') == true ||
      fileLink?.endsWith('.jpeg') == true ||
      fileLink?.endsWith('.png') == true ||
      fileLink?.endsWith('.webp') == true;
}

Future<void> _openLink(final BuildContext context, final String? url) async {
  if (url == null || url.isEmpty) {
    CustomSnackBar.show(
      context: context,
      message: 'No file link found.',
      type: SnackBarType.warning,
    );
    return;
  }

  final Uri? uri = Uri.tryParse(url);
  if (uri == null) {
    CustomSnackBar.show(
      context: context,
      message: 'Invalid file link.',
      type: SnackBarType.error,
    );
    return;
  }

  final bool opened = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
  if (!opened && context.mounted) {
    CustomSnackBar.show(
      context: context,
      message: 'Unable to open this file.',
      type: SnackBarType.error,
    );
  }
}

void _showSubmissionInfo(final BuildContext context) {
  CustomSnackBar.show(
    context: context,
    message: 'Submission API is ready to connect.',
    type: SnackBarType.info,
  );
}
