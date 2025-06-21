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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrlCubit, UrlState>(
      builder: (context, urlState) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              spacing: 24,
              children: [
                const Spacer(),
                Image.asset(
                  Assets.assetsImagesRegisterLanding,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                const Text(
                  AppStrings.registerTitle,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  AppStrings.registerDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                CustomButton(
                  text: AppStrings.registerButton,
                  // onPressed: urlState.registerUrl != null
                  //     ? () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (_) => const WebViewScreen(
                  //               // url: urlState.registerUrl!,
                  //               url: "https://www.google.com",
                  //               title: 'Register',
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //     : () {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           const SnackBar(
                  //             content: Center(
                  //               child: Text(AppStrings.urlNotAvailable),
                  //             ),
                  //           ),
                  //         );
                  //       }, // Empty function if URL is not available
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WebViewScreen(
                          url: "https://www.google.com",
                          title: AppStrings.registerTitle,
                        ),
                      ),
                    );
                  },
                ),
                CustomTextButton(
                  text: AppStrings.registerHasAccount,
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
