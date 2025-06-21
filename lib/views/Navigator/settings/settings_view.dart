import 'package:dirassa/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/components/theme_toggle.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          AppStrings.settings,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(AppStrings.settingsAccount),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/profile',
                arguments: {'fromSettings': true},
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text(AppStrings.appMode),
            trailing: const ThemeToggle(showLabel: false),
            onTap: () {
              // Theme toggle is handled by the ThemeToggle widget
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              Assets.assetsIconsSettingsActive,
              height: 28,
            ),
            title: const Text(AppStrings.settingsPrivacy),
            onTap: () {
              Navigator.pushNamed(context, '/privacy-policy');
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              Assets.assetsIconsSettingsInfo,
              height: 28,
            ),
            title: const Text(AppStrings.settingsHelp),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
