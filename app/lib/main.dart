import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final controller = WebViewController();

    // Configure WebView with platform-safe settings
    try {
      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    } catch (e) {
      // Platform doesn't support JavaScript mode configuration
    }

    try {
      controller.setBackgroundColor(Colors.transparent);
    } catch (e) {
      // Platform doesn't support background color
    }

    try {
      controller.enableZoom(false);
    } catch (e) {
      // Platform doesn't support zoom configuration
    }

    controller.setNavigationDelegate(
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
    );

    controller.loadRequest(Uri.parse(kHardcodedUrl));
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
    final topInset = MediaQuery.of(
      context,
    ).padding.top; // only status bar inset

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: false,
          left: false,
          right: false,
          child: Padding(
            padding: EdgeInsets.only(top: topInset),
            child: Stack(
              children: [
                // Full-screen WebView or fallback screens
                if (showEngagement)
                  Positioned.fill(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: _buildFallbackScreen(),
                    ),
                  )
                else
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: 1.0,
                      child: ImmersiveWebView(
                        controller: _controller!,
                        onRefresh: _manualRetry,
                      ),
                    ),
                  ),

                // Minimal loading indicator overlay (only when loading content)
                if (_linkState == LinkState.available &&
                    _progress < 1 &&
                    _progress > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildMinimalProgressBar(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Minimal progress bar for content loading
  Widget _buildMinimalProgressBar() {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withOpacity(0.8),
            AppTheme.lightGreen.withOpacity(0.6),
          ],
        ),
      ),
      child: LinearProgressIndicator(
        value: _progress,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppTheme.primaryGreen.withOpacity(0.3),
        ),
      ),
    );
  }
}

/// Immersive full-screen WebView with pull-to-refresh
class ImmersiveWebView extends StatelessWidget {
  const ImmersiveWebView({
    super.key,
    required this.controller,
    required this.onRefresh,
  });

  final WebViewController controller;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: AppTheme.primaryGreen,
        backgroundColor: Colors.white,
        displacement: 52,
        strokeWidth: 3,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: WebViewWidget(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
