import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/coaching_program.dart';
import '../../domain/entities/coaching_program_page.dart';
import '../../domain/usecases/get_enrolled_coaching_programs_usecase.dart';
import 'coaching_program_list_event.dart';
import 'coaching_program_list_state.dart';

class CoachingProgramListBloc
    extends Bloc<CoachingProgramListEvent, CoachingProgramListState> {
  final GetEnrolledCoachingProgramsUseCase _getEnrolledCoachingProgramsUseCase;

  CoachingProgramListBloc(this._getEnrolledCoachingProgramsUseCase)
    : super(const CoachingProgramListState()) {
    on<LoadCoachingPrograms>(_loadPrograms);
    on<LoadMoreCoachingPrograms>(_loadNextPage);
  }

  Future<void> _loadPrograms(
    final LoadCoachingPrograms event,
    final Emitter<CoachingProgramListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        programs: const [],
        currentPage: event.page,
        limit: event.limit,
        hasNextPage: false,
        search: event.search,
        clearError: true,
        clearSearch: event.search == null || event.search!.trim().isEmpty,
      ),
    );

    final result = await _getEnrolledCoachingProgramsUseCase(
      GetEnrolledCoachingProgramsParams(
        page: event.page,
        limit: event.limit,
        search: event.search,
      ),
    );

    result.fold(
      (final failure) => _handleFailure(failure, emit),
      (final page) => _handleSuccess(page, emit),
    );
  }

  Future<void> _loadNextPage(
    final LoadMoreCoachingPrograms event,
    final Emitter<CoachingProgramListState> emit,
  ) async {
    if (!state.hasNextPage || state.isLoading || state.isLoadingMore) {
      return;
    }

    emit(state.copyWith(status: LoadStatus.loadingMore, clearError: true));

    final result = await _getEnrolledCoachingProgramsUseCase(
      GetEnrolledCoachingProgramsParams(
        page: state.currentPage + 1,
        limit: state.limit,
        search: state.search,
      ),
    );

    result.fold(
      (final failure) => _handleFailure(failure, emit),
      (final page) => _handleNextPageSuccess(page, emit),
    );
  }

  void _handleFailure(
    final Failure failure,
    final Emitter<CoachingProgramListState> emit,
  ) {
    emit(
      state.copyWith(status: LoadStatus.failure, errorMessage: failure.message),
    );
  }

  void _handleSuccess(
    final CoachingProgramPage page,
    final Emitter<CoachingProgramListState> emit,
  ) {
    emit(
      state.copyWith(
        status: LoadStatus.success,
        programs: page.programs,
        currentPage: page.currentPage,
        limit: page.perPage,
        hasNextPage: page.hasNextPage,
        clearError: true,
      ),
    );
  }

  void _handleNextPageSuccess(
    final CoachingProgramPage page,
    final Emitter<CoachingProgramListState> emit,
  ) {
    final List<CoachingProgram> programs = [
      ...state.programs,
      ...page.programs,
    ];

    emit(
      state.copyWith(
        status: LoadStatus.success,
        programs: programs,
        currentPage: page.currentPage,
        limit: page.perPage,
        hasNextPage: page.hasNextPage,
        clearError: true,
      ),
    );
  }
}
