import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_router.dart';
import 'cubits/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/app_strings.dart';

void main() {
  runApp(BlocProvider(create: (_) => AuthCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Cairo'),
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
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
