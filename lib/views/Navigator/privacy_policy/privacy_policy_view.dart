import 'package:dirassa/core/components/custom_button.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_strings.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.privacyPolicy,
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
            const SectionHeader(AppStrings.privacyIntroHeader),
            const PolicyText(AppStrings.privacyIntro),
            const SectionHeader(AppStrings.privacyInfoHeader),
            const PolicyText(AppStrings.privacyInfo),
            const SectionHeader(AppStrings.privacyCookiesHeader),
            const PolicyText(AppStrings.privacyCookies),
            const SectionHeader(AppStrings.privacyRightsHeader),
            const BulletList([
              AppStrings.privacyRight1,
              AppStrings.privacyRight2,
            ]),
            const SectionHeader(AppStrings.privacyChangesHeader),
            const PolicyText(AppStrings.privacyChanges),
            const SectionHeader(AppStrings.privacyContactHeader),
            const PolicyText(AppStrings.privacyContact),
            const SizedBox(height: 32),
            CustomButton(
              color: AppColors.secondary,
              text: AppStrings.privacyPolicyButton,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String text;
  const SectionHeader(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: AppColors.secondary,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

class PolicyText extends StatelessWidget {
  final String text;
  const PolicyText(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    ),
  );
}

class BulletList extends StatelessWidget {
  final List<String> items;
  const BulletList(this.items, {super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items
        .map(
          (item) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(fontSize: 16, color: AppColors.secondary),
              ),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 16))),
            ],
          ),
        )
        .toList(),
  );
}
