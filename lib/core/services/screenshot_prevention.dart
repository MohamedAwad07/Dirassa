import 'package:dirassa/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'ios_screenshot_detection.dart';

class ScreenshotPrevention {
  static bool _isInitialized = false;
  static Function()? _screenshotCallback;
  static OverlayEntry? _overlayEntry;
  static bool _isShowingMessage = false;
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Initialize screenshot prevention (call this once in main)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    if (Platform.isIOS) {
      await IOSScreenshotDetection.initialize();
    }

    _isInitialized = true;
  }

  /// Set navigator key for overlay access
  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
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
      _showScreenshotPreventionMessage();
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

  /// Manually trigger screenshot prevention message (for testing)
  static void showScreenshotPreventionMessage() {
    _showScreenshotPreventionMessage();
  }

  /// Show screenshot prevention message from widget context
  static void showScreenshotPreventionMessageFromContext(BuildContext context) {
    if (_isShowingMessage) return;

    _isShowingMessage = true;

    // Remove any existing overlay
    _hideScreenshotPreventionMessage();

    _overlayEntry = OverlayEntry(
      builder: (context) => _ScreenshotPreventionMessage(),
    );

    try {
      Overlay.of(context).insert(_overlayEntry!);
      debugPrint('Screenshot prevention message overlay inserted from context');
    } catch (e) {
      debugPrint('Error inserting overlay from context: $e');
      _isShowingMessage = false;
      return;
    }

    // Auto-remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _hideScreenshotPreventionMessage();
    });
  }

  /// Simple test method to verify overlay is working
  static void showTestMessage(BuildContext context) {
    if (_isShowingMessage) return;

    _isShowingMessage = true;

    // Remove any existing overlay
    _hideScreenshotPreventionMessage();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16,
        left: 16,
        right: 16,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Test Message - Overlay is working!',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );

    try {
      Overlay.of(context).insert(_overlayEntry!);
      debugPrint('Test message overlay inserted');
    } catch (e) {
      debugPrint('Error inserting test overlay: $e');
      _isShowingMessage = false;
      return;
    }

    // Auto-remove after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _hideScreenshotPreventionMessage();
    });
  }

  /// Show modern screenshot prevention message
  static void _showScreenshotPreventionMessage() {
    if (_isShowingMessage) return;

    _isShowingMessage = true;

    // Get the current context from navigator key
    final context = _navigatorKey?.currentContext;
    if (context == null) {
      debugPrint(
        'No context available for showing screenshot prevention message',
      );
      _isShowingMessage = false;
      return;
    }

    // Remove any existing overlay
    _hideScreenshotPreventionMessage();

    _overlayEntry = OverlayEntry(
      builder: (context) => _ScreenshotPreventionMessage(),
    );

    try {
      Overlay.of(context).insert(_overlayEntry!);
      debugPrint('Screenshot prevention message overlay inserted');
    } catch (e) {
      debugPrint('Error inserting overlay: $e');
      _isShowingMessage = false;
      return;
    }

    // Auto-remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _hideScreenshotPreventionMessage();
    });
  }

  /// Hide screenshot prevention message
  static void _hideScreenshotPreventionMessage() {
    if (_overlayEntry != null) {
      try {
        _overlayEntry!.remove();
        debugPrint('Screenshot prevention message overlay removed');
      } catch (e) {
        debugPrint('Error removing overlay: $e');
      }
      _overlayEntry = null;
    }
    _isShowingMessage = false;
  }
}

/// Modern screenshot prevention message widget
class _ScreenshotPreventionMessage extends StatefulWidget {
  @override
  State<_ScreenshotPreventionMessage> createState() =>
      _ScreenshotPreventionMessageState();
}

class _ScreenshotPreventionMessageState
    extends State<_ScreenshotPreventionMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.security,
                      color: Colors.red[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.screenshotDetected,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.screenshotNotAllowed,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[300]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScreenshotPrevention._hideScreenshotPreventionMessage();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
