import 'package:dirassa/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Image.asset(Assets.assetsImagesLogo, height: 90),
    );
  }
}
