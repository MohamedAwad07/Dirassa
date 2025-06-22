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
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Center(
                                        child: Text(AppStrings.urlNotAvailable),
                                      ),
                                    ),
                                  );
                                },
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
