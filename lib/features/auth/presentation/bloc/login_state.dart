import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_session.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  final AuthSession? session;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.session,
  });

  bool get isLoading => status == LoginStatus.loading;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;

  LoginState copyWith({
    final LoginStatus? status,
    final String? errorMessage,
    final AuthSession? session,
    final bool clearError = false,
    final bool clearSession = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      session: clearSession ? null : session ?? this.session,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, session];
}
