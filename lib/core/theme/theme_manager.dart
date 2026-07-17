import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../storage/local_storage.dart';
import '../storage/storage_keys.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class LoadTheme extends ThemeEvent {}

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalStorage _localStorage;

  ThemeBloc(this._localStorage) : super(const ThemeState(ThemeMode.system)) {
    on<LoadTheme>(_onLoadTheme);
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onLoadTheme(final LoadTheme event, final Emitter<ThemeState> emit) {
    final String? modeStr = _localStorage.getString(StorageKeys.themeMode);
    if (modeStr != null) {
      final ThemeMode mode = ThemeMode.values.firstWhere(
        (final e) => e.toString() == modeStr,
        orElse: () => ThemeMode.system,
      );
      emit(ThemeState(mode));
    }
  }

  Future<void> _onThemeChanged(
    final ThemeChanged event,
    final Emitter<ThemeState> emit,
  ) async {
    await _localStorage.setString(
      StorageKeys.themeMode,
      event.themeMode.toString(),
    );
    emit(ThemeState(event.themeMode));
  }
}
