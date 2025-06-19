import 'package:dirassa/core/utils/app_assets.dart';
import 'package:dirassa/core/utils/app_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(color: AppColors.secondary),
        ),
        backgroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [HomeScreen(), ProfileView(), SettingsView()],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.assetsImagesLogo, height: 60),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: Text(
                AppStrings.home,
                style: TextStyle(
                  color: _currentIndex == 0 ? AppColors.secondary : null,
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
                  color: _currentIndex == 1 ? AppColors.secondary : null,
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
                  color: _currentIndex == 2 ? AppColors.secondary : null,
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
              leading: const Icon(Icons.privacy_tip, color: AppColors.primary),
              title: const Text(AppStrings.privacyPolicy),
              onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
            ),
          ],
        ),
      ),
    );
  }
}
