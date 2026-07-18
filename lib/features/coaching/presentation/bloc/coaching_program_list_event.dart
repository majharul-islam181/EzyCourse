import 'package:equatable/equatable.dart';

abstract class CoachingProgramListEvent extends Equatable {
  const CoachingProgramListEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoachingPrograms extends CoachingProgramListEvent {
  final int page;
  final int limit;

  const LoadCoachingPrograms({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class LoadMoreCoachingPrograms extends CoachingProgramListEvent {
  const LoadMoreCoachingPrograms();
}
