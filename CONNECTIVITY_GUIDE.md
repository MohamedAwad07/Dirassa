# Connectivity Guide

This guide explains how to use the connectivity system in the Flutter app to monitor internet connectivity and provide user feedback.

## Overview

The app uses the `connectivity_plus` package to monitor internet connectivity in real-time. When the connection is lost while on the home screen, users see a connection error screen, and when it's restored, they receive a success notification.

## Components

### ConnectivityCubit

Manages connectivity state using BLoC pattern:

```dart
class ConnectivityCubit extends Cubit<ConnectivityState> {
  // Monitors connectivity changes
  // Handles MissingPluginException gracefully
  // Provides manual connectivity checking
}
```

### ConnectivityWrapper

Wraps the home screen to show connection error screen when offline:

```dart
// In home_view.dart
ConnectivityWrapper(
  showErrorScreen: true,
  child: Scaffold(...),
)
```

### ConnectionErrorView

Shows when internet connection is lost:

- Theme-aware design
- Retry functionality
- Automatic connection detection
- Success message when connection is restored

### ConnectivityIndicator

Small icon in app bar showing connection status:

- Green WiFi icon: Connected
- Red WiFi-off icon: Disconnected
- Gray help icon: Unknown status

## Usage

### Basic Implementation

```dart
// In your widget
BlocBuilder<ConnectivityCubit, ConnectivityState>(
  builder: (context, state) {
    switch (state.status) {
      case ConnectivityStatus.connected:
        return Text('Connected');
      case ConnectivityStatus.disconnected:
        return Text('Disconnected');
      case ConnectivityStatus.unknown:
        return Text('Unknown');
    }
  },
)

// Manual connectivity check
context.read<ConnectivityCubit>().checkConnectivity();
```

## Connectivity States

### ConnectivityStatus Enum

- **connected**: Device has internet connectivity (WiFi, mobile, or ethernet)
- **disconnected**: No internet connectivity available
- **unknown**: Connectivity status cannot be determined

### Visual Indicators

- **Green WiFi icon**: Connected to internet
- **Red WiFi-off icon**: No internet connection
- **Gray help icon**: Unknown connectivity status

## Integration with Existing Components

### Connection Error View

The connection error view provides:

- Theme-aware colors
- Integration with connectivity cubit
- Functional retry button
- Automatic status updates
- Success message when connection is restored

### App Bar Integration

Connectivity indicator added to home view app bar:

- Shows real-time connectivity status
- Non-intrusive design
- Theme-aware colors

### Home Screen Integration

ConnectivityWrapper is applied only to the home screen:

- Shows error screen when disconnected on home screen
- Other screens (login, splash, etc.) work normally without connectivity checking
- Focused connectivity monitoring where it's most needed

## Platform Support

### Android

- Full support for all connectivity types
- Real-time monitoring
- Background connectivity changes
- Permission handling

### iOS

- Full support for WiFi and mobile data
- Real-time monitoring
- Background app refresh compatibility
- Network extension support

### Web

- Limited connectivity detection
- Basic online/offline status
- Browser-based connectivity checking

## Best Practices

### 1. Always Handle Connectivity Changes

```dart
BlocBuilder<ConnectivityCubit, ConnectivityState>(
  builder: (context, state) {
    // Handle different connectivity states
    return YourWidget();
  },
)
```

### 2. Provide User Feedback

```dart
// Show loading state during connectivity check
ElevatedButton(
  onPressed: () async {
    final isConnected = await context.read<ConnectivityCubit>().checkConnectivity();
    if (isConnected) {
      // Proceed with network operation
    } else {
      // Show error message
    }
  },
  child: Text('Check Connection'),
)
```

### 3. Graceful Error Handling

The connectivity cubit automatically handles:

- MissingPluginException (assumes connected)
- Stream errors (assumes connected)
- Platform-specific issues

## Error Handling

### MissingPluginException

The system gracefully handles cases where connectivity checking is not available:

- Assumes connected state by default
- Continues normal app operation
- No crashes or errors

### Stream Errors

If the connectivity stream fails:

- App assumes connected state
- Continues normal operation
- No interruption to user experience

## Testing

### Manual Testing

```dart
// Simulate connectivity loss
context.read<ConnectivityCubit>().emit(ConnectivityState(ConnectivityStatus.disconnected));

// Simulate connectivity restoration
context.read<ConnectivityCubit>().emit(ConnectivityState(ConnectivityStatus.connected));
```

### Test Scenarios

1. **Normal Flow**: Connected → Navigate to Home → Disconnected → Error Screen → Connected → Success Message
2. **Other Screens**: Login, splash, and other screens work normally without connectivity checking
3. **Home Screen Focus**: Only home screen shows connectivity error when disconnected
4. **Multiple Disconnections**: Should handle repeated connection issues on home screen

## User Experience

### Connection Lost on Home Screen

1. User sees connection error screen
2. Clear error message and retry button
3. Theme-aware design matches app theme

### Connection Restored on Home Screen

1. Automatic detection of connection restoration
2. Success message appears
3. App continues normal operation

### Other Screens

1. Login, splash, and other screens work normally
2. No connectivity checking on these screens
3. Users can navigate freely without connectivity restrictions

### Retry Functionality

1. User can manually check connectivity
2. Loading indicator during check
3. Immediate feedback on connection status

## Performance Considerations

- Real-time monitoring with minimal performance impact
- Automatic error handling prevents crashes
- Efficient state management with BLoC pattern
- Graceful degradation when connectivity checking unavailable
- Focused connectivity checking only on home screen

## Dependencies

The connectivity system uses:

- `connectivity_plus: ^5.0.2`: For connectivity detection
- `flutter_bloc: ^8.1.3`: For state management
- `equatable: ^2.0.5`: For state comparison

## Permissions

### Android

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS

No additional permissions required for basic connectivity checking.

## Troubleshooting

### Common Issues

#### MissingPluginException

- **Cause**: Platform-specific connectivity checking not available
- **Solution**: System automatically assumes connected state
- **Impact**: No user-facing issues

#### Connectivity Not Detected

- **Cause**: Platform permissions or configuration issues
- **Solution**: Check platform-specific setup
- **Impact**: App continues with assumed connected state

#### Performance Issues

- **Cause**: Excessive connectivity checking
- **Solution**: Use automatic monitoring, avoid manual checks in loops
- **Impact**: Minimal with proper implementation

#### Error Screen Not Showing

- **Cause**: ConnectivityWrapper not applied to home screen
- **Solution**: Ensure ConnectivityWrapper wraps the home screen Scaffold
- **Impact**: No connectivity error feedback on home screen

### Debug Information

Enable debug logging to track connectivity changes:

```dart
// Add to your debug configuration
if (kDebugMode) {
  print('Connectivity status: ${state.status}');
}
```

## Future Enhancements

1. **Selective Connectivity Checking**: Apply connectivity checking to specific screens as needed
2. **Advanced Detection**: More granular connectivity types
3. **Offline Mode**: Enhanced offline functionality for home screen
4. **Analytics**: Track connectivity patterns

## Conclusion

The connectivity system provides focused internet connectivity monitoring for the home screen with graceful error handling and excellent user experience. It automatically adapts to different platforms and handles edge cases seamlessly, while allowing other screens to function normally without connectivity restrictions.
