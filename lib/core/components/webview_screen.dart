import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? title;
  final bool showBackButton;

  const WebViewScreen({
    super.key,
    required this.url,
    this.title,
    this.showBackButton = true,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 16,
        children: [
          if (widget.showBackButton) const SizedBox(height: 36),
          Row(
            children: [
              if (widget.showBackButton)
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              const Spacer(),
              Center(
                child: Text(
                  widget.title ?? 'WebView',
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
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
