import 'package:dirassa/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import '../../views/splash/splash_view.dart';
import '../../views/auth/login/login_view.dart';
import '../../views/auth/register/register_view.dart';
import '../../views/Navigator/home_view.dart';
import '../../views/Navigator/profile/profile_view.dart';
import '../../views/Navigator/settings/settings_view.dart';
import '../../views/Navigator/about/about_view.dart';
import '../../views/Navigator/privacy_policy/privacy_policy_view.dart';
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
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProfileView(
            fromSettings: args?['fromSettings'] ?? false,
            showAppBar: args?['showAppBar'] ?? false,
          ),
        );
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
