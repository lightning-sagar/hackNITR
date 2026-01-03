import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'theme/app_theme.dart';

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
            Positioned(
              top: -60,
              left: -30,
              child: _GlowBlob(color: AppTheme.primaryGreen.withOpacity(0.15)),
            ),
            Positioned(
              bottom: -40,
              right: -10,
              child: _GlowBlob(color: AppTheme.mintGreen.withOpacity(0.18)),
            ),
            // Mutually exclusive: show ONLY ONE at a time
            if (showEngagement)
              Positioned.fill(
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    child: FallbackPanel(
                      key: ValueKey(_linkState),
                      offline: _offline,
                      checking: _linkState == LinkState.checking,
                      onRetry: _manualRetry,
                    ),
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

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 8),
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 100,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }
}

class FallbackPanel extends StatefulWidget {
  const FallbackPanel({
    super.key,
    required this.offline,
    required this.checking,
    required this.onRetry,
  });

  final bool offline;
  final bool checking;
  final VoidCallback onRetry;

  @override
  State<FallbackPanel> createState() => _FallbackPanelState();
}

class _FallbackPanelState extends State<FallbackPanel> {
  final ValueNotifier<int?> _pollChoice = ValueNotifier<int?>(null);
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _factIndex = 0;

  final List<String> _funFacts = const [
    'Flutter renders with Skia so your UI looks crisp on every device.',
    'You can hot-reload UI tweaks without losing state.',
    'WebView content can be secured with sandboxing and CSP.',
    'Animations stay smooth at 60fps when your UI is lightweight.',
  ];

  @override
  void dispose() {
    _pollChoice.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surfaceVariant.withOpacity(0.5);

    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -40,
          child: _GlowBlob(color: AppTheme.primaryGreen.withOpacity(0.12)),
        ),
        Positioned(
          bottom: -90,
          left: -30,
          child: _GlowBlob(color: AppTheme.mintGreen.withOpacity(0.10)),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    widget.offline
                        ? Icons.wifi_off_rounded
                        : Icons.public_off_outlined,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.offline
                          ? "You're offline. We'll reconnect when you're back."
                          : widget.checking
                          ? "Checking connection…"
                          : "This page isn't responding right now. We're reconnecting automatically.",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Card(
                  elevation: 4,
                  shadowColor: AppTheme.softShadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFF1F8E9), // Very light green
                              Color(0xFFE8F5E9), // Pale mint
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Center(
                        child: Lottie.network(
                          'https://assets8.lottiefiles.com/packages/lf20_kcsr6fcp.json',
                          repeat: true,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.agriculture_outlined,
                            size: 88,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 8,
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry now'),
                  ),
                  FilledButton.icon(
                    onPressed: () => _nextFact(),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Inspire me'),
                  ),
                  if (widget.offline)
                    Chip(
                      avatar: const Icon(Icons.wifi_off, size: 18),
                      label: const Text('Offline mode'),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInformationalCards(surface, colorScheme),
              const SizedBox(height: 12),
              _buildPoll(surface),
              const SizedBox(height: 12),
              _buildFunFacts(surface),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInformationalCards(Color surface, ColorScheme colorScheme) {
    final cards = [
      ('Quick tip', 'Use pull-to-refresh anytime to retry loading the page.'),
      (
        'Pro insight',
        'Monitor your livestock data and agricultural metrics in real-time.',
      ),
      (
        'Smart farming',
        'Access reliable insights for better farming decisions and livestock health.',
      ),
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _pageController,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final (title, body) = cards[index];
          return Padding(
            padding: EdgeInsets.only(right: index == cards.length - 1 ? 0 : 12),
            child: Card(
              elevation: 2,
              color: AppTheme.pureWhite,
              shadowColor: AppTheme.softShadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(body),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.swipe, color: colorScheme.primary, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Swipe for more',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: colorScheme.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPoll(Color surface) {
    final options = const [
      'Show me trending articles',
      'I prefer quick summaries',
      'Let me explore on my own',
    ];

    return ValueListenableBuilder<int?>(
      valueListenable: _pollChoice,
      builder: (context, selected, _) {
        return Card(
          elevation: 2,
          color: AppTheme.pureWhite,
          shadowColor: AppTheme.softShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help us tailor the view',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...List.generate(options.length, (index) {
                  final isSelected = selected == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ChoiceChip(
                      label: Text(options[index]),
                      selected: isSelected,
                      onSelected: (_) => _pollChoice.value = index,
                    ),
                  );
                }),
                const SizedBox(height: 4),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected != null ? 1 : 0.6,
                  child: Text(
                    selected != null
                        ? 'Thanks! We will prioritize ${options[selected].toLowerCase()}.'
                        : 'Pick an option to keep us busy while the page loads.',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFunFacts(Color surface) {
    return Card(
      elevation: 2,
      color: AppTheme.pureWhite,
      shadowColor: AppTheme.softShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fun fact', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_funFacts[_factIndex]),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _nextFact,
                icon: const Icon(Icons.autorenew, size: 18),
                label: const Text('Another one'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextFact() {
    setState(() {
      _factIndex = (_factIndex + 1) % _funFacts.length;
    });
  }
}
