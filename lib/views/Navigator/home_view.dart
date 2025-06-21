import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_colors.dart';
import 'package:dirassa/core/components/connectivity_indicator.dart';
import 'package:dirassa/core/components/connectivity_wrapper.dart';
import 'package:dirassa/views/Navigator/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'profile/profile_view.dart';
import 'settings/settings_view.dart';
import '../../core/utils/app_strings.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConnectivityWrapper(
      showErrorScreen: true,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            const ConnectivityIndicator(size: 20),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileView(fromSettings: true),
                ),
              ),
              icon: Image.asset(
                Assets.assetsIconsAvatar,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeScreen(),
            ProfileView(fromSettings: false, showAppBar: true),
            SettingsView(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Image.asset(Assets.assetsImagesLogo, height: 60),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: AppColors.primary),
                title: Text(
                  AppStrings.home,
                  style: TextStyle(
                    color: _currentIndex == 0
                        ? AppColors.secondary
                        : theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selected: _currentIndex == 0,
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: AppColors.primary),
                title: Text(
                  AppStrings.profile,
                  style: TextStyle(
                    color: _currentIndex == 1
                        ? AppColors.secondary
                        : theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selected: _currentIndex == 1,
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: AppColors.primary),
                title: Text(
                  AppStrings.settings,
                  style: TextStyle(
                    color: _currentIndex == 2
                        ? AppColors.secondary
                        : theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selected: _currentIndex == 2,
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info, color: AppColors.primary),
                title: const Text(AppStrings.about),
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.privacy_tip,
                  color: AppColors.primary,
                ),
                title: const Text(AppStrings.privacyPolicy),
                onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(AppStrings.logout),
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
