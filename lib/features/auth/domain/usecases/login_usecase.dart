import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthSession, LoginParams> {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  @override
  Future<Either<Failure, AuthSession>> call(final LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
      appFcmToken: params.appFcmToken,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  final String? appFcmToken;

  const LoginParams({
    required this.email,
    required this.password,
    this.appFcmToken,
  });

  @override
  List<Object?> get props => [email, password, appFcmToken];
}
