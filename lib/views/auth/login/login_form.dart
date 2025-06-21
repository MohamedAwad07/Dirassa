import 'package:dirassa/core/components/app_logo.dart';
import 'package:dirassa/core/components/custom_button.dart';
import 'package:dirassa/core/components/custom_text_button.dart';
import 'package:dirassa/core/components/custom_text_field.dart';
import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/app_strings.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text(AppStrings.loginError))),
      );
    } else {
      // TODO: Connect to AuthCubit or your login logic
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Text(
            AppStrings.loginTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              AppStrings.loginDescription,
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
          const AppLogo(),
          CustomTextField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            label: AppStrings.loginEmail,
            prefixIcon: SvgPicture.asset(
              Assets.assetsIconsLoginMail,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            label: AppStrings.loginPhone,
            prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
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
          RememberMeCheckbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: AppStrings.loginButton,
            onPressed: () => _onLoginPressed(context),
          ),
          const SizedBox(height: 16),
          CustomTextButton(
            text: AppStrings.loginNoAccount,
            onPressed: () => Navigator.pushNamed(context, '/register'),
          ),
        ],
      ),
    );
  }
}

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  const RememberMeCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
        const Text('تذكرني'),
      ],
    );
  }
}
