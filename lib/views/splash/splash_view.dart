import 'package:dirassa/core/services/status_bar_config.dart';
import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Configure status bar for splash screen (full screen experience)
    StatusBarConfig.setFullScreen();

    // Fade in
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        _opacity = 1.0;
      });
      // Fade out after visible for a while
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() {
          _opacity = 0.0;
        });
        // Navigate after fade out
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/login');
        });
      });
    });
  }

  @override
  void dispose() {
    // Restore normal status bar when leaving splash
    StatusBarConfig.setEdgeToEdge();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 800),
              child: Image.asset(Assets.assetsImagesLogo, height: 120),
            ),
          ),
          const Spacer(),
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 800),
            child: const Text(AppStrings.copyright),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
