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
