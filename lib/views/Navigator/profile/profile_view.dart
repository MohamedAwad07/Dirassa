import 'package:dirassa/core/components/webview_screen.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final bool fromSettings;
  const ProfileView({super.key, this.fromSettings = false});

  @override
  Widget build(BuildContext context) {
    if (fromSettings) {
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: fromSettings),
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
