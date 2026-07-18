import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/coaching_details_with_sessions.dart';
import '../../domain/entities/coaching_program_page.dart';
import '../../domain/repositories/coaching_repository.dart';
import '../datasources/coaching_remote_data_source.dart';

class CoachingRepositoryImpl implements CoachingRepository {
  final CoachingRemoteDataSource _remoteDataSource;

  const CoachingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CoachingProgramPage>> getEnrolledCoachingPrograms({
    required final int page,
    required final int perPage,
    final String? search,
  }) async {
    try {
      final CoachingProgramPage programPage = await _remoteDataSource
          .getEnrolledCoachingPrograms(
            page: page,
            limit: perPage,
            search: search,
          );

      return Right(programPage);
    } on ValidationException catch (error) {
      return Left(_mapExceptionToFailure(error));
    } catch (error) {
      return Left(_mapExceptionToFailure(error));
    }
  }

  @override
  Future<Either<Failure, CoachingDetailsWithSessions>>
  getCoachingDetailsWithSessions({
    required final int programId,
    required final String userZone,
  }) async {
    try {
      final CoachingDetailsWithSessions details = await _remoteDataSource
          .getCoachingDetailsWithSessions(
            programId: programId,
            userZone: userZone,
          );

      return Right(details);
    } catch (error) {
      return Left(_mapExceptionToFailure(error));
    }
  }

  Failure _mapExceptionToFailure(final Object error) {
    if (error is ValidationException) {
      return ValidationFailure(error.message, errors: error.errors);
    }
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message);
    }
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    }
    if (error is ServerException) {
      return ServerFailure(error.message, statusCode: error.statusCode);
    }
    if (error is CacheException) {
      return CacheFailure(error.message);
    }
    if (error is FormatException) {
      return ServerFailure(error.message);
    }
    if (error is TimeoutException) {
      return const NetworkFailure('Request timed out. Please try again.');
    }
    return const UnknownFailure(
      'Unable to load coaching data. Please try again.',
    );
  }
}
