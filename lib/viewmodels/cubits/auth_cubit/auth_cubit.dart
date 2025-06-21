import 'package:dirassa/core/functions/api_handler.dart';
import 'package:dirassa/models/Login/login_request.dart';
import 'package:dirassa/models/Login/login_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login(LoginRequest loginRequest) async {
    emit(AuthLoading());
    final LoginResponse loginResponse = await loginUser(loginRequest);

    if (loginResponse.success == true) {
      emit(AuthAuthenticated(token: loginResponse.token ?? ''));
    } else {
      emit(AuthError(loginResponse.message ?? ''));
    }
  }

  void logout() {
    emit(AuthInitial());
  }
}
