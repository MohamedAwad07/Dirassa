import 'package:dirassa/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? title;
  final bool showBackButton;
  final bool fromHome;

  const WebViewScreen({
    super.key,
    required this.url,
    this.title,
    this.showBackButton = true,
    this.fromHome = false,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            setState(() {
              _errorMessage = error.description;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.failedToLoadPage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text(AppStrings.reload),
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                        _controller.loadRequest(Uri.parse(widget.url));
                      },
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                if (widget.showBackButton) const SizedBox(height: 16),
                if (!widget.fromHome)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        if (widget.showBackButton)
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                        const Spacer(),
                        Center(
                          child: Text(
                            widget.title ?? " ",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 36),
                        const Spacer(),
                      ],
                    ),
                  ),
                Expanded(child: WebViewWidget(controller: _controller)),
              ],
            ),
    );
  }
}
