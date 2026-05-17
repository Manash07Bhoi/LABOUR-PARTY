import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_durations.dart';
import '../shell/main_shell_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(AppDurations.splash, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShellScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/splash_logo.json',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ).animate().fade(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
            
            const SizedBox(height: 32),
            
            Text(
              'LABOUR PARTY',
              style: AppTypography.displayLarge.copyWith(
                color: AppColors.accentCyanLight,
                letterSpacing: 2,
              ),
            )
            .animate(delay: 400.ms)
            .fade(duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 8),
            
            Text(
              'Professional Operations Management',
              style: AppTypography.bodyMedium,
            )
            .animate(delay: 600.ms)
            .fade(duration: 600.ms),
            
            const SizedBox(height: 64),
            
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyanLight),
              strokeWidth: 2,
            ).animate(delay: 800.ms).fade(),
          ],
        ),
      ),
    );
  }
}
