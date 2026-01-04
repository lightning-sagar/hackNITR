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
  DateTime? _lastBackPressAt;
  bool _isHandlingBack = false;
  static const Duration _exitPromptWindow = Duration(seconds: 2);

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

    // Note: DOM storage is enabled by default in webview_flutter 4.x
    // Note: Media playback settings are managed by the platform

    // Disable zoom to prevent issues with responsive layouts
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

  // Centralized back handling that mirrors browser navigation before exiting.
  Future<bool> _handleBackPress() async {
    if (_isHandlingBack) return false;
    _isHandlingBack = true;

    try {
      // 1) Let Flutter navigator pop any dialogs/routes first.
      final navigator = Navigator.of(context);
      final popped = await navigator.maybePop();
      if (popped) return false;

      // 2) If WebView has history, go back there instead of exiting.
      final controller = _controller;
      if (controller != null && await controller.canGoBack()) {
        await controller.goBack();
        return false;
      }

      // 3) Root: require two back presses within the window to exit.
      final now = DateTime.now();
      final shouldExit =
          _lastBackPressAt != null && now.difference(_lastBackPressAt!) < _exitPromptWindow;

      _lastBackPressAt = now;

      if (shouldExit) {
        return true; // Allow system to close the app.
      }

      _showExitToast();
      return false;
    } finally {
      _isHandlingBack = false;
    }
  }

  void _showExitToast() {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Press back button again to exit'),
          duration: _exitPromptWindow,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
        ),
      );
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
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: _handleBackPress,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: Colors.white,
          // Remove app bar for immersive experience
          appBar: null,
          body: Stack(
            children: [
              // Full-screen content: WebView or fallback screens
              if (showEngagement)
                // Fallback screens when connection unavailable
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _buildFallbackScreen(),
                  ),
                )
              else
                // Immersive WebView with safe-area padding at top only
                Positioned.fill(
                  child: Column(
                    children: [
                      // Safe-area padding for status bar / notch
                      SizedBox(height: statusBarHeight),
                      // WebView fills remaining space with native scrolling
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 400),
                          opacity: 1.0,
                          child: ImmersiveWebView(
                            controller: _controller!,
                            onRefresh: _manualRetry,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Minimal loading progress bar (only during page load)
              if (_linkState == LinkState.available &&
                  _progress < 1 &&
                  _progress > 0)
                Positioned(
                  top: statusBarHeight,
                  left: 0,
                  right: 0,
                  child: _buildMinimalProgressBar(),
                ),
            ],
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

/// Immersive full-screen WebView with native scrolling
/// - No parent scroll container wrapping the WebView
/// - WebView handles all vertical scrolling natively
/// - Safe-area aware positioning
/// - Pull-to-refresh support via gesture detection
class ImmersiveWebView extends StatefulWidget {
  const ImmersiveWebView({
    super.key,
    required this.controller,
    required this.onRefresh,
  });

  final WebViewController controller;
  final Future<void> Function() onRefresh;

  @override
  State<ImmersiveWebView> createState() => _ImmersiveWebViewState();
}

class _ImmersiveWebViewState extends State<ImmersiveWebView> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen WebView with native scrolling
        // ✓ NOT wrapped in any scroll container (CustomScrollView, SingleChildScrollView, etc.)
        // ✓ NOT constrained by parent scroll physics
        // ✓ Handles its own scroll gestures and momentum natively
        // ✓ Supports smooth fling and bounce scrolling
        WebViewWidget(
          controller: widget.controller,
        ),

        // Pull-to-refresh overlay (non-blocking)
        // Only visible when refreshing
        if (_isRefreshing)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryGreen,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
