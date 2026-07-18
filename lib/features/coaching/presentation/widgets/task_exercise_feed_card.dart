import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_feed_type.dart';
import '../../domain/entities/coaching_program_submission.dart';
import '../../domain/entities/coaching_task_exercise.dart';
import '../../domain/entities/coaching_tracker.dart';
import '../bloc/coaching_feed_bloc.dart';
import '../bloc/coaching_feed_event.dart';
import '../bloc/coaching_feed_state.dart';
import 'feed_card_shared.dart';

class TaskExerciseFeedCard extends StatelessWidget {
  final CoachingFeed feed;

  const TaskExerciseFeedCard({required this.feed, super.key});

  @override
  Widget build(final BuildContext context) {
    final CoachingTaskExercise? task = feed.taskExercise;
    final bool isUpdate = feed.hasSubmission;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeedCardHeader(
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
            onPressed: () => showSubmissionInfo(context),
            child: Text(isUpdate ? 'Update' : 'Submit'),
          ),
        ),
        const SizedBox(height: 12),
        FeedCommentButton(commentCount: feed.commentCount),
      ],
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
        const SizedBox(height: 12),
        for (int index = 0; index < tracker.inputs.length; index++) ...[
          if (index > 0)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
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
    return _LabeledTrackerField(
      label: input.label,
      helperText: input.goal == null
          ? null
          : 'Goal: ${input.goal}${input.unit == null ? '' : ' ${input.unit}'}',
      child: TextFormField(
        initialValue: submission?.value?.toString() ?? '',
        keyboardType: TextInputType.number,
        decoration: feedInputDecoration(
          context,
          hintText: 'Enter value',
        ).copyWith(suffixText: input.unit),
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
    return _LabeledTrackerField(
      label: input.label,
      child: Row(
        children: [
          Expanded(
            child: _TimePickerField(
              inputId: input.trackerSubitemId,
              isStart: true,
              label: 'Start',
              initialValue: submission?.durationStart ?? input.startTime,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TimePickerField(
              inputId: input.trackerSubitemId,
              isStart: false,
              label: 'End',
              initialValue: null,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionTrackerInput extends StatelessWidget {
  final CoachingTrackerInput input;
  final CoachingProgramSubmission? submission;

  const _QuestionTrackerInput({required this.input, this.submission});

  @override
  Widget build(final BuildContext context) {
    return _LabeledTrackerField(
      label: input.label,
      child: TextFormField(
        initialValue: submission?.answer ?? '',
        minLines: 2,
        maxLines: 4,
        decoration: feedInputDecoration(context, hintText: 'Write your answer'),
      ),
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

    return _LabeledTrackerField(
      label: input.label,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: input.options
            .map(
              (final option) =>
                  DropdownMenuItem<String>(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: (_) {},
        decoration: feedInputDecoration(context, hintText: 'Select one'),
      ),
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String inputId;
  final bool isStart;
  final String label;
  final String? initialValue;

  const _TimePickerField({
    required this.inputId,
    required this.isStart,
    required this.label,
    this.initialValue,
  });

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<CoachingFeedBloc, CoachingFeedState, String>(
      selector: (final CoachingFeedState state) {
        return state.trackerTimeValues[_trackerTimeKey(inputId, isStart)] ??
            initialValue ??
            '';
      },
      builder: (final BuildContext context, final String value) {
        return TextFormField(
          key: ValueKey<String>('time-$inputId-$isStart-$value'),
          initialValue: value,
          readOnly: true,
          onTap: () => _pickTime(context),
          decoration: feedInputDecoration(
            context,
            hintText: label,
          ).copyWith(prefixIcon: const Icon(Icons.timer_outlined)),
        );
      },
    );
  }

  Future<void> _pickTime(final BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null || !context.mounted) {
      return;
    }

    context.read<CoachingFeedBloc>().add(
      CoachingTrackerTimeChanged(
        inputId: inputId,
        isStart: isStart,
        value: picked.format(context),
      ),
    );
  }
}

class _LabeledTrackerField extends StatelessWidget {
  final String label;
  final String? helperText;
  final Widget child;

  const _LabeledTrackerField({
    required this.label,
    required this.child,
    this.helperText,
  });

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

String _trackerTimeKey(final String inputId, final bool isStart) {
  return '$inputId:${isStart ? 'start' : 'end'}';
}
