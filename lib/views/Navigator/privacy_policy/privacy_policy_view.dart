import 'dart:developer';

import 'package:dirassa/core/components/custom_button.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
            const ClickablePolicyText(AppStrings.privacyContact),
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

class ClickablePolicyText extends StatelessWidget {
  final String text;
  const ClickablePolicyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    // Extract URL from text (assuming format: "زوروا موقعنا : https://dirassa.online")
    final urlMatch = RegExp(r'https?://[^\s]+').firstMatch(text);
    final url = urlMatch?.group(0);

    log('🔗 Debug: Text = $text');
    log('🔗 Debug: Extracted URL = $url');

    if (url != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: GestureDetector(
          onTap: () async {
            log('🔗 Debug: Link tapped!');
            try {
              final uri = Uri.parse(url);
              log('🔗 Debug: Parsed URI = $uri');

              final result = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              log('🔗 Debug: launchUrl result = $result');

              if (!result) {
                log('🔗 Debug: launchUrl returned false');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('لا يمكن فتح الرابط'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } catch (e) {
              log('🔗 Debug: Error launching URL: $e');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('خطأ في فتح الرابط: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.secondary,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
