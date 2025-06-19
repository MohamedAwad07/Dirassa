import 'package:dirassa/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomTextButton({
    required this.text,
    required this.onPressed,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: AppColors.secondary)),
    );
  }
}
