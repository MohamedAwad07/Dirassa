import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dirassa/models/config_response.dart';
import 'package:dirassa/models/Login/login_request.dart';
import 'package:dirassa/models/Login/login_response.dart';
import 'package:dirassa/core/utils/app_strings.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final String? errorCode;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
    this.errorCode,
  });

  factory ApiResponse.success(T data, [String message = 'Success']) {
    return ApiResponse(success: true, data: data, message: message);
  }

  factory ApiResponse.error(String message, [String? errorCode]) {
    return ApiResponse(success: false, message: message, errorCode: errorCode);
  }
}

// Dio handler class
class DioHandler {
  static final DioHandler _instance = DioHandler._internal();
  factory DioHandler() => _instance;
  DioHandler._internal();

  late Dio _dio;
  static const String baseUrl = 'https://dirassa.online/api';
  static const String configUrl = '$baseUrl/config/app_links.php';
  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
}

Future<ApiResponse<ConfigResponse>> fetchConfig() async {
  // Initialize Dio handler
  final dioHandler = DioHandler();
  dioHandler.init();

  try {
    final response = await dioHandler.dio.get(DioHandler.configUrl);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.success(ConfigResponse.fromJson(response.data));
    } else {
      return ApiResponse.error(
        AppStrings.apiConfigLoadError,
        'CONFIG_LOAD_ERROR',
      );
    }
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResponse.error(
          AppStrings.apiConnectionTimeout,
          'CONNECTION_TIMEOUT',
        );
      case DioExceptionType.sendTimeout:
        return ApiResponse.error(AppStrings.apiSendTimeout, 'SEND_TIMEOUT');
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error(
          AppStrings.apiReceiveTimeout,
          'RECEIVE_TIMEOUT',
        );
      case DioExceptionType.badResponse:
        return ApiResponse.error(AppStrings.apiBadResponse, 'BAD_RESPONSE');
      case DioExceptionType.cancel:
        return ApiResponse.error(
          AppStrings.apiRequestCancelled,
          'REQUEST_CANCELLED',
        );
      case DioExceptionType.connectionError:
        return ApiResponse.error(AppStrings.apiNoInternet, 'NO_INTERNET');
      default:
        return ApiResponse.error(AppStrings.apiNetworkError, 'NETWORK_ERROR');
    }
  } catch (e) {
    return ApiResponse.error(AppStrings.apiUnknownError, 'UNKNOWN_ERROR');
  }
}

Future<ApiResponse<LoginResponse>> loginUser(
  String loginUrl,
  LoginRequest loginRequest,
) async {
  log('loginUrl: $loginUrl');
  log('loginRequest: [36m${loginRequest.toJson()}[0m');
  // Initialize Dio handler
  final dioHandler = DioHandler();
  dioHandler.init();

  try {
    // Create login request
    final response = await dioHandler.dio.post(
      loginUrl,
      data: loginRequest.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('loginResponse: ${response.data}');
      return ApiResponse.success(LoginResponse.fromJson(response.data));
    } else {
      return ApiResponse.error(AppStrings.apiLoginFailed, 'LOGIN_FAILED');
    }
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResponse.error(
          AppStrings.apiConnectionTimeout,
          'CONNECTION_TIMEOUT',
        );
      case DioExceptionType.sendTimeout:
        return ApiResponse.error(AppStrings.apiSendTimeout, 'SEND_TIMEOUT');
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error(
          AppStrings.apiReceiveTimeout,
          'RECEIVE_TIMEOUT',
        );
      case DioExceptionType.badResponse:
        // Handle specific HTTP error responses
        if (e.response?.statusCode == 401) {
          return ApiResponse.error(
            AppStrings.apiInvalidCredentials,
            'INVALID_CREDENTIALS',
          );
        } else if (e.response?.statusCode == 400) {
          return ApiResponse.error(AppStrings.apiBadRequest, 'BAD_REQUEST');
        } else {
          return ApiResponse.error(AppStrings.apiServerError, 'SERVER_ERROR');
        }
      case DioExceptionType.cancel:
        return ApiResponse.error(
          AppStrings.apiRequestCancelled,
          'REQUEST_CANCELLED',
        );
      case DioExceptionType.connectionError:
        return ApiResponse.error(AppStrings.apiNoInternet, 'NO_INTERNET');
      default:
        return ApiResponse.error(AppStrings.apiNetworkError, 'NETWORK_ERROR');
    }
  } catch (e) {
    return ApiResponse.error(AppStrings.apiUnknownError, 'UNKNOWN_ERROR');
  }
}
