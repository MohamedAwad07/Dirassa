part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginUrl extends AuthState {
  final String loginUrl;
  AuthLoginUrl({required this.loginUrl});
  @override
  List<Object?> get props => [loginUrl];
}

class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated({required this.token});
  @override
  List<Object?> get props => [token];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
