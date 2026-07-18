import 'package:equatable/equatable.dart';

enum AuthSessionStatus { unknown, authenticated, unauthenticated }

class AuthSessionState extends Equatable {
  final AuthSessionStatus status;

  const AuthSessionState({this.status = AuthSessionStatus.unknown});

  const AuthSessionState.unknown() : status = AuthSessionStatus.unknown;

  const AuthSessionState.authenticated()
    : status = AuthSessionStatus.authenticated;

  const AuthSessionState.unauthenticated()
    : status = AuthSessionStatus.unauthenticated;

  bool get isUnknown => status == AuthSessionStatus.unknown;
  bool get isAuthenticated => status == AuthSessionStatus.authenticated;
  bool get isUnauthenticated => status == AuthSessionStatus.unauthenticated;

  @override
  List<Object?> get props => [status];
}
