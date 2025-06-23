import 'package:dirassa/core/components/custom_button.dart';
import 'package:dirassa/core/components/custom_text_button.dart';
import 'package:dirassa/core/components/webview_screen.dart';
import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_strings.dart';
import 'package:dirassa/core/services/screenshot_prevention.dart';
import 'package:dirassa/viewmodels/cubits/url_cubit/url_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  void initState() {
    super.initState();
    // Prevent screenshots on register screen
    ScreenshotPrevention.preventScreenshots();
  }

  @override
  void dispose() {
    // Allow screenshots when leaving register screen
    ScreenshotPrevention.allowScreenshots();
    super.dispose();
  }

  void _retryLoading() {
    context.read<UrlCubit>().fetchUrls();
  }

  void _showRetrySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text(AppStrings.urlNotAvailable)),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _retryLoading,
              child: const Text(
                AppStrings.reload,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UrlCubit, UrlState, String?>(
      selector: (state) => state.registerUrl,
      builder: (context, registerUrl) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical:
                          MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 36
                          : 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                          const Spacer(),
                        Image.asset(
                          Assets.assetsImagesRegisterLanding,
                          height:
                              MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 150
                              : 100,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 24
                              : 16,
                        ),
                        const Text(
                          AppStrings.registerTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          AppStrings.registerDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 24
                              : 16,
                        ),
                        CustomButton(
                          text: AppStrings.registerButton,
                          onPressed: registerUrl != null
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => WebViewScreen(
                                        url: registerUrl,
                                        title: AppStrings.registerTitle,
                                      ),
                                    ),
                                  );
                                }
                              : _showRetrySnackBar,
                        ),
                        const SizedBox(height: 16),
                        CustomTextButton(
                          text: AppStrings.registerHasAccount,
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        if (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                          const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
