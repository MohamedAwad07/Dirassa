import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit()
    : super(const ThemeState(ThemeMode.light, status: ThemeStatus.loading)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      final themeMode = ThemeMode.values[themeIndex];
      emit(ThemeState(themeMode, status: ThemeStatus.loaded));
    } catch (e) {
      // If there's an error loading theme, default to light mode
      emit(const ThemeState(ThemeMode.light, status: ThemeStatus.loaded));
    }
  }

  Future<void> toggleTheme() async {
    final newThemeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, newThemeMode.index);
      emit(ThemeState(newThemeMode, status: ThemeStatus.loaded));
    } catch (e) {
      // If there's an error saving theme, still update the state
      emit(ThemeState(newThemeMode, status: ThemeStatus.loaded));
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
      emit(ThemeState(themeMode, status: ThemeStatus.loaded));
    } catch (e) {
      // If there's an error saving theme, still update the state
      emit(ThemeState(themeMode, status: ThemeStatus.loaded));
    }
  }
}
