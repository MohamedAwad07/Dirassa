import 'package:dirassa/core/components/app_logo.dart';
import 'package:dirassa/core/components/custom_button.dart';
import 'package:dirassa/core/components/custom_text_button.dart';
import 'package:dirassa/core/components/custom_text_field.dart';
import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:dirassa/core/utils/app_device_utils.dart';
import 'package:dirassa/models/Login/login_request.dart';
import 'package:dirassa/viewmodels/cubits/auth_cubit/auth_cubit.dart';
import 'package:dirassa/viewmodels/cubits/url_cubit/url_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/app_strings.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context, String? loginUrl) async {
    FocusScope.of(context).unfocus();
    if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text(AppStrings.loginError))),
      );
    } else {
      final LoginRequest loginRequest = LoginRequest(
        username: _nameController.text,
        password: _passwordController.text,
        deviceId: await DeviceUtils.getDeviceId(),
      );
      if (loginUrl != null && loginUrl.isNotEmpty) {
        // ignore: use_build_context_synchronously
        context.read<AuthCubit>().login('$loginUrl/', loginRequest);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text(AppStrings.pageNotFound))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(child: Text(state.message)),
              backgroundColor: Colors.red,
            ),
          );
          // Reset the state after showing the error
          context.read<AuthCubit>().reset();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24 * 3),
            const Text(
              AppStrings.loginTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const AppLogo(),
            CustomTextField(
              keyboardType: TextInputType.name,
              controller: _nameController,
              label: AppStrings.loginName,
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              label: AppStrings.loginPassword,
              prefixIcon: SvgPicture.asset(
                Assets.assetsIconsLoginLock,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              obscureText: _obscureText,
              suffixIcon: SvgPicture.asset(
                Assets.assetsIconsLoginEye,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              onSuffixIconPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
                child: const Text.rich(
                  TextSpan(
                    text: AppStrings.loginDescription,
                    style: TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: AppStrings.privacyPolicy,
                        style: TextStyle(
                          color: AppColors.secondary,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<UrlCubit, UrlState>(
              builder: (context, state) {
                return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    return authState is AuthLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: AppStrings.loginButton,
                            onPressed: () =>
                                _onLoginPressed(context, state.loginUrl),
                          );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            CustomTextButton(
              text: AppStrings.loginNoAccount,
              onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
          ],
        ),
      ),
    );
  }
}
