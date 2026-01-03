import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/agricultural_facts_service.dart';
import '../theme/app_theme.dart';

/// Loading screen with agriculture theme
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, this.message = 'Loading...'});

  final String message;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  final AgriculturalFactsService _factsService = AgriculturalFactsService();
  late String _currentFact;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _currentFact = _factsService.getRandomFact();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loading animation
              _buildLoadingAnimation(),
              const SizedBox(height: 32),

              // Loading message
              Text(
                widget.message,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Progress indicator
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: AppTheme.paleGreen.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Fact card
              _buildFactCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Card(
      elevation: 4,
      shadowColor: AppTheme.softShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 200,
        width: 200,
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
            'https://assets8.lottiefiles.com/packages/lf20_kcsr6fcp.json',
            repeat: true,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => RotationTransition(
              turns: _rotationController,
              child: const Icon(
                Icons.eco_rounded,
                size: 80,
                color: AppTheme.primaryGreen,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFactCard() {
    return Card(
      elevation: 2,
      color: AppTheme.pureWhite,
      shadowColor: AppTheme.softShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.agriculture_rounded,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Did you know?',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _currentFact,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal inline loading indicator for smaller spaces
class InlineLoadingIndicator extends StatelessWidget {
  const InlineLoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.size = 40,
  });

  final String message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryGreen,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.mediumText,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
