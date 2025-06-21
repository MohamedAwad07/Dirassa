import 'package:dirassa/core/components/webview_screen.dart';
import 'package:dirassa/core/services/screenshot_prevention.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final bool fromSettings;
  const ProfileView({super.key, this.fromSettings = false});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    // Prevent screenshots on profile screen
    ScreenshotPrevention.preventScreenshots();
  }

  @override
  void dispose() {
    // Allow screenshots when leaving profile screen
    ScreenshotPrevention.allowScreenshots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromSettings) {
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: widget.fromSettings),
        body: const WebViewScreen(
          url: 'https://www.google.com',
          showBackButton: false,
          title: 'الحساب الشخصي',
        ),
      );
    }
    return const Scaffold(
      body: WebViewScreen(
        url: 'https://www.google.com',
        showBackButton: false,
        title: 'الحساب الشخصي',
      ),
    );
  }
}
