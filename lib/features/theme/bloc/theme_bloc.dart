import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/local_storage_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalStorageService storageService;

  ThemeBloc({required this.storageService}) : super(const ThemeState()) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeLoadRequested>(_onThemeLoadRequested);
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await storageService.setThemeMode(event.themeMode.name);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onThemeLoadRequested(
    ThemeLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final themeModeString = storageService.getThemeMode();
    ThemeMode themeMode = ThemeMode.system;
    
    switch (themeModeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }
    
    emit(state.copyWith(themeMode: themeMode));
  }
}
