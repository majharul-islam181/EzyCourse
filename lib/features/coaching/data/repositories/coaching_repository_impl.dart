import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
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
  }) async {
    try {
      final CoachingProgramPage programPage = await _remoteDataSource
          .getEnrolledCoachingPrograms(page: page, limit: perPage);

      return Right(programPage);
    } on ValidationException catch (error) {
      return Left(ValidationFailure(error.message, errors: error.errors));
    } on UnauthorizedException catch (error) {
      return Left(UnauthorizedFailure(error.message));
    } on NetworkException catch (error) {
      return Left(NetworkFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message, statusCode: error.statusCode));
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message));
    } on FormatException catch (error) {
      return Left(ServerFailure(error.message));
    } on TimeoutException {
      return const Left(NetworkFailure('Request timed out. Please try again.'));
    } catch (_) {
      return const Left(
        UnknownFailure('Unable to load coaching programs. Please try again.'),
      );
    }
  }
}
