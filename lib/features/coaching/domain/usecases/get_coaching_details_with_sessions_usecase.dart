import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/coaching_details_with_sessions.dart';
import '../repositories/coaching_repository.dart';

class GetCoachingDetailsWithSessionsUseCase
    implements
        UseCase<CoachingDetailsWithSessions,GetCoachingDetailsWithSessionsParams> {
  final CoachingRepository _repository;

  const GetCoachingDetailsWithSessionsUseCase(this._repository);

  @override
  Future<Either<Failure, CoachingDetailsWithSessions>> call(
    final GetCoachingDetailsWithSessionsParams params,
  ) {
    return _repository.getCoachingDetailsWithSessions(
      programId: params.programId,
      userZone: params.userZone,
    );
  }
}

class GetCoachingDetailsWithSessionsParams extends Equatable {
  final int programId;
  final String userZone;

  const GetCoachingDetailsWithSessionsParams({
    required this.programId,
    required this.userZone,
  });

  @override
  List<Object?> get props => [programId, userZone];
}
