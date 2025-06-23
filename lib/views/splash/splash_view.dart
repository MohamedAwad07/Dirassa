import 'package:dirassa/core/services/status_bar_config.dart';
import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_strings.dart';
import 'package:dirassa/viewmodels/cubits/auth_cubit/auth_cubit.dart';
import 'package:dirassa/viewmodels/cubits/url_cubit/url_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    // Start fetching URLs
    context.read<UrlCubit>().fetchUrls();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        _opacity = 1.0;
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
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, authState) {
            if (authState is AuthAuthenticated) {
              // User has valid token, navigate to home
              _navigateToHome();
            }
          },
        ),
        BlocListener<UrlCubit, UrlState>(
          listener: (context, urlState) {
            if (urlState.status == UrlStatus.success ||
                urlState.status == UrlStatus.error) {
              // Check if user has valid token
              final authState = context.read<AuthCubit>().state;
              if (authState is AuthAuthenticated) {
                _navigateToHome();
              } else {
                _navigateToLogin();
              }
            }
          },
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _opacity = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      });
    });
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _opacity = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
    });
  }
}
