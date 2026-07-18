import 'package:equatable/equatable.dart';

abstract class AuthSessionEvent extends Equatable {
  const AuthSessionEvent();

  @override
  List<Object?> get props => [];
}

class AuthSessionStarted extends AuthSessionEvent {
  const AuthSessionStarted();
}

class AuthSessionAuthenticated extends AuthSessionEvent {
  final String token;

  const AuthSessionAuthenticated(this.token);

  @override
  List<Object?> get props => [token];
}

class AuthSessionLogoutRequested extends AuthSessionEvent {
  const AuthSessionLogoutRequested();
}
