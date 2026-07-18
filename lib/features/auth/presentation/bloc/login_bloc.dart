import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, clearError: true));

    final result = await _loginUseCase(
      LoginParams(
        email: event.email.trim(),
        password: event.password,
        appFcmToken: event.appFcmToken,
      ),
    );

    result.fold(
      (failure) => _handleFailure(failure, emit),
      (_) => _handleSuccess(emit),
    );
  }

  void _handleFailure(Failure failure, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  void _handleSuccess(Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.success, clearError: true));
  }
}
