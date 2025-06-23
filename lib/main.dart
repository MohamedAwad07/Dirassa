import 'package:dirassa/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/utils/app_router.dart';
import 'core/services/status_bar_config.dart';
import 'core/services/screenshot_prevention.dart';
import 'viewmodels/cubits/auth_cubit/auth_cubit.dart';
import 'viewmodels/cubits/theme_cubit/theme_cubit.dart';
import 'viewmodels/cubits/connectivity_cubit/connectivity_cubit.dart';
import 'viewmodels/cubits/url_cubit/url_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/app_strings.dart';
import 'core/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = Observe();
  ScreenshotPrevention.initialize();

  // Set preferred orientations to allow both portrait and landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit(), lazy: false),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
          lazy: false,
        ),
        BlocProvider<ConnectivityCubit>(
          create: (context) => ConnectivityCubit(),
          lazy: false,
        ),
        BlocProvider<UrlCubit>(create: (context) => UrlCubit(), lazy: true),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    // Set navigator key for screenshot prevention
    ScreenshotPrevention.setNavigatorKey(navigatorKey);

    return BlocSelector<ThemeCubit, ThemeState, ThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, themeMode) {
        StatusBarConfig.setStatusBarForTheme(themeMode);

        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: const Locale('ar'),
          supportedLocales: [const Locale('ar')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/splash',
          onGenerateRoute: AppRouter.generateRoute,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );
      },
    );
  }
}
