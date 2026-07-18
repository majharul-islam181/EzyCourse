import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final String? appFcmToken;

  const LoginSubmitted({
    required this.email,
    required this.password,
    this.appFcmToken,
  });

  @override
  List<Object?> get props => [email, password, appFcmToken];
}
