import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        120,
                  ),
                  child: const LoginForm(),
                ),
              ),
            ),
            Image.asset(
              Assets.assetsImagesLoginLanding2,
              color: AppColors.primary,
              height: 120,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
