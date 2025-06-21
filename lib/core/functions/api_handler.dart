import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dirassa/models/config_response.dart';
import 'package:dirassa/models/Login/login_request.dart';
import 'package:dirassa/models/Login/login_response.dart';

// Dio handler class
class DioHandler {
  static final DioHandler _instance = DioHandler._internal();
  factory DioHandler() => _instance;
  DioHandler._internal();

  late Dio _dio;
  static const String baseUrl = 'https://dirassa.online/api';
  static const String configUrl = '$baseUrl/config/app_links.php';
  static const String loginUrl = '$baseUrl/config/login/';
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

Future<ConfigResponse> fetchConfig() async {
  // Initialize Dio handler
  final dioHandler = DioHandler();
  dioHandler.init();

  try {
    final response = await dioHandler.dio.get(DioHandler.configUrl);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ConfigResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load config: ${response.statusCode}');
    }
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        throw Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        throw Exception('Receive timeout');
      case DioExceptionType.badResponse:
        throw Exception('Bad response: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        throw Exception('Request cancelled');
      case DioExceptionType.connectionError:
        throw Exception('No internet connection');
      default:
        throw Exception('Network error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Error fetching config: $e');
  }
}

Future<LoginResponse> loginUser(LoginRequest loginRequest) async {
  log('loginRequest: ${loginRequest.toJson()}');
  // Initialize Dio handler
  final dioHandler = DioHandler();
  dioHandler.init();

  try {
    // Create login request
    final response = await dioHandler.dio.post(
      DioHandler.loginUrl,
      data: loginRequest.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('loginResponse: ${response.data}');
      return LoginResponse.fromJson(response.data);
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        throw Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        throw Exception('Receive timeout');
      case DioExceptionType.badResponse:
        // Handle specific HTTP error responses
        if (e.response?.statusCode == 401) {
          throw Exception('Invalid credentials');
        } else if (e.response?.statusCode == 400) {
          throw Exception('Bad request - check your input');
        } else {
          throw Exception('Server error: ${e.response?.statusCode}');
        }
      case DioExceptionType.cancel:
        throw Exception('Request cancelled');
      case DioExceptionType.connectionError:
        throw Exception('No internet connection');
      default:
        throw Exception('Network error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Error during login: $e');
  }
}
