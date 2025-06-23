import 'package:dirassa/core/services/device_info_service.dart';

class DeviceUtils {
  static final DeviceInfoService _deviceInfoService = DeviceInfoService();

  /// Get the current device ID
  static Future<String> getDeviceId() async {
    return await _deviceInfoService.getDeviceId();
  }

  /// Get the device model name
  static Future<String> getDeviceModel() async {
    return await _deviceInfoService.getDeviceModel();
  }

  /// Get complete device information
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    return await _deviceInfoService.getDeviceInfo();
  }

  /// Get device ID as a simple string (for logging or display)
  static Future<String> getDeviceIdForDisplay() async {
    final deviceId = await getDeviceId();
    // Truncate long device IDs for display
    if (deviceId.length > 20) {
      return '${deviceId.substring(0, 17)}...';
    }
    return deviceId;
  }

  /// Get a formatted device info string
  static Future<String> getFormattedDeviceInfo() async {
    final deviceInfo = await getDeviceInfo();
    return '${deviceInfo['deviceModel']} (${deviceInfo['platform']})';
  }

  static Future<Map<String, dynamic>?> getAndroidInfo() async {
    return await _deviceInfoService.getAndroidInfo();
  }

  static Future<Map<String, dynamic>?> getIOSInfo() async {
    return await _deviceInfoService.getIOSInfo();
  }
}
