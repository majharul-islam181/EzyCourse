import 'package:flutter_bloc/flutter_bloc.dart';

import '../../storage/local_storage.dart';
import '../../storage/memory_storage.dart';
import '../../storage/storage_keys.dart';
import 'auth_session_event.dart';
import 'auth_session_state.dart';

class AuthSessionBloc extends Bloc<AuthSessionEvent, AuthSessionState> {
  final LocalStorage _localStorage;
  final MemoryStorage _memoryStorage;

  AuthSessionBloc(this._localStorage, this._memoryStorage)
    : super(const AuthSessionState.unknown()) {
    on<AuthSessionStarted>(_onStarted);
    on<AuthSessionAuthenticated>(_onAuthenticated);
    on<AuthSessionLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onStarted(
    final AuthSessionStarted event,
    final Emitter<AuthSessionState> emit,
  ) async {
    final String? token = await _localStorage.getSecureData(
      StorageKeys.authToken,
    );

    if (token == null || token.isEmpty) {
      _memoryStorage.clear();
      emit(const AuthSessionState.unauthenticated());
      return;
    }

    _memoryStorage.setAccessToken(token);
    emit(const AuthSessionState.authenticated());
  }

  Future<void> _onAuthenticated(
    final AuthSessionAuthenticated event,
    final Emitter<AuthSessionState> emit,
  ) async {
    _memoryStorage.setAccessToken(event.token);
    await _localStorage.saveSecureData(StorageKeys.authToken, event.token);
    emit(const AuthSessionState.authenticated());
  }

  Future<void> _onLogoutRequested(
    final AuthSessionLogoutRequested event,
    final Emitter<AuthSessionState> emit,
  ) async {
    _memoryStorage.clear();
    await _localStorage.deleteSecureData(StorageKeys.authToken);
    emit(const AuthSessionState.unauthenticated());
  }
}
