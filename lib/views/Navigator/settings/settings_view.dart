import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/utils/app_strings.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isDarkMode = false;

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
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: child.key == const ValueKey('dark')
                    ? Tween<double>(begin: 1, end: 0.75).animate(animation)
                    : Tween<double>(begin: 0.75, end: 1).animate(animation),
                child: child,
              ),
              child: _isDarkMode
                  ? const Icon(
                      Icons.dark_mode,
                      key: ValueKey('dark'),
                      color: Colors.amber,
                      size: 28,
                    )
                  : const Icon(
                      Icons.light_mode,
                      key: ValueKey('light'),
                      color: Colors.blue,
                      size: 28,
                    ),
            ),
            title: const Text(AppStrings.appMode),
            trailing: Switch(
              activeColor: AppColors.secondary,
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
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
