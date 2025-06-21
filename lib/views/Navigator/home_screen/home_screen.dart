import 'package:dirassa/core/components/webview_screen.dart';
import 'package:dirassa/core/services/screenshot_prevention.dart';
import 'package:dirassa/viewmodels/cubits/url_cubit/url_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ScreenshotPrevention.preventScreenshots();
  }

  @override
  void dispose() {
    ScreenshotPrevention.allowScreenshots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrlCubit, UrlState>(
      builder: (context, urlState) {
        //   if (urlState.homeUrl != null) {
        //     return Scaffold(
        //       body: WebViewScreen(
        //         url: urlState.homeUrl!,
        //         showBackButton: false,
        //         title: AppStrings.home,
        //       ),
        //     );
        //   } else {
        //     return Scaffold(
        //       body: Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             if (urlState.status == UrlStatus.loading)
        //               const CircularProgressIndicator(
        //                 color: AppColors.primary,
        //               )
        //             else
        //               const Icon(
        //                 Icons.error_outline,
        //                 size: 48,
        //                 color: Colors.red,
        //               ),
        //             const SizedBox(height: 16),
        //             Text(
        //               urlState.status == UrlStatus.loading
        //                   ? AppStrings.loading
        //                   : AppStrings.failedToLoadPage,
        //               style: const TextStyle(fontSize: 16),
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   }
        // },
        return const Scaffold(
          body: WebViewScreen(
            fromHome: true,
            url: "https://www.google.com",
            showBackButton: false,
          ),
        );
      },
    );
  }
}
