import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class IOSScreenshotDetection {
  static const MethodChannel _channel = MethodChannel('screenshot_detection');

  /// Initialize screenshot detection for iOS
  static Future<void> initialize() async {
    try {
      await _channel.invokeMethod('initialize');
    } on PlatformException catch (e) {
      debugPrint('Failed to initialize screenshot detection: ${e.message}');
    }
  }

  /// Check if screen recording is active (iOS 11+)
  static Future<bool> isScreenRecording() async {
    try {
      final bool isRecording = await _channel.invokeMethod('isScreenRecording');
      return isRecording;
    } on PlatformException catch (e) {
      debugPrint('Failed to check screen recording status: ${e.message}');
      return false;
    }
  }

  /// Set up screenshot detection callback
  static void setScreenshotCallback(Function() callback) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'screenshotTaken':
          callback();
          break;
        case 'screenRecordingStarted':
          callback();
          break;
      }
    });
  }

  /// Remove screenshot detection callback
  static void removeScreenshotCallback() {
    _channel.setMethodCallHandler(null);
  }
}
