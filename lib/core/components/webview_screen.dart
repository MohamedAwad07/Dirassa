import 'dart:developer';

import 'package:dirassa/core/services/token_storage_service.dart';
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
  bool _isRedirecting = false;
  bool _sessionHandled = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (!_isInitialized) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (error) {
              if (mounted) {
                setState(() {
                  _errorMessage = error.description;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              // Check if the URL contains "no_session_available"
              if (request.url.contains('012')) {
                log(
                  '🔍 WebView: Session expired detected in URL: ${request.url}',
                );
                _handleSessionExpired();
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              // Also check on page finish in case of redirects
              if (url.contains('012')) {
                log(
                  '🔍 WebView: Session expired detected on page finish: $url',
                );
                _handleSessionExpired();
              }
            },
          ),
        )
        ..enableZoom(false)
        ..loadRequest(Uri.parse(widget.url));

      _isInitialized = true;
    }
  }

  void _handleSessionExpired() async {
    if (_sessionHandled) return;
    _sessionHandled = true;
    try {
      log('🔍 WebView: Handling session expiration...');
      setState(() {
        _isRedirecting = true;
      });
      await TokenStorageService.clearToken();
      log('🔍 WebView: Cached token cleared');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        log('🔍 WebView: Navigated to login screen');
      }
    } catch (e) {
      log('🔍 WebView: Error handling session expiration: $e');
      if (mounted) {
        setState(() {
          _isRedirecting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.url);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          _errorMessage != null
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
                    Expanded(
                      child: RepaintBoundary(
                        child: WebViewWidget(
                          key: ValueKey('webview_${widget.url}'),
                          controller: _controller,
                        ),
                      ),
                    ),
                  ],
                ),
          // Redirecting overlay
          if (_isRedirecting)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        AppStrings.sessionExpiredTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        AppStrings.sessionExpiredMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
