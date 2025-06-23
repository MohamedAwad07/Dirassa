import 'dart:developer';
import 'package:dirassa/core/functions/api_handler.dart';
import 'package:dirassa/core/services/token_storage_service.dart';
import 'package:dirassa/core/utils/app_strings.dart';
import 'package:dirassa/models/Login/login_request.dart';
import 'package:dirassa/models/Login/login_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    // Initialize token checking after the cubit is created
    _initializeTokenCheck();
  }

  /// Initialize token checking without blocking the constructor
  void _initializeTokenCheck() {
    // Use a microtask to avoid blocking the constructor
    Future.microtask(() => _checkCachedToken());
  }

  /// Check for cached token on app startup
  Future<void> _checkCachedToken() async {
    try {
      log('🔍 AuthCubit: Checking for cached token...');

      // Check if token exists and get remaining days
      final hasToken = await TokenStorageService.hasValidToken();
      final remainingDays = await TokenStorageService.getRemainingDays();

      log(
        '🔍 AuthCubit: Has valid token: $hasToken, Remaining days: $remainingDays',
      );

      final cachedToken = await TokenStorageService.getValidToken();
      if (cachedToken != null && cachedToken.isNotEmpty) {
        log(
          '🔍 AuthCubit: Found valid cached token, emitting AuthAuthenticated',
        );
        emit(AuthAuthenticated(token: cachedToken));
      } else {
        log('🔍 AuthCubit: No valid cached token found');
      }
    } catch (e) {
      log('🔍 AuthCubit: Error checking cached token: $e');
      // If there's an error, stay in initial state
      emit(AuthInitial());
    }
  }

  void login(LoginRequest loginRequest) async {
    log('🔍 AuthCubit: Login started');
    emit(AuthLoading());

    try {
      final ApiResponse<LoginResponse> apiResponse = await loginUser(
        loginRequest,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final loginResponse = apiResponse.data!;
        if (loginResponse.success == true) {
          final token = loginResponse.token ?? '';
          log('🔍 AuthCubit: Login successful, saving token');
          // Cache the token
          await TokenStorageService.saveToken(token);
          emit(AuthAuthenticated(token: token));

          // Log token info after saving
          final remainingDays = await TokenStorageService.getRemainingDays();
          log('🔍 AuthCubit: Token saved, remaining days: $remainingDays');
        } else {
          log('🔍 AuthCubit: Login failed: ${loginResponse.message}');
          emit(AuthError(loginResponse.message ?? AppStrings.apiLoginFailed));
        }
      } else {
        log('🔍 AuthCubit: API Error: ${apiResponse.message}');
        emit(AuthError(apiResponse.message));
      }
    } catch (e) {
      log('🔍 AuthCubit: Unexpected error during login: $e');
      emit(AuthError(AppStrings.apiUnknownError));
    }
  }

  void logout() async {
    log('🔍 AuthCubit: Logout started');
    // Clear cached token
    await TokenStorageService.clearToken();
    emit(AuthInitial());
    log('🔍 AuthCubit: Logout completed');
  }

  /// Check if user has a valid cached token
  Future<bool> hasValidToken() async {
    return await TokenStorageService.hasValidToken();
  }

  /// Get remaining days until token expires
  Future<int?> getRemainingDays() async {
    return await TokenStorageService.getRemainingDays();
  }

  /// Log all token information for debugging
  Future<void> logTokenInfo() async {
    await TokenStorageService.logTokenInfo();
  }
}
