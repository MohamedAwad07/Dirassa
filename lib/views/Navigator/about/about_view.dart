import 'package:dirassa/core/components/custom_button.dart';
import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_strings.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.about,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Center(child: Image.asset(Assets.assetsImagesLogo, height: 100)),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.aboutIntro,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.aboutFeaturesHeader,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FeatureBullet(text: AppStrings.aboutFeature1),
                      FeatureBullet(text: AppStrings.aboutFeature2),
                      FeatureBullet(text: AppStrings.aboutFeature3),
                      FeatureBullet(text: AppStrings.aboutFeature4),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.aboutMissionHeader,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    AppStrings.aboutMission,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.aboutJoinHeader,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    AppStrings.aboutJoin,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              color: AppColors.secondary,
              text: AppStrings.privacyPolicyButton,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 32 * 2),
          ],
        ),
      ),
    );
  }
}

class FeatureBullet extends StatelessWidget {
  final String text;
  const FeatureBullet({required this.text, super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 18, color: AppColors.secondary),
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
