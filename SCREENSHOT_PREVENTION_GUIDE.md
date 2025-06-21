# Screenshot Prevention Guide

This guide explains how screenshot prevention is implemented in the Dirassa Flutter app for both Android and iOS platforms.

## Overview

The app implements screenshot prevention to protect sensitive information from being captured through screenshots or screen recordings. This is achieved through:

1. **Android**: Using `FLAG_SECURE` flag in the MainActivity
2. **iOS**: Using `UIScreenCapturedDidChangeNotification` and `UIApplication.userDidTakeScreenshotNotification`

## Implementation Details

### Android Implementation

#### 1. MainActivity.kt

The Android implementation uses the `FLAG_SECURE` flag to prevent screenshots and screen recordings:

```kotlin
// android/app/src/main/kotlin/com/example/dirassa/MainActivity.kt
import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Prevent screenshots and screen recordings
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
    }
}
```

#### 2. AndroidManifest.xml

The manifest includes necessary permissions and configurations:

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:allowBackup="false"
        android:icon="@mipmap/ic_launcher"
        android:label="Dirassa"
        android:name="${applicationName}"
        android:theme="@style/LaunchTheme">

        <activity
            android:name=".MainActivity"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:exported="true"
            android:hardwareAccelerated="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:windowSoftInputMode="adjustResize">

            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />

            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

### iOS Implementation

#### 1. AppDelegate.swift

The iOS implementation uses native notifications to detect screenshots and screen recordings:

```swift
// ios/Runner/AppDelegate.swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var screenshotChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Setup method channel for screenshot detection
    setupMethodChannel()

    // Setup screenshot detection
    setupScreenshotDetection()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupMethodChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else { return }

    screenshotChannel = FlutterMethodChannel(
      name: "screenshot_detection",
      binaryMessenger: controller.binaryMessenger
    )

    screenshotChannel?.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "initialize":
        self?.initializeScreenshotDetection(result: result)
      case "isScreenRecording":
        self?.checkScreenRecording(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func setupScreenshotDetection() {
    // Listen for screenshot events
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenshotTaken),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )

    // Listen for screen recording events (iOS 11+)
    if #available(iOS 11.0, *) {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(screenRecordingChanged),
        name: UIScreen.capturedDidChangeNotification,
        object: nil
      )
    }
  }

  @objc private func screenshotTaken() {
    debugPrint("Screenshot detected!")

    // Notify Flutter through method channel
    screenshotChannel?.invokeMethod("screenshotTaken", arguments: nil)

    // Show alert
    DispatchQueue.main.async {
      self.showScreenshotAlert()
    }
  }

  @objc private func screenRecordingChanged() {
    if #available(iOS 11.0, *) {
      let isScreenRecording = UIScreen.main.isCaptured
      debugPrint("Screen recording status changed: \(isScreenRecording)")

      if isScreenRecording {
        // Notify Flutter through method channel
        screenshotChannel?.invokeMethod("screenRecordingStarted", arguments: nil)

        // Show alert
        DispatchQueue.main.async {
          self.showScreenRecordingAlert()
        }
      }
    }
  }

  private func showScreenshotAlert() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else { return }

    let alert = UIAlertController(
      title: "Screenshot Detected",
      message: "Screenshots are not allowed for security reasons.",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "OK", style: .default))

    window.rootViewController?.present(alert, animated: true)
  }

  private func showScreenRecordingAlert() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else { return }

    let alert = UIAlertController(
      title: "Screen Recording Detected",
      message: "Screen recording is not allowed for security reasons.",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "OK", style: .default))

    window.rootViewController?.present(alert, animated: true)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
```

#### 2. iOS Screenshot Detection Utility

A Flutter utility to communicate with the native iOS code:

```dart
// lib/core/utils/ios_screenshot_detection.dart
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
```

### Flutter Implementation

#### 1. Screenshot Prevention Utility

A unified utility that handles both platforms:

```dart
// lib/core/utils/screenshot_prevention.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
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
      // Custom logic can be implemented here
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
```

#### 2. Main App Initialization

Initialize screenshot prevention in the main function:

```dart
// lib/main.dart
import 'core/utils/screenshot_prevention.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observe();

  // Initialize screenshot prevention
  await ScreenshotPrevention.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ConnectivityCubit()),
      ],
      child: const MyApp(),
    ),
  );
}
```

## Usage in Views

### Enabling Screenshot Prevention

To enable screenshot prevention on specific screens:

```dart
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    ScreenshotPrevention.preventScreenshots();
  }

  @override
  void dispose() {
    ScreenshotPrevention.allowScreenshots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your screen content
    );
  }
}
```

### Custom Screenshot Detection Callback

To implement custom logic when screenshots are detected:

```dart
@override
void initState() {
  super.initState();
  ScreenshotPrevention.preventScreenshots();

  // Set custom callback
  ScreenshotPrevention.setScreenshotCallback(() {
    // Custom logic when screenshot is detected
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Security Alert'),
        content: Text('Screenshot detected!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  });
}
```

## Platform-Specific Features

### Android

- **FLAG_SECURE**: Prevents screenshots and screen recordings at the system level
- **Automatic**: Works immediately when the app starts
- **No Detection**: Cannot detect when screenshots are attempted (they're blocked)

### iOS

- **Detection Only**: Cannot prevent screenshots at the system level
- **UIScreenCapturedDidChangeNotification**: Detects screen recording (iOS 11+)
- **UIApplication.userDidTakeScreenshotNotification**: Detects screenshots
- **Custom Alerts**: Can show custom alerts when screenshots are detected
- **Method Channel**: Communicates between native iOS and Flutter

## Security Considerations

1. **Android**: Screenshots are completely blocked, providing the highest security
2. **iOS**: Screenshots can be detected but not prevented, requiring user education
3. **Screen Recording**: Both platforms can detect screen recording
4. **User Experience**: Consider the balance between security and user experience

## Testing

### Android Testing

1. Try to take a screenshot - it should be blocked
2. Try to start screen recording - it should be blocked
3. The screen should appear black in recent apps

### iOS Testing

1. Take a screenshot - you should see an alert
2. Start screen recording - you should see an alert
3. Check console logs for detection messages

## Troubleshooting

### Common Issues

1. **iOS alerts not showing**: Ensure the window and view controller are properly set up
2. **Method channel errors**: Check that the channel name matches between iOS and Flutter
3. **Android screenshots still working**: Verify FLAG_SECURE is set in MainActivity
4. **iOS detection not working**: Ensure notifications are properly registered

### Debug Tips

1. Check console logs for detection messages
2. Verify method channel communication
3. Test on physical devices (simulators may behave differently)
4. Ensure proper initialization order

## Future Enhancements

1. **Biometric Authentication**: Add fingerprint/face ID for sensitive screens
2. **Content Blurring**: Blur sensitive content when screenshots are detected
3. **Analytics**: Log screenshot attempts for security monitoring
4. **Custom UI**: Implement custom security overlays
