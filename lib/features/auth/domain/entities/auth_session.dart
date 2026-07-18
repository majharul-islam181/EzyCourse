import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  final String type;
  final String token;

  const AuthSession({required this.type, required this.token});

  @override
  List<Object?> get props => [type, token];
}
