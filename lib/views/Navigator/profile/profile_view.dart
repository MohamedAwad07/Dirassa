import 'package:dirassa/core/components/webview_screen.dart';
import 'package:dirassa/core/services/screenshot_prevention.dart';
import 'package:dirassa/viewmodels/cubits/url_cubit/url_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<UrlCubit, UrlState>(
      builder: (context, urlState) {
        if (urlState.profileUrl != null) {
          if (widget.fromSettings) {
            return Scaffold(
              appBar: AppBar(automaticallyImplyLeading: widget.fromSettings),
              body: WebViewScreen(
                url: urlState.profileUrl!,
                showBackButton: false,
                title: 'الحساب الشخصي',
              ),
            );
          }
          return Scaffold(
            body: WebViewScreen(
              url: urlState.profileUrl!,
              showBackButton: false,
              title: 'الحساب الشخصي',
            ),
          );
        } else {
          // Show loading or error state
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (urlState.status == UrlStatus.loading)
                    const CircularProgressIndicator()
                  else
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    urlState.status == UrlStatus.loading
                        ? 'Loading...'
                        : 'Failed to load profile page',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
