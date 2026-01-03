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
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minimal loading animation
              _buildLoadingAnimation(),
              const SizedBox(height: 24),

              // Loading message
              Text(
                widget.message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.mediumText,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Minimal progress indicator
              SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  backgroundColor: AppTheme.paleGreen.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: AppTheme.paleGreen.withOpacity(0.1),
        shape: BoxShape.circle,
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
              size: 60,
              color: AppTheme.primaryGreen,
            ),
          ),
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
