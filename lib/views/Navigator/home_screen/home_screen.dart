import 'package:dirassa/core/components/webview_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WebViewScreen(
        url: 'https://www.google.com',
        showBackButton: false,
        title: 'الجلسات المباشرة',
      ),
    );
  }
}
