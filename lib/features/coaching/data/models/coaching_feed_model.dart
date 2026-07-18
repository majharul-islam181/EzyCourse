import 'dart:convert';

import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_feed_type.dart';
import '../../domain/entities/coaching_program_submission.dart';
import 'coaching_feed_reaction_model.dart';
import 'coaching_journal_model.dart';
import 'coaching_lesson_model.dart';
import 'coaching_program_submission_model.dart';
import 'coaching_task_exercise_model.dart';
import 'coaching_tracker_model.dart';

class CoachingFeedModel extends CoachingFeed {
  const CoachingFeedModel({
    required super.id,
    required super.programId,
    required super.userId,
    required super.feedType,
    required super.coachingSessionId,
    required super.commentCount,
    required super.createdAt,
    required super.updatedAt,
    required super.communityFeedId,
    super.lesson,
    super.taskExercise,
    super.journal,
    super.tracker,
    super.submissions,
    super.feedReaction,
  });

  factory CoachingFeedModel.fromJson(final Map<String, dynamic> json) {
    final Map<String, dynamic> feedData = _parseFeedData(json['feedData']);

    return CoachingFeedModel(
      id: json['id'] as int,
      programId: json['programId'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      feedType: _parseFeedType(json['feedType'] as String?),
      coachingSessionId: json['coachingSessionId'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      communityFeedId: json['communityFeedId'] as int? ?? 0,
      lesson: _parseLesson(feedData),
      taskExercise: _parseTaskExercise(feedData),
      journal: _parseJournal(feedData),
      tracker: _parseTracker(feedData),
      submissions: _parseSubmissions(json['coachingProgramSubmission']),
      feedReaction: _parseFeedReaction(json['feed']),
    );
  }

  factory CoachingFeedModel.fromEntity(final CoachingFeed feed) {
    return CoachingFeedModel(
      id: feed.id,
      programId: feed.programId,
      userId: feed.userId,
      feedType: feed.feedType,
      coachingSessionId: feed.coachingSessionId,
      commentCount: feed.commentCount,
      createdAt: feed.createdAt,
      updatedAt: feed.updatedAt,
      communityFeedId: feed.communityFeedId,
      lesson: feed.lesson,
      taskExercise: feed.taskExercise,
      journal: feed.journal,
      tracker: feed.tracker,
      submissions: feed.submissions,
      feedReaction: feed.feedReaction,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programId': programId,
      'userId': userId,
      'feedType': feedType.name,
      'coachingSessionId': coachingSessionId,
      'commentCount': commentCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'communityFeedId': communityFeedId,
      'feedData': jsonEncode(_feedDataToJson()),
      'coachingProgramSubmission': submissions
          .map((final submission) {
            return CoachingProgramSubmissionModel.fromEntity(submission);
          })
          .map((final submission) => submission.toJson())
          .toList(),
      'feed': feedReaction == null
          ? null
          : CoachingFeedReactionModel.fromEntity(feedReaction!).toJson(),
    };
  }

  Map<String, dynamic> _feedDataToJson() {
    if (lesson != null) {
      return {'lesson': CoachingLessonModel.fromEntity(lesson!).toJson()};
    }

    if (taskExercise != null) {
      return {
        'task_exercise': CoachingTaskExerciseModel.fromEntity(
          taskExercise!,
        ).toJson(),
        if (tracker != null)
          'tracker': CoachingTrackerModel.fromEntity(tracker!).toJson(),
      };
    }

    if (journal != null) {
      return {'journal': CoachingJournalModel.fromEntity(journal!).toJson()};
    }

    return const {};
  }

  static Map<String, dynamic> _parseFeedData(final dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is! String || value.isEmpty) {
      return const {};
    }

    try {
      final dynamic decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      return const {};
    }

    return const {};
  }

  static CoachingFeedType _parseFeedType(final String? value) {
    switch (value?.toLowerCase()) {
      case 'lesson':
        return CoachingFeedType.lesson;
      case 'task':
      case 'task/exercise':
      case 'exercise':
        return CoachingFeedType.task;
      case 'journal':
        return CoachingFeedType.journal;
      default:
        return CoachingFeedType.unknown;
    }
  }

  static CoachingLessonModel? _parseLesson(
    final Map<String, dynamic> feedData,
  ) {
    final dynamic lesson = feedData['lesson'];
    if (lesson is! Map<String, dynamic>) {
      return null;
    }

    return CoachingLessonModel.fromJson(lesson);
  }

  static CoachingTaskExerciseModel? _parseTaskExercise(
    final Map<String, dynamic> feedData,
  ) {
    final dynamic taskExercise = feedData['task_exercise'];
    if (taskExercise is! Map<String, dynamic>) {
      return null;
    }

    return CoachingTaskExerciseModel.fromJson(taskExercise);
  }

  static CoachingJournalModel? _parseJournal(
    final Map<String, dynamic> feedData,
  ) {
    final dynamic journal = feedData['journal'];
    if (journal is! Map<String, dynamic>) {
      return null;
    }

    return CoachingJournalModel.fromJson(journal);
  }

  static CoachingTrackerModel? _parseTracker(
    final Map<String, dynamic> feedData,
  ) {
    final dynamic tracker = feedData['tracker'];
    if (tracker is! Map<String, dynamic>) {
      return null;
    }

    return CoachingTrackerModel.fromJson(tracker);
  }

  static List<CoachingProgramSubmission> _parseSubmissions(
    final dynamic value,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(CoachingProgramSubmissionModel.fromJson)
        .toList();
  }

  static CoachingFeedReactionModel? _parseFeedReaction(final dynamic value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }

    return CoachingFeedReactionModel.fromJson(value);
  }

  static DateTime _parseDate(final dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
