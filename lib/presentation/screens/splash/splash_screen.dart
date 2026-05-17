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
            Animate(
              effects: [
                FadeEffect(duration: 800.ms),
                ScaleEffect(begin: const Offset(0.8, 0.8), duration: 800.ms),
              ],
              child: Lottie.asset(
                'assets/lottie/splash_logo.json',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 32),
            
            Animate(
              delay: 400.ms,
              effects: [
                FadeEffect(duration: 600.ms),
                SlideEffect(begin: const Offset(0, 0.2), end: Offset.zero, duration: 600.ms),
              ],
              child: Text(
                'LABOUR PARTY',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.accentCyanLight,
                  letterSpacing: 2,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            Animate(
              delay: 600.ms,
              effects: [
                FadeEffect(duration: 600.ms),
              ],
              child: Text(
                'Professional Operations Management',
                style: AppTypography.bodyMedium,
              ),
            ),
            
            const SizedBox(height: 64),
            
            Animate(
              delay: 800.ms,
              effects: const [
                FadeEffect(),
              ],
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyanLight),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
