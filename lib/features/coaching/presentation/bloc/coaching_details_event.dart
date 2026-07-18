import 'package:equatable/equatable.dart';

abstract class CoachingDetailsEvent extends Equatable {
  const CoachingDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoachingDetails extends CoachingDetailsEvent {
  final int programId;
  final String userZone;

  const LoadCoachingDetails({required this.programId, required this.userZone});

  @override
  List<Object?> get props => [programId, userZone];
}

class CoachingSessionSelected extends CoachingDetailsEvent {
  final int sessionId;

  const CoachingSessionSelected(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class CoachingParentSessionToggled extends CoachingDetailsEvent {
  final int parentId;

  const CoachingParentSessionToggled(this.parentId);

  @override
  List<Object?> get props => [parentId];
}
