import 'package:flutter/material.dart';
import '../../core/app_strings.dart';

class ConnectionErrorView extends StatelessWidget {
  const ConnectionErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/conn_error.png', height: 120),
              const SizedBox(height: 32),
              const Text(
                AppStrings.connectionErrorTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.connectionErrorBody,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                child: const Text(AppStrings.connectionErrorRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
