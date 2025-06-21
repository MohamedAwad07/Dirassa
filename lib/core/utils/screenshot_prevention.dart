import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'ios_screenshot_detection.dart';

class ScreenshotPrevention {
  static bool _isInitialized = false;
  static Function()? _screenshotCallback;

  /// Initialize screenshot prevention (call this once in main)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    if (Platform.isIOS) {
      await IOSScreenshotDetection.initialize();
    }

    _isInitialized = true;
  }

  /// Prevents screenshots and screen recording
  static void preventScreenshots() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    // Set flags to prevent screenshots
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    // Setup iOS screenshot detection if on iOS
    if (Platform.isIOS) {
      _setupIOSScreenshotDetection();
    }
  }

  /// Allows screenshots and screen recording (restores normal behavior)
  static void allowScreenshots() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    // Remove iOS screenshot detection
    if (Platform.isIOS) {
      _removeIOSScreenshotDetection();
    }
  }

  /// Setup iOS screenshot detection with callback
  static void _setupIOSScreenshotDetection() {
    _screenshotCallback = () {
      debugPrint('Screenshot or screen recording detected on iOS!');
      // You can implement custom logic here, such as:
      // - Showing a warning dialog
      // - Logging the event
      // - Taking security measures
    };

    IOSScreenshotDetection.setScreenshotCallback(_screenshotCallback!);
  }

  /// Remove iOS screenshot detection
  static void _removeIOSScreenshotDetection() {
    if (_screenshotCallback != null) {
      IOSScreenshotDetection.removeScreenshotCallback();
      _screenshotCallback = null;
    }
  }

  /// Check if screen recording is active (iOS only)
  static Future<bool> isScreenRecording() async {
    if (Platform.isIOS) {
      return await IOSScreenshotDetection.isScreenRecording();
    }
    return false;
  }

  /// Set custom screenshot detection callback
  static void setScreenshotCallback(Function() callback) {
    _screenshotCallback = callback;

    if (Platform.isIOS) {
      IOSScreenshotDetection.setScreenshotCallback(callback);
    }
  }
}
