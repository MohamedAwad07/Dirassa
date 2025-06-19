import 'package:flutter/material.dart';
import '../../core/app_strings.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: Column(
        children: [
          const SizedBox(height: 32),
          const Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/icons/avatar.png'),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.profileUsername,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(AppStrings.profileEmail),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text(AppStrings.profileAccountSettings),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text(AppStrings.profilePrivacyPolicy),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(AppStrings.profileLogout),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
