# Theme System Guide

This guide explains how to use the dark and light mode theme system implemented in the Dirassa Flutter app.

## Overview

The app now supports both dark and light modes with:

- Automatic theme persistence using SharedPreferences
- BLoC pattern for state management
- Comprehensive theme configuration
- Theme-aware components

## Architecture

### Theme Cubit (`lib/viewmodels/cubits/theme_cubit.dart`)

- Manages theme state using BLoC pattern
- Persists theme preference using SharedPreferences
- Provides methods to toggle and set themes

### Theme Configuration (`lib/core/utils/app_theme.dart`)

- Defines comprehensive light and dark themes
- Includes color schemes, component themes, and typography
- Uses Material 3 design principles

### Theme Components

- `ThemeToggle`: Reusable theme toggle widget
- `ThemeAwareText`: Theme-aware text widget
- Updated existing components for theme support

## Usage

### Basic Theme Toggle

```dart
// In any widget with BlocProvider access
BlocBuilder<ThemeCubit, ThemeState>(
  builder: (context, state) {
    final isDarkMode = state.themeMode == ThemeMode.dark;
    return Switch(
      value: isDarkMode,
      onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
    );
  },
)
```

### Using ThemeToggle Widget

```dart
// Simple toggle without label
ThemeToggle(showLabel: false)

// Toggle with label
ThemeToggle(showLabel: true)
```

### Theme-Aware Colors

```dart
// Use theme colors instead of hardcoded colors
final theme = Theme.of(context);
Container(
  color: theme.colorScheme.surface,
  child: Text(
    'Hello',
    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
  ),
)
```

### Using ThemeAwareText

```dart
// Automatically adapts to current theme
ThemeAwareText(
  'Hello World',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
)
```

## Theme Configuration

### Light Theme Features

- White background with light gray surfaces
- Dark text on light backgrounds
- Blue accent colors
- Subtle shadows and elevations

### Dark Theme Features

- Dark backgrounds (#121212, #1E1E1E)
- Light text on dark backgrounds
- Same accent colors for consistency
- Reduced contrast for better readability

### Customization

To customize themes, edit `lib/core/utils/app_theme.dart`:

```dart
// Add custom colors
static ThemeData get lightTheme {
  return ThemeData(
    // ... existing configuration
    colorScheme: const ColorScheme.light(
      primary: YourCustomColor,
      secondary: YourCustomColor,
      // ... other colors
    ),
  );
}
```

## Best Practices

### 1. Use Theme Colors

Always use theme colors instead of hardcoded colors:

```dart
// ❌ Bad
Container(color: Colors.white)

// ✅ Good
Container(color: Theme.of(context).colorScheme.surface)
```

### 2. Use ThemeAwareText

For text that should adapt to theme:

```dart
// ❌ Bad
Text('Hello', style: TextStyle(color: Colors.black))

// ✅ Good
ThemeAwareText('Hello')
```

### 3. Test Both Themes

Always test your UI in both light and dark modes to ensure readability and contrast.

### 4. Use Semantic Colors

Use semantic color names that make sense in both themes:

```dart
// Use surface instead of white/black
// Use onSurface instead of black/white
```

## Migration Guide

### Converting Existing Components

1. **Remove hardcoded colors:**

```dart
// Before
backgroundColor: Colors.white

// After
backgroundColor: Theme.of(context).colorScheme.surface
```

2. **Update text colors:**

```dart
// Before
Text('Hello', style: TextStyle(color: Colors.black))

// After
ThemeAwareText('Hello')
```

3. **Use theme-aware components:**

```dart
// Before
Switch(value: isDark, onChanged: onChanged)

// After
ThemeToggle(showLabel: false)
```

## Troubleshooting

### Theme Not Persisting

- Ensure SharedPreferences is properly initialized
- Check if the theme cubit is properly provided in the widget tree

### Colors Not Updating

- Make sure you're using `Theme.of(context)` to access theme colors
- Verify that the widget is wrapped in a `BlocBuilder<ThemeCubit, ThemeState>`

### Performance Issues

- Use `BlocBuilder` only where theme changes need to be reflected
- Consider using `BlocSelector` for more granular rebuilds

## Future Enhancements

1. **System Theme Detection**: Automatically follow system theme preference
2. **Custom Theme Colors**: Allow users to customize accent colors
3. **Theme Transitions**: Add smooth transitions between themes
4. **Accessibility**: Ensure proper contrast ratios for accessibility

## Dependencies

The theme system requires these dependencies:

- `flutter_bloc`: For state management
- `shared_preferences`: For theme persistence
- `equatable`: For state comparison

These are already included in `pubspec.yaml`.
