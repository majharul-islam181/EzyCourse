import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_feed_page.dart';
import '../../domain/usecases/get_coaching_feeds_usecase.dart';
import 'coaching_feed_event.dart';
import 'coaching_feed_state.dart';

class CoachingFeedBloc extends Bloc<CoachingFeedEvent, CoachingFeedState> {
  final GetCoachingFeedsUseCase _getCoachingFeedsUseCase;

  CoachingFeedBloc(this._getCoachingFeedsUseCase)
    : super(const CoachingFeedState()) {
    on<LoadCoachingFeeds>(_loadFeeds);
    on<LoadMoreCoachingFeeds>(_loadNextPage);
    on<CoachingTrackerTimeChanged>(_changeTrackerTime);
    on<CoachingJournalDraftChanged>(_changeJournalDraft);
  }

  Future<void> _loadFeeds(
    final LoadCoachingFeeds event,
    final Emitter<CoachingFeedState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CoachingFeedStatus.loading,
        feeds: const [],
        programId: event.programId,
        sessionId: event.sessionId,
        currentPage: event.page,
        limit: event.limit,
        hasNextPage: false,
        clearError: true,
      ),
    );

    final result = await _getCoachingFeedsUseCase(
      GetCoachingFeedsParams(
        programId: event.programId,
        sessionId: event.sessionId,
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (final failure) => _handleFailure(failure, emit),
      (final page) => _handleSuccess(page, emit),
    );
  }

  Future<void> _loadNextPage(
    final LoadMoreCoachingFeeds event,
    final Emitter<CoachingFeedState> emit,
  ) async {
    if (!state.hasNextPage ||
        state.isLoading ||
        state.isLoadingMore ||
        state.programId == null ||
        state.sessionId == null) {
      return;
    }

    emit(
      state.copyWith(status: CoachingFeedStatus.loadingMore, clearError: true),
    );

    final result = await _getCoachingFeedsUseCase(
      GetCoachingFeedsParams(
        programId: state.programId!,
        sessionId: state.sessionId!,
        page: state.currentPage + 1,
        limit: state.limit,
      ),
    );

    result.fold(
      (final failure) => _handleFailure(failure, emit),
      (final page) => _handleNextPageSuccess(page, emit),
    );
  }

  void _handleFailure(
    final Failure failure,
    final Emitter<CoachingFeedState> emit,
  ) {
    emit(
      state.copyWith(
        status: CoachingFeedStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  void _handleSuccess(
    final CoachingFeedPage page,
    final Emitter<CoachingFeedState> emit,
  ) {
    emit(
      state.copyWith(
        status: CoachingFeedStatus.success,
        feeds: page.feeds,
        currentPage: page.currentPage,
        limit: page.perPage,
        hasNextPage: page.hasNextPage,
        clearError: true,
      ),
    );
  }

  void _handleNextPageSuccess(
    final CoachingFeedPage page,
    final Emitter<CoachingFeedState> emit,
  ) {
    final List<CoachingFeed> feeds = [...state.feeds, ...page.feeds];

    emit(
      state.copyWith(
        status: CoachingFeedStatus.success,
        feeds: feeds,
        currentPage: page.currentPage,
        limit: page.perPage,
        hasNextPage: page.hasNextPage,
        clearError: true,
      ),
    );
  }

  void _changeTrackerTime(
    final CoachingTrackerTimeChanged event,
    final Emitter<CoachingFeedState> emit,
  ) {
    final Map<String, String> trackerTimeValues = {
      ...state.trackerTimeValues,
      _trackerTimeKey(event.inputId, event.isStart): event.value,
    };

    emit(state.copyWith(trackerTimeValues: trackerTimeValues));
  }

  void _changeJournalDraft(
    final CoachingJournalDraftChanged event,
    final Emitter<CoachingFeedState> emit,
  ) {
    final Map<int, String> journalDrafts = {
      ...state.journalDrafts,
      event.feedId: event.value,
    };

    emit(state.copyWith(journalDrafts: journalDrafts));
  }

  String _trackerTimeKey(final String inputId, final bool isStart) {
    return '$inputId:${isStart ? 'start' : 'end'}';
  }
}
