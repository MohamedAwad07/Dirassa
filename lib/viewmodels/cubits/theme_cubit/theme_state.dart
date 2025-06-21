part of 'theme_cubit.dart';

enum ThemeStatus { initial, loading, loaded }

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final ThemeStatus status;

  const ThemeState(this.themeMode, {this.status = ThemeStatus.initial});

  @override
  List<Object?> get props => [themeMode, status];

  ThemeState copyWith({ThemeMode? themeMode, ThemeStatus? status}) {
    return ThemeState(
      themeMode ?? this.themeMode,
      status: status ?? this.status,
    );
  }
}
