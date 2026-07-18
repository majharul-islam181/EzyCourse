import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/coaching_details_with_sessions.dart';
import '../../domain/entities/coaching_session.dart';
import '../../domain/usecases/get_coaching_details_with_sessions_usecase.dart';
import 'coaching_details_event.dart';
import 'coaching_details_state.dart';

class CoachingDetailsBloc
    extends Bloc<CoachingDetailsEvent, CoachingDetailsState> {
  final GetCoachingDetailsWithSessionsUseCase
  _getCoachingDetailsWithSessionsUseCase;

  CoachingDetailsBloc(this._getCoachingDetailsWithSessionsUseCase)
    : super(const CoachingDetailsState()) {
    on<LoadCoachingDetails>(_loadCoachingDetails);
    on<CoachingSessionSelected>(_selectSession);
    on<CoachingParentSessionToggled>(_toggleParentSession);
  }

  Future<void> _loadCoachingDetails(
    final LoadCoachingDetails event,
    final Emitter<CoachingDetailsState> emit,
  ) async {
    emit(
      state.copyWith(status: CoachingDetailsStatus.loading, clearError: true),
    );

    final result = await _getCoachingDetailsWithSessionsUseCase(
      GetCoachingDetailsWithSessionsParams(
        programId: event.programId,
        userZone: event.userZone,
      ),
    );

    result.fold(
      (final failure) => _handleFailure(failure, emit),
      (final details) => _handleSuccess(details, emit),
    );
  }

  void _handleFailure(
    final Failure failure,
    final Emitter<CoachingDetailsState> emit,
  ) {
    emit(
      state.copyWith(
        status: CoachingDetailsStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  void _handleSuccess(
    final CoachingDetailsWithSessions details,
    final Emitter<CoachingDetailsState> emit,
  ) {
    final CoachingSession? selectedSession = details.selectedSession;

    emit(
      state.copyWith(
        status: CoachingDetailsStatus.success,
        detailsWithSessions: details,
        selectedSession: selectedSession,
        expandedParentIds: _initialExpandedParentIds(details, selectedSession),
        clearError: true,
      ),
    );
  }

  void _selectSession(
    final CoachingSessionSelected event,
    final Emitter<CoachingDetailsState> emit,
  ) {
    final CoachingDetailsWithSessions? details = state.detailsWithSessions;
    if (details == null) {
      return;
    }

    final CoachingSession? selectedSession = _findSession(
      details,
      event.sessionId,
    );
    if (selectedSession == null) {
      return;
    }

    emit(
      state.copyWith(
        selectedSession: selectedSession,
        expandedParentIds: _expandedParentIdsForSelection(selectedSession),
      ),
    );
  }

  void _toggleParentSession(
    final CoachingParentSessionToggled event,
    final Emitter<CoachingDetailsState> emit,
  ) {
    final Set<int> expandedParentIds = {...state.expandedParentIds};

    if (expandedParentIds.contains(event.parentId)) {
      expandedParentIds.remove(event.parentId);
    } else {
      expandedParentIds.add(event.parentId);
    }

    emit(state.copyWith(expandedParentIds: expandedParentIds));
  }

  Set<int> _initialExpandedParentIds(
    final CoachingDetailsWithSessions details,
    final CoachingSession? selectedSession,
  ) {
    final int? parentId =
        selectedSession?.parentId ??
        details.currentSession.currentSessionParentId;

    return {if (parentId != null) parentId};
  }

  Set<int> _expandedParentIdsForSelection(
    final CoachingSession selectedSession,
  ) {
    return {
      ...state.expandedParentIds,
      if (selectedSession.parentId != null) selectedSession.parentId!,
    };
  }

  CoachingSession? _findSession(
    final CoachingDetailsWithSessions details,
    final int sessionId,
  ) {
    for (final CoachingSession session in details.sessions) {
      if (session.id == sessionId) {
        return session;
      }
    }

    return null;
  }
}
