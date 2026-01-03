import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/agricultural_facts_service.dart';
import '../theme/app_theme.dart';

/// Error screen displayed when there's no internet connection
class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {
  final AgriculturalFactsService _factsService = AgriculturalFactsService();
  late String _currentFact;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _currentFact = _factsService.getRandomFact();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _refreshFact() {
    setState(() {
      _currentFact = _factsService.getRandomFact();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAFAFA), Color(0xFFF1F8E9), Color(0xFFE8F5E9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Animated no connection illustration
              _buildConnectionAnimation(),
              const SizedBox(height: 32),

              // Title
              Text(
                'No Internet Connection',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                "It seems you're offline. Don't worry, we'll reconnect automatically when your internet is back.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.mediumText,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Connectivity tips card
              _buildConnectivityTipsCard(),
              const SizedBox(height: 20),

              // Agriculture fact while waiting
              _buildFactCard(),
              const SizedBox(height: 32),

              // Action buttons
              _buildActionButtons(),
              const SizedBox(height: 16),

              // Status indicator
              _buildStatusIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionAnimation() {
    return FadeTransition(
      opacity: _pulseController,
      child: Card(
        elevation: 4,
        shadowColor: AppTheme.softShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Lottie.network(
              'https://assets5.lottiefiles.com/packages/lf20_yyytpd8u.json',
              repeat: true,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 80,
                    color: AppTheme.primaryGreen.withOpacity(0.7),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warningYellow.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.signal_wifi_off_rounded,
                          size: 16,
                          color: AppTheme.darkText,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Offline',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectivityTipsCard() {
    return Card(
      elevation: 2,
      color: AppTheme.pureWhite,
      shadowColor: AppTheme.softShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.infoBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppTheme.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              Icons.wifi_rounded,
              'Try switching to Wi-Fi if on mobile data',
            ),
            _buildTipItem(
              Icons.signal_cellular_alt,
              'Switch to mobile data if Wi-Fi is slow',
            ),
            _buildTipItem(
              Icons.location_on_outlined,
              'Move to an area with better signal',
            ),
            _buildTipItem(
              Icons.airplanemode_inactive,
              'Check if airplane mode is off',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryGreen.withOpacity(0.8)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactCard() {
    return Card(
      elevation: 2,
      color: AppTheme.paleGreen.withOpacity(0.3),
      shadowColor: AppTheme.softShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.eco_rounded,
                      color: AppTheme.primaryGreen,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Did you know?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _refreshFact,
                  icon: const Icon(Icons.refresh_rounded),
                  color: AppTheme.primaryGreen,
                  tooltip: 'New fact',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _currentFact,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.darkText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.warningYellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.warningYellow.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Checking connection automatically...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.darkText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error screen for server/content unavailable
class ServerErrorScreen extends StatefulWidget {
  const ServerErrorScreen({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  State<ServerErrorScreen> createState() => _ServerErrorScreenState();
}

class _ServerErrorScreenState extends State<ServerErrorScreen> {
  final AgriculturalFactsService _factsService = AgriculturalFactsService();
  late String _currentFact;

  @override
  void initState() {
    super.initState();
    _currentFact = _factsService.getRandomFact();
  }

  void _refreshFact() {
    setState(() {
      _currentFact = _factsService.getRandomFact();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAFAFA), Color(0xFFF1F8E9), Color(0xFFE8F5E9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Server error illustration
              _buildErrorIllustration(),
              const SizedBox(height: 32),

              // Title
              Text(
                'Content Unavailable',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                "The page isn't responding right now. We're reconnecting automatically, or you can try again.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.mediumText,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Agriculture fact while waiting
              _buildFactCard(),
              const SizedBox(height: 32),

              // Action buttons
              _buildActionButtons(),
              const SizedBox(height: 16),

              // Status message
              _buildStatusMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIllustration() {
    return Card(
      elevation: 4,
      shadowColor: AppTheme.softShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Lottie.network(
            'https://assets2.lottiefiles.com/packages/lf20_kcsr6fcp.json',
            repeat: true,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 80,
                  color: AppTheme.primaryGreen.withOpacity(0.7),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningYellow.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Reconnecting...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFactCard() {
    return Card(
      elevation: 2,
      color: AppTheme.paleGreen.withOpacity(0.3),
      shadowColor: AppTheme.softShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.agriculture_rounded,
                      color: AppTheme.primaryGreen,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Farming Insight',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _refreshFact,
                  icon: const Icon(Icons.refresh_rounded),
                  color: AppTheme.primaryGreen,
                  tooltip: 'New insight',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _currentFact,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.darkText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Try Again Now'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.infoBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.infoBlue.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Automatic reconnection in progress',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.darkText,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
