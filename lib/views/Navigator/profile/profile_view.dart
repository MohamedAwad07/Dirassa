import 'package:dirassa/core/components/webview_screen.dart';
import 'package:dirassa/core/services/screenshot_prevention.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrlCubit, UrlState>(
      builder: (context, urlState) {
        if (urlState.profileUrl != null) {
          if (widget.fromSettings) {
            return Scaffold(
              appBar: AppBar(automaticallyImplyLeading: widget.fromSettings),
              body: WebViewScreen(
                fromHome: true,
                url: urlState.profileUrl!,
                showBackButton: false,
                title: 'الحساب الشخصي',
              ),
            );
          }
          return Scaffold(
            body: WebViewScreen(
              fromHome: true,
              url: urlState.profileUrl!,
              showBackButton: false,
              title: 'الحساب الشخصي',
            ),
          );
        } else {
          // Show loading or error state
          if (widget.showAppBar) {
            return Scaffold(
              body: WebViewScreen(
                title: AppStrings.profile,
                url: "https://www.google.com",
                fromHome: widget.showAppBar,
                showBackButton: false,
              ),
            );
          } else if (widget.fromSettings) {
            return Scaffold(
              body: WebViewScreen(
                showBackButton: widget.fromSettings,
                url: "https://www.google.com",
              ),
            );
          }
          return const SizedBox.shrink();
        }
      },
    );
  }
}
