import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/coaching_program_page.dart';
import '../repositories/coaching_repository.dart';

class GetEnrolledCoachingProgramsUseCase
    implements UseCase<CoachingProgramPage, GetEnrolledCoachingProgramsParams> {
  final CoachingRepository _repository;

  const GetEnrolledCoachingProgramsUseCase(this._repository);

  @override
  Future<Either<Failure, CoachingProgramPage>> call(
    final GetEnrolledCoachingProgramsParams params,
  ) {
    return _repository.getEnrolledCoachingPrograms(
      page: params.page,
      perPage: params.limit,
    );
  }
}

class GetEnrolledCoachingProgramsParams extends Equatable {
  final int page;
  final int limit;

  const GetEnrolledCoachingProgramsParams({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}
