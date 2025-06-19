import 'package:dirassa/core/components/custom_button.dart';
import 'package:dirassa/core/components/custom_text_button.dart';
import 'package:dirassa/core/components/webview_screen.dart';
import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WebViewScreen(
                        url: 'https://www.google.com',
                        title: 'Google',
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
      ),
    );
  }
}
