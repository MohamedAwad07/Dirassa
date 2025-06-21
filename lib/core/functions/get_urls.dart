import 'package:dio/dio.dart';
import 'package:dirassa/models/config_response.dart';

// Dio handler class
class DioHandler {
  static final DioHandler _instance = DioHandler._internal();
  factory DioHandler() => _instance;
  DioHandler._internal();

  late Dio _dio;
  static const String configUrl = 'https://json.dirassa.com/config.json';
  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: configUrl,
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
