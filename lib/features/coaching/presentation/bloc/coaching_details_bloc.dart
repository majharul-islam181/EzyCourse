import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/coaching_details_with_sessions.dart';
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
    emit(
      state.copyWith(
        status: CoachingDetailsStatus.success,
        detailsWithSessions: details,
        selectedSession: details.selectedSession,
        clearError: true,
      ),
    );
  }
}
