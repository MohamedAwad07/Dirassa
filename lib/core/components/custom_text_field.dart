import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: SizedBox(
          width: 24,
          height: 24,
          child: Center(child: prefixIcon),
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixIconPressed,
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(child: suffixIcon),
                ),
              )
            : null,
      ),
    );
  }
}
