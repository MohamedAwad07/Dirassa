import 'package:dirassa/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import '../../views/splash/splash_view.dart';
import '../../auth/login/login_view.dart';
import '../../auth/register/register_view.dart';
import '../../views/home/home_view.dart';
import '../../views/home/profile/profile_view.dart';
import '../../views/home/settings/settings_view.dart';
import '../../views/about/about_view.dart';
import '../../views/home/privacy_policy/privacy_policy_view.dart';
import '../../views/connection_error/connection_error_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashView());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeView());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutView());
      case '/privacy-policy':
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyView());
      case '/connection-error':
        return MaterialPageRoute(builder: (_) => const ConnectionErrorView());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text(AppStrings.pageNotFound)),
          ),
        );
    }
  }
}
