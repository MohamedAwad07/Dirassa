import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit
    extends
        Cubit<
          AuthState
        > {
  AuthCubit()
    : super(
        AuthInitial(),
      );

  void login(
    String email,
    String password,
  ) async {
    emit(
      AuthLoading(),
    );
    // Simulate login logic
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    if (email ==
            'user@email.com' &&
        password ==
            'password') {
      emit(
        AuthAuthenticated(
          email: email,
        ),
      );
    } else {
      emit(
        AuthError(
          'Invalid credentials',
        ),
      );
    }
  }

  void register(
    String email,
    String password,
  ) async {
    emit(
      AuthLoading(),
    );
    // Simulate registration logic
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    emit(
      AuthAuthenticated(
        email: email,
      ),
    );
  }

  void logout() {
    emit(
      AuthInitial(),
    );
  }
}
