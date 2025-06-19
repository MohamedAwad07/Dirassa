import 'package:dirassa/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/utils/app_strings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: SvgPicture.asset(
              Assets.assetsIconsSettingsLanguage,
              height: 28,
            ),
            title: const Text(AppStrings.settingsAccount),
            onTap: () {},
          ),
          ListTile(
            leading: SvgPicture.asset(
              Assets.assetsIconsSettingsLanguage,
              height: 28,
            ),
            title: const Text(AppStrings.settingsNotifications),
            onTap: () {},
          ),
          ListTile(
            leading: SvgPicture.asset(
              Assets.assetsIconsSettingsLanguage,
              height: 28,
            ),
            title: const Text(AppStrings.settingsPrivacy),
            onTap: () {},
          ),
          ListTile(
            leading: SvgPicture.asset(
              Assets.assetsIconsSettingsLanguage,
              height: 28,
            ),
            title: const Text(AppStrings.settingsHelp),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
