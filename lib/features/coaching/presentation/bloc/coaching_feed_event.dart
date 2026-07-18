import 'package:equatable/equatable.dart';

abstract class CoachingFeedEvent extends Equatable {
  const CoachingFeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoachingFeeds extends CoachingFeedEvent {
  final int programId;
  final int sessionId;
  final int page;
  final int limit;

  const LoadCoachingFeeds({
    required this.programId,
    required this.sessionId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [programId, sessionId, page, limit];
}

class LoadMoreCoachingFeeds extends CoachingFeedEvent {
  const LoadMoreCoachingFeeds();
}

class CoachingTrackerTimeChanged extends CoachingFeedEvent {
  final String inputId;
  final bool isStart;
  final String value;

  const CoachingTrackerTimeChanged({
    required this.inputId,
    required this.isStart,
    required this.value,
  });

  @override
  List<Object?> get props => [inputId, isStart, value];
}

class CoachingJournalDraftChanged extends CoachingFeedEvent {
  final int feedId;
  final String value;

  const CoachingJournalDraftChanged({
    required this.feedId,
    required this.value,
  });

  @override
  List<Object?> get props => [feedId, value];
}
