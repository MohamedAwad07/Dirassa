# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep your app's main classes
-keep class com.example.dirassa.** { *; }

# Connectivity Plus rules
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# Flutter Bloc rules
-keep class ** extends flutter_bloc.** { *; }
-keep class ** implements flutter_bloc.** { *; }

# Shared Preferences rules
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# WebView rules
-keep class io.flutter.plugins.webviewflutter.** { *; }

# SVG rules
-keep class com.caverock.androidsvg.** { *; }

# General optimization - more aggressive
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify

# Remove unused classes and methods
-dontwarn **
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes Exceptions

# Remove debug information
-renamesourcefileattribute SourceFile 