import 'package:dirassa/core/components/webview_screen.dart';
import 'package:dirassa/core/services/screenshot_prevention.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:dirassa/core/utils/app_strings.dart';
import 'package:dirassa/viewmodels/cubits/auth_cubit/auth_cubit.dart';
import 'package:dirassa/viewmodels/cubits/url_cubit/url_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ScreenshotPrevention.preventScreenshots();
  }

  @override
  void dispose() {
    ScreenshotPrevention.allowScreenshots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UrlCubit, UrlState, String?>(
      selector: (state) => state.homeUrl,
      builder: (context, homeUrl) {
        return BlocSelector<AuthCubit, AuthState, String?>(
          selector: (state) => state is AuthAuthenticated ? state.token : null,
          builder: (context, token) {
            if (homeUrl != null && token != null) {
              return Scaffold(
                body: WebViewScreen(
                  fromHome: true,
                  url: '$homeUrl?token=$token',
                  showBackButton: false,
                ),
              );
            } else {
              return BlocSelector<UrlCubit, UrlState, UrlStatus>(
                selector: (state) => state.status,
                builder: (context, status) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (status == UrlStatus.loading)
                            const CircularProgressIndicator(
                              color: AppColors.primary,
                            )
                          else
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                          const SizedBox(height: 16),
                          Text(
                            status == UrlStatus.loading
                                ? AppStrings.loading
                                : AppStrings.failedToLoadPage,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
