import 'package:equatable/equatable.dart';
import 'coaching_feed_reaction.dart';
import 'coaching_feed_type.dart';
import 'coaching_journal.dart';
import 'coaching_lesson.dart';
import 'coaching_program_submission.dart';
import 'coaching_task_exercise.dart';
import 'coaching_tracker.dart';

class CoachingFeed extends Equatable {
  final int id;
  final int programId;
  final int userId;
  final CoachingFeedType feedType;
  final int coachingSessionId;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int communityFeedId;
  final CoachingLesson? lesson;
  final CoachingTaskExercise? taskExercise;
  final CoachingJournal? journal;
  final CoachingTracker? tracker;
  final List<CoachingProgramSubmission> submissions;
  final CoachingFeedReaction? feedReaction;

  const CoachingFeed({
    required this.id,
    required this.programId,
    required this.userId,
    required this.feedType,
    required this.coachingSessionId,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    required this.communityFeedId,
    this.lesson,
    this.taskExercise,
    this.journal,
    this.tracker,
    this.submissions = const [],
    this.feedReaction,
  });

  bool get hasSubmission => submissions.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    programId,
    userId,
    feedType,
    coachingSessionId,
    commentCount,
    createdAt,
    updatedAt,
    communityFeedId,
    lesson,
    taskExercise,
    journal,
    tracker,
    submissions,
    feedReaction,
  ];
}
