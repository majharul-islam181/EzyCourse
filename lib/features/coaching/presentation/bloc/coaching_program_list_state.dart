import 'package:equatable/equatable.dart';

import '../../domain/entities/coaching_program.dart';

enum LoadStatus {
  initial,
  loading,
  success,
  loadingMore,
  failure,
}

class CoachingProgramListState extends Equatable {
  final LoadStatus status;
  final List<CoachingProgram> programs;
  final int currentPage;
  final int limit;     
  final bool hasNextPage;  
  final String? errorMessage;

  const CoachingProgramListState({
    this.status = LoadStatus.initial,
    this.programs = const [],
    this.currentPage = 1,
    this.limit = 10,
    this.hasNextPage = false,
    this.errorMessage,
  });

  bool get isInitial => status == LoadStatus.initial;
  bool get isLoading => status == LoadStatus.loading;
  bool get isSuccess => status == LoadStatus.success;
  bool get isLoadingMore => status == LoadStatus.loadingMore;
  bool get isFailure => status == LoadStatus.failure;

  CoachingProgramListState copyWith({
    final LoadStatus? status,
    final List<CoachingProgram>? programs,
    final int? currentPage,
    final int? limit,
    final bool? hasNextPage,
    final String? errorMessage,
    final bool clearError = false,
  }) {
    return CoachingProgramListState(
      status: status ?? this.status,
      programs: programs ?? this.programs,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    programs,
    currentPage,
    limit,
    hasNextPage,
    errorMessage,
  ];
}
