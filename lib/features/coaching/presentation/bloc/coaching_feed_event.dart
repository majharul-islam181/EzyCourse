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
