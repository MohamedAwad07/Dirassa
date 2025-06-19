part of 'auth_cubit.dart';

abstract class AuthState
    extends
        Equatable {
  @override
  List<
    Object?
  >
  get props => [];
}

class AuthInitial
    extends
        AuthState {}

class AuthLoading
    extends
        AuthState {}

class AuthAuthenticated
    extends
        AuthState {
  final String email;
  AuthAuthenticated({
    required this.email,
  });
  @override
  List<
    Object?
  >
  get props => [
    email,
  ];
}

class AuthError
    extends
        AuthState {
  final String message;
  AuthError(
    this.message,
  );
  @override
  List<
    Object?
  >
  get props => [
    message,
  ];
}
