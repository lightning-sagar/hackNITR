import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import 'theme/app_theme.dart';
import 'widgets/engagement_screen.dart';
import 'widgets/error_screens.dart';
import 'widgets/loading_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agricultural LMS',
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      home: const SmartWebViewScreen(),
    );
  }
}

// Testing with invalid URL to demonstrate fallback engagement screen
const String kHardcodedUrl = 'https://lms-iota-seven.vercel.app/';

enum LinkState { checking, available, unavailable }

class SmartWebViewScreen extends StatefulWidget {
  const SmartWebViewScreen({super.key});

  @override
  State<SmartWebViewScreen> createState() => _SmartWebViewScreenState();
}

class _SmartWebViewScreenState extends State<SmartWebViewScreen> {
  WebViewController? _controller;
  LinkState _linkState = LinkState.checking;
  double _progress = 0;
  bool _offline = false;
  late final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _validationTimer;
  Timer? _periodicCheckTimer;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      (results) => _handleConnectivity(results),
    );
    // Start with validation, NOT WebView creation
    _validateAndLoad();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _validationTimer?.cancel();
    _periodicCheckTimer?.cancel();
    _controller = null;
    super.dispose();
  }

  void _handleConnectivity(List<ConnectivityResult> results) {
    final offlineNow = results.contains(ConnectivityResult.none);
    setState(() => _offline = offlineNow);
    if (!offlineNow && _linkState == LinkState.unavailable) {
      _validateAndLoad();
    } else if (offlineNow && _linkState == LinkState.available) {
      _tearDownWebView();
      setState(() => _linkState = LinkState.unavailable);
    }
  }

  // Validate link BEFORE creating WebView
  Future<void> _validateAndLoad() async {
    if (!mounted) return;
    setState(() => _linkState = LinkState.checking);

    if (_offline) {
      setState(() => _linkState = LinkState.unavailable);
      _scheduleRetry();
      return;
    }

    final isReachable = await _validateUrl(kHardcodedUrl);

    if (!mounted) return;

    if (isReachable) {
      // Only NOW create the WebView
      _createWebView();
      setState(() => _linkState = LinkState.available);
      _startPeriodicCheck();
    } else {
      setState(() => _linkState = LinkState.unavailable);
      _scheduleRetry();
    }
  }

  // Network validation without WebView - uses HTTP HEAD request
  Future<bool> _validateUrl(String url) async {
    try {
      final response = await http
          .head(Uri.parse(url))
          .timeout(const Duration(seconds: 8));

      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  void _createWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final allowed =
                request.url.startsWith('http://') ||
                request.url.startsWith('https://');
            return allowed
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
          onProgress: (value) {
            if (mounted) {
              setState(() => _progress = value.clamp(0, 100) / 100);
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _progress = 1.0);
          },
          onWebResourceError: (_) {
            // Silently tear down and return to engagement
            if (mounted) {
              _tearDownWebView();
              setState(() => _linkState = LinkState.unavailable);
              _scheduleRetry();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(kHardcodedUrl));

    _controller = controller;
  }

  void _tearDownWebView() {
    _controller = null;
    _progress = 0;
  }

  void _scheduleRetry() {
    _validationTimer?.cancel();
    _validationTimer = Timer(const Duration(seconds: 6), () {
      if (mounted && _linkState == LinkState.unavailable && !_offline) {
        _validateAndLoad();
      }
    });
  }

  void _startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted && _linkState == LinkState.available) {
        _validateUrl(kHardcodedUrl).then((isReachable) {
          if (!isReachable && mounted) {
            _tearDownWebView();
            setState(() => _linkState = LinkState.unavailable);
            _scheduleRetry();
          }
        });
      }
    });
  }

  Future<void> _manualRetry() async => _validateAndLoad();

  /// Build the appropriate fallback screen based on state
  Widget _buildFallbackScreen() {
    if (_linkState == LinkState.checking) {
      // Show loading screen while checking
      return const LoadingScreen(
        key: ValueKey('checking'),
        message: 'Connecting to Agricultural LMS...',
      );
    } else if (_offline) {
      // Show no internet screen when offline
      return NoInternetScreen(
        key: const ValueKey('offline'),
        onRetry: _manualRetry,
      );
    } else {
      // Show server error screen when content unavailable
      return ServerErrorScreen(
        key: const ValueKey('unavailable'),
        onRetry: _manualRetry,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mutually exclusive rendering based on link state
    final showEngagement = _linkState != LinkState.available;

    return Scaffold(
      extendBodyBehindAppBar: _linkState == LinkState.available,
      appBar: _linkState == LinkState.available
          ? AppBar(
              backgroundColor: Colors.white.withOpacity(0.95),
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.1),
              title: const Text('Agricultural LMS'),
              actions: [
                IconButton(
                  tooltip: 'Reload',
                  onPressed: () => _controller?.reload(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
              bottom: _progress < 1
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(4),
                      child: LinearProgressIndicator(value: _progress),
                    )
                  : null,
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAFAFA), // Off-white
              Color(0xFFF1F8E9), // Very light green
              Color(0xFFE8F5E9), // Pale mint
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Mutually exclusive: show ONLY ONE at a time
            if (showEngagement)
              Positioned.fill(
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    child: _buildFallbackScreen(),
                  ),
                ),
              )
            else
              Positioned.fill(
                child: SafeArea(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    opacity: 1.0,
                    child: WebViewContainer(controller: _controller!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WebViewContainer extends StatelessWidget {
  const WebViewContainer({super.key, required this.controller});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
