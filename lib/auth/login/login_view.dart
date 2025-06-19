import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const Expanded(child: SingleChildScrollView(child: LoginForm())),
          Image.asset(
            Assets.assetsImagesLoginLanding2,
            color: AppColors.primary,
            height: 100,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
