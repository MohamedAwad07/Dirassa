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
  
  private func initializeScreenshotDetection(result: @escaping FlutterResult) {
    // Screenshot detection is already initialized in setupScreenshotDetection()
    result(nil)
  }
  
  private func checkScreenRecording(result: @escaping FlutterResult) {
    if #available(iOS 11.0, *) {
      let isRecording = UIScreen.main.isCaptured
      result(isRecording)
    } else {
      result(false)
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
    // Screenshot was taken - notify Flutter
    debugPrint("Screenshot detected!")
    
    // Notify Flutter through method channel
    screenshotChannel?.invokeMethod("screenshotTaken", arguments: nil)
    
    // Optionally show an alert
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
        
        // Screen recording started - implement protection
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
