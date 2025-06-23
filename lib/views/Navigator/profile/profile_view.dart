import 'package:dirassa/core/components/webview_screen.dart';
import 'package:dirassa/core/services/screenshot_prevention.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:dirassa/core/utils/app_strings.dart';
import 'package:dirassa/viewmodels/cubits/url_cubit/url_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  final bool fromSettings;
  final bool showAppBar;
  const ProfileView({
    super.key,
    this.fromSettings = false,
    this.showAppBar = false,
  });

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

  void _retryLoading() {
    context.read<UrlCubit>().fetchUrls();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UrlCubit, UrlState, Map<String, String?>>(
      selector: (state) => {
        'profileUrl': state.profileUrl,
        'userAgent': state.userAgent,
      },
      builder: (context, data) {
        final profileUrl = data['profileUrl'];
        final userAgent = data['userAgent'];
        if (profileUrl != null) {
          if (widget.fromSettings) {
            return Scaffold(
              appBar: AppBar(automaticallyImplyLeading: widget.fromSettings),
              body: WebViewScreen(
                fromHome: true,
                url: profileUrl,
                showBackButton: false,
                userAgent: userAgent,
              ),
            );
          }
          return Scaffold(
            body: WebViewScreen(
              fromHome: true,
              url: profileUrl,
              showBackButton: false,
              userAgent: userAgent,
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
                      if (status != UrlStatus.loading) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ElevatedButton.icon(
                            onPressed: _retryLoading,
                            icon: const Icon(Icons.refresh),
                            label: const Text(AppStrings.reload),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
