# Dirassa - Flutter App

A modern Flutter application with comprehensive security features, theme management, and connectivity monitoring.

## 🚀 Features

### 🔒 Security Features

- **Screenshot Prevention**: Prevents screenshots and screen recordings on sensitive screens
- **Android FLAG_SECURE**: Native Android screenshot blocking
- **iOS Screenshot Detection**: Real-time screenshot and screen recording detection using `UIScreenCapturedDidChangeNotification`
- **Modern UI Alerts**: Beautiful animated messages when screenshots are detected

### 🎨 Theme Management

- **Light/Dark Theme**: Complete theme system with persistent storage
- **Theme Cubit**: State management for theme switching
- **Theme-Aware Components**: All UI components adapt to current theme
- **Default Light Theme**: App starts with light theme by default

### 🌐 Connectivity Monitoring

- **Real-time Monitoring**: Continuous internet connectivity checking
- **Connectivity Cubit**: State management for connectivity status
- **Visual Indicators**: Connectivity status shown in app bar
- **Error Handling**: Graceful handling of connection errors
- **Offline Support**: Proper offline state management

### 📱 UI/UX Features

- **RTL Support**: Full right-to-left language support for Arabic
- **Responsive Design**: Adapts to different screen sizes
- **Modern Components**: Custom buttons, text fields, and other UI components
- **WebView Integration**: Embedded web content support
- **Navigation**: Intuitive navigation with drawer and bottom navigation

## 🛠️ Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: Flutter Bloc/Cubit
- **Architecture**: Clean Architecture with MVVM pattern
- **Dependencies**:
  - `flutter_bloc` - State management
  - `connectivity_plus` - Network connectivity
  - `shared_preferences` - Local storage
  - `equatable` - Value equality

## 📁 Project Structure

```
lib/
├── core/
│   ├── components/          # Reusable UI components
│   ├── services/           # Business logic services
│   └── utils/              # Utility functions and constants
├── models/                 # Data models
├── viewmodels/
│   └── cubits/            # State management (BLoC pattern)
│       ├── auth_cubit/    # Authentication state
│       ├── theme_cubit/   # Theme management
│       └── connectivity_cubit/ # Network connectivity
└── views/                 # UI screens and widgets
    ├── auth/              # Authentication screens
    ├── Navigator/         # Main app navigation
    └── splash/            # Splash screen
```

## 🔧 Setup & Installation

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android Studio / VS Code
- iOS Simulator (for iOS development)

### Installation Steps

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd dirassa
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android

- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 34 (Android 14)
- Screenshot prevention: Uses `FLAG_SECURE` flag

#### iOS

- Minimum iOS: 11.0
- Screenshot detection: Uses `UIScreenCapturedDidChangeNotification`
- Screen recording detection: iOS 11+ support

## 🔒 Security Implementation

### Screenshot Prevention

The app implements comprehensive screenshot prevention:

#### Android

```kotlin
// MainActivity.kt
window.setFlags(
    WindowManager.LayoutParams.FLAG_SECURE,
    WindowManager.LayoutParams.FLAG_SECURE
)
```

#### iOS

```swift
// AppDelegate.swift
NotificationCenter.default.addObserver(
    self,
    selector: #selector(screenshotTaken),
    name: UIApplication.userDidTakeScreenshotNotification,
    object: nil
)
```

#### Flutter

```dart
// Enable screenshot prevention
ScreenshotPrevention.preventScreenshots();

// Disable screenshot prevention
ScreenshotPrevention.allowScreenshots();
```

### Protected Screens

- Home screen
- Profile screen
- Registration screen

## 🎨 Theme System

### Usage

```dart
// Toggle theme
context.read<ThemeCubit>().toggleTheme();

// Set specific theme
context.read<ThemeCubit>().setTheme(ThemeMode.dark);
```

### Features

- Persistent theme storage
- Light/Dark theme support
- Theme-aware components
- Default light theme

## 🌐 Connectivity Features

### Real-time Monitoring

```dart
// Check connectivity status
BlocBuilder<ConnectivityCubit, ConnectivityState>(
  builder: (context, state) {
    return ConnectivityIndicator(isConnected: state.isConnected);
  },
)
```

### Error Handling

- Connection error screens
- Automatic retry mechanisms
- User-friendly error messages

## 📱 UI Components

### Custom Components

- `CustomButton` - Theme-aware buttons
- `CustomTextField` - Styled text input fields
- `CustomTextButton` - Text-based buttons
- `WebViewScreen` - Embedded web content
- `ThemeToggle` - Theme switching widget

### Navigation

- Drawer navigation
- Bottom navigation
- Route management with `AppRouter`

## 🧪 Testing

### Screenshot Prevention Testing

#### iOS Testing

1. Run app on iOS device/simulator
2. Navigate to protected screens (Home, Profile, Register)
3. Try taking a screenshot
4. Verify screenshot prevention message appears

#### Android Testing

1. Run app on Android device/emulator
2. Navigate to protected screens
3. Try taking a screenshot
4. Verify screenshots are blocked

### Theme Testing

1. Navigate to Settings
2. Toggle between light and dark themes
3. Verify theme persistence across app restarts

### Connectivity Testing

1. Enable/disable internet connection
2. Verify connectivity indicator updates
3. Test offline error handling

## 📚 Documentation

- [Screenshot Prevention Guide](SCREENSHOT_PREVENTION_GUIDE.md)
- [Connectivity Guide](CONNECTIVITY_GUIDE.md)
- [Theme Guide](THEME_GUIDE.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:

- Create an issue in the repository
- Check the documentation guides
- Review the code comments
