import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/coaching_feed_page.dart';
import '../repositories/coaching_repository.dart';

class GetCoachingFeedsUseCase
    implements UseCase<CoachingFeedPage, GetCoachingFeedsParams> {
  final CoachingRepository _repository;

  const GetCoachingFeedsUseCase(this._repository);

  @override
  Future<Either<Failure, CoachingFeedPage>> call(
    final GetCoachingFeedsParams params,
  ) {
    return _repository.getCoachingFeeds(
      programId: params.programId,
      sessionId: params.sessionId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCoachingFeedsParams extends Equatable {
  final int programId;
  final int sessionId;
  final int page;
  final int limit;

  const GetCoachingFeedsParams({
    required this.programId,
    required this.sessionId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [programId, sessionId, page, limit];
}
