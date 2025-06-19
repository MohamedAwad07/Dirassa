import 'package:flutter/material.dart';
import '../../core/app_strings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icons/Settings icons/png/Depth 4, Frame 0.png',
              height: 28,
            ),
            title: const Text(AppStrings.settingsAccount),
            onTap: () {},
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/Settings icons/png/Depth 4, Frame 0-1.png',
              height: 28,
            ),
            title: const Text(AppStrings.settingsNotifications),
            onTap: () {},
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/Settings icons/png/Depth 4, Frame 0-2.png',
              height: 28,
            ),
            title: const Text(AppStrings.settingsPrivacy),
            onTap: () {},
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/Settings icons/png/Depth 4, Frame 0-3.png',
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
