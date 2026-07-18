import 'package:equatable/equatable.dart';
import '../../domain/entities/coaching_feed.dart';

enum CoachingFeedStatus { initial, loading, success, loadingMore, failure }

class CoachingFeedState extends Equatable {
  final CoachingFeedStatus status;
  final List<CoachingFeed> feeds;
  final int? programId;
  final int? sessionId;
  final int currentPage;
  final int limit;
  final bool hasNextPage;
  final Map<String, String> trackerTimeValues;
  final Map<int, String> journalDrafts;
  final String? errorMessage;

  const CoachingFeedState({
    this.status = CoachingFeedStatus.initial,
    this.feeds = const [],
    this.programId,
    this.sessionId,
    this.currentPage = 1,
    this.limit = 10,
    this.hasNextPage = false,
    this.trackerTimeValues = const {},
    this.journalDrafts = const {},
    this.errorMessage,
  });

  bool get isInitial => status == CoachingFeedStatus.initial;
  bool get isLoading => status == CoachingFeedStatus.loading;
  bool get isSuccess => status == CoachingFeedStatus.success;
  bool get isLoadingMore => status == CoachingFeedStatus.loadingMore;
  bool get isFailure => status == CoachingFeedStatus.failure;

  CoachingFeedState copyWith({
    final CoachingFeedStatus? status,
    final List<CoachingFeed>? feeds,
    final int? programId,
    final int? sessionId,
    final int? currentPage,
    final int? limit,
    final bool? hasNextPage,
    final Map<String, String>? trackerTimeValues,
    final Map<int, String>? journalDrafts,
    final String? errorMessage,
    final bool clearError = false,
  }) {
    return CoachingFeedState(
      status: status ?? this.status,
      feeds: feeds ?? this.feeds,
      programId: programId ?? this.programId,
      sessionId: sessionId ?? this.sessionId,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      trackerTimeValues: trackerTimeValues ?? this.trackerTimeValues,
      journalDrafts: journalDrafts ?? this.journalDrafts,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    feeds,
    programId,
    sessionId,
    currentPage,
    limit,
    hasNextPage,
    trackerTimeValues,
    journalDrafts,
    errorMessage,
  ];
}
