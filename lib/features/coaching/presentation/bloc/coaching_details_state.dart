import 'package:equatable/equatable.dart';

import '../../domain/entities/coaching_details_with_sessions.dart';
import '../../domain/entities/coaching_session.dart';

enum CoachingDetailsStatus { initial, loading, success, failure }

class CoachingDetailsState extends Equatable {
  final CoachingDetailsStatus status;
  final CoachingDetailsWithSessions? detailsWithSessions;
  final CoachingSession? selectedSession;
  final Set<int> expandedParentIds;
  final String? errorMessage;

  const CoachingDetailsState({
    this.status = CoachingDetailsStatus.initial,
    this.detailsWithSessions,
    this.selectedSession,
    this.expandedParentIds = const {},
    this.errorMessage,
  });

  bool get isInitial => status == CoachingDetailsStatus.initial;
  bool get isLoading => status == CoachingDetailsStatus.loading;
  bool get isSuccess => status == CoachingDetailsStatus.success;
  bool get isFailure => status == CoachingDetailsStatus.failure;

  CoachingDetailsState copyWith({
    final CoachingDetailsStatus? status,
    final CoachingDetailsWithSessions? detailsWithSessions,
    final CoachingSession? selectedSession,
    final Set<int>? expandedParentIds,
    final String? errorMessage,
    final bool clearError = false,
  }) {
    return CoachingDetailsState(
      status: status ?? this.status,
      detailsWithSessions: detailsWithSessions ?? this.detailsWithSessions,
      selectedSession: selectedSession ?? this.selectedSession,
      expandedParentIds: expandedParentIds ?? this.expandedParentIds,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    detailsWithSessions,
    selectedSession,
    expandedParentIds,
    errorMessage,
  ];
}
