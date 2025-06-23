import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dirassa/core/utils/app_strings.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// Get current connectivity result
  Future<ConnectivityResult> getConnectivityResult() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  /// Check if connected to WiFi
  Future<bool> isConnectedToWifi() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result == ConnectivityResult.wifi;
    } catch (e) {
      return false;
    }
  }

  /// Check if connected to mobile data
  Future<bool> isConnectedToMobile() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result == ConnectivityResult.mobile;
    } catch (e) {
      return false;
    }
  }

  /// Check if connected to ethernet
  Future<bool> isConnectedToEthernet() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result == ConnectivityResult.ethernet;
    } catch (e) {
      return false;
    }
  }

  /// Get connectivity status as string
  Future<String> getConnectivityStatusString() async {
    try {
      final result = await _connectivity.checkConnectivity();
      switch (result) {
        case ConnectivityResult.wifi:
          return AppStrings.connectivityWifi;
        case ConnectivityResult.mobile:
          return AppStrings.connectivityMobileData;
        case ConnectivityResult.ethernet:
          return AppStrings.connectivityEthernet;
        case ConnectivityResult.none:
          return AppStrings.connectivityNoConnection;
        default:
          return AppStrings.connectivityUnknown;
      }
    } catch (e) {
      return AppStrings.connectivityError;
    }
  }
}
