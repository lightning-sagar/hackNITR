import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/agricultural_facts_service.dart';
import '../theme/app_theme.dart';

/// Engagement screen shown when waiting for content to load
/// Features agricultural facts and educational content
class EngagementScreen extends StatefulWidget {
  const EngagementScreen({
    super.key,
    this.onRetry,
    this.showRetryButton = false,
  });

  final VoidCallback? onRetry;
  final bool showRetryButton;

  @override
  State<EngagementScreen> createState() => _EngagementScreenState();
}

class _EngagementScreenState extends State<EngagementScreen> {
  final PageController _pageController = PageController();
  final AgriculturalFactsService _factsService = AgriculturalFactsService();
  late List<String> _currentFacts;
  int _currentFactIndex = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _currentFacts = _factsService.getRandomFacts(5);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted) return;

      final nextPage = (_currentFactIndex + 1) % _currentFacts.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      setState(() => _currentFactIndex = nextPage);
    });
  }

  void _refreshFacts() {
    setState(() {
      _currentFacts = _factsService.getRandomFacts(5);
      _currentFactIndex = 0;
      _pageController.jumpToPage(0);
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
              // Header with icon
              _buildHeader(context),
              const SizedBox(height: 24),

              // Main animation card
              _buildAnimationCard(),
              const SizedBox(height: 24),

              // Facts carousel
              _buildFactsCarousel(),
              const SizedBox(height: 16),

              // Page indicator
              _buildPageIndicator(),
              const SizedBox(height: 24),

              // Quick facts grid
              _buildQuickFactsGrid(),
              const SizedBox(height: 20),

              // Action buttons
              if (widget.showRetryButton) _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.agriculture_rounded,
            color: AppTheme.primaryGreen,
            size: 32,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Smart Farming',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.darkText,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Livestock Intelligence',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumText),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimationCard() {
    return Card(
      elevation: 4,
      shadowColor: AppTheme.softShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background illustration
            Positioned.fill(
              child: Center(
                child: Lottie.network(
                  'https://assets8.lottiefiles.com/packages/lf20_kcsr6fcp.json',
                  repeat: true,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.eco_rounded,
                    size: 100,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ),
            // Overlay text
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Loading your agricultural insights...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactsCarousel() {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentFactIndex = index),
        itemCount: _currentFacts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 3,
              color: AppTheme.pureWhite,
              shadowColor: AppTheme.softShadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForFact(index),
                      color: AppTheme.primaryGreen,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentFacts[index],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.darkText,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _currentFacts.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentFactIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentFactIndex == index
                ? AppTheme.primaryGreen
                : AppTheme.primaryGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFactsGrid() {
    final quickFacts = [
      (Icons.water_drop_outlined, 'Hydration', 'Key to health'),
      (Icons.restaurant_outlined, 'Nutrition', 'Balanced diet'),
      (Icons.health_and_safety_outlined, 'Prevention', 'Regular checks'),
      (Icons.wb_sunny_outlined, 'Environment', 'Clean & safe'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: quickFacts.length,
      itemBuilder: (context, index) {
        final (icon, title, subtitle) = quickFacts[index];
        return Card(
          elevation: 2,
          color: AppTheme.pureWhite,
          shadowColor: AppTheme.softShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppTheme.primaryGreen, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumText),
                ),
              ],
            ),
          ),
        );
      },
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
            label: const Text('Retry Connection'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _refreshFacts,
          icon: const Icon(Icons.autorenew_rounded),
          label: const Text('Show New Facts'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconForFact(int index) {
    final icons = [
      Icons.pets_rounded,
      Icons.water_drop_rounded,
      Icons.agriculture_rounded,
      Icons.health_and_safety_rounded,
      Icons.eco_rounded,
    ];
    return icons[index % icons.length];
  }
}
