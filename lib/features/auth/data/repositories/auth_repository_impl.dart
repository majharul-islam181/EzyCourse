import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/memory_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final LocalStorage _localStorage;
  final MemoryStorage _memoryStorage;

  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._localStorage,
    this._memoryStorage,
  );

  @override
  Future<Either<Failure, AuthSession>> login({
    required final String email,
    required final String password,
    final String? appFcmToken,
  }) async {
    try {
      final AuthSession session = await _remoteDataSource.login(
        email: email,
        password: password,
        appFcmToken: appFcmToken,
      );

      _memoryStorage.setAccessToken(session.token);
      await _localStorage.saveSecureData(StorageKeys.authToken, session.token);

      return Right(session);
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
      return const Left(UnknownFailure('Unable to login. Please try again.'));
    }
  }
}
